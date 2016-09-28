/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Application delegate class.
 */

#import "APLViewController.h"
#import "Reachability.h"

#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>

#import <arpa/inet.h>
#import <ifaddrs.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@interface APLViewController ()

@property (nonatomic, weak) IBOutlet UILabel* summaryLabel;

@property (nonatomic, weak) IBOutlet UITextField *remoteHostLabel;
@property (nonatomic, weak) IBOutlet UIImageView *remoteHostImageView;
@property (nonatomic, weak) IBOutlet UITextField *remoteHostStatusField;

@property (nonatomic, weak) IBOutlet UIImageView *internetConnectionImageView;
@property (nonatomic, weak) IBOutlet UITextField *internetConnectionStatusField;

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;

@end




@implementation APLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.summaryLabel.hidden = YES;

    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];

    //Change the host name here to change the server you want to monitor.
    NSString *remoteHostName = @"www.apple.com";
    NSString *remoteHostLabelFormatString = NSLocalizedString(@"Remote Host: %@", @"Remote host label format string");
    self.remoteHostLabel.text = [NSString stringWithFormat:remoteHostLabelFormatString, remoteHostName];
    
	self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
	[self.hostReachability startNotifier];
	[self updateInterfaceWithReachability:self.hostReachability];

    self.internetReachability = [Reachability reachabilityForInternetConnection];
	[self.internetReachability startNotifier];
	[self updateInterfaceWithReachability:self.internetReachability];

    
    LOGINFO(@"%@", [self getIPAddress]);
    LOGINFO(@"%@", [self getDeviceIPIpAddresses]);
}


/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
	[self updateInterfaceWithReachability:curReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == self.hostReachability)
	{
		[self configureTextField:self.remoteHostStatusField imageView:self.remoteHostImageView reachability:reachability];
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        BOOL connectionRequired = [reachability connectionRequired];

        self.summaryLabel.hidden = (netStatus != ReachableViaWWAN);
        NSString* baseLabelText = @"";
        
        if (connectionRequired)
        {
            baseLabelText = NSLocalizedString(@"Cellular data network is available.\nInternet traffic will be routed through it after a connection is established.", @"Reachability text if a connection is required");
        }
        else
        {
            baseLabelText = NSLocalizedString(@"Cellular data network is active.\nInternet traffic will be routed through it.", @"Reachability text if a connection is not required");
        }
        self.summaryLabel.text = baseLabelText;
    }
    
	if (reachability == self.internetReachability)
	{
		[self configureTextField:self.internetConnectionStatusField imageView:self.internetConnectionImageView reachability:reachability];
	}

}


- (void)configureTextField:(UITextField *)textField imageView:(UIImageView *)imageView reachability:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    NSString* statusString = @"";
    
    switch (netStatus)
    {
        case NotReachable:        {
            statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
            imageView.image = [UIImage imageNamed:@"stop-32.png"] ;
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
            connectionRequired = NO;
            break;
        }

        case ReachableViaWWAN:        {
            statusString = NSLocalizedString(@"Reachable WWAN", @"");
            imageView.image = [UIImage imageNamed:@"WWAN5.png"];
            break;
        }
        case ReachableViaWiFi:        {
            statusString= NSLocalizedString(@"Reachable WiFi", @"");
            imageView.image = [UIImage imageNamed:@"Airport.png"];
            break;
        }
    }
    
    if (connectionRequired)
    {
        NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
        statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
    }
    textField.text= statusString;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

-(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

- (NSDictionary *)getWIFIDic
{
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dic = (NSDictionary*)CFBridgingRelease(myDict);
            return dic;
        }
    }
    return nil;
}

- (NSString *)getBSSID
{
    NSDictionary *dic = [self getWIFIDic];
    if (dic == nil) {
        return nil;
    }
    return dic[@"BSSID"];
}

- (NSString *)getSSID
{
    NSDictionary *dic = [self getWIFIDic];
    if (dic == nil) {
        return nil;
    }
    return dic[@"SSID"];
}

- (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) {
            break;
        }
    }
    return info;
}

- (void)registerNetwork:(NSString *)ssid
{
    NSString *values[] = {ssid};
    CFArrayRef arrayRef = CFArrayCreate(kCFAllocatorDefault,(void *)values,
                                        (CFIndex)1, &kCFTypeArrayCallBacks);
    if( CNSetSupportedSSIDs(arrayRef)) {
        NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
        CNMarkPortalOnline((__bridge CFStringRef)(ifs[0]));
        NSLog(@"%@", ifs);
    }
}

/*
 systemconfiguration,包含reachability，网络连接情况，网络切换变化（reachability）。
 找时间
 */
-(void)WWANType{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        
        CTTelephonyNetworkInfo * info = [[CTTelephonyNetworkInfo alloc] init];
        NSString *currentRadioAccessTechnology = info.currentRadioAccessTechnology;
        if (currentRadioAccessTechnology)
        {
            if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE])
            {
//                returnValue =  kReachableVia4G;
                LOGINFO(@"4G 网络");
            }
            else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS])
            {
//                returnValue =  kReachableVia2G;
                LOGINFO(@"2G 网络");
            }
            else
            {
//                returnValue =  kReachableVia3G;
                LOGINFO(@"4G 网络");
            }
        }
    }
    
//7.0之前做的判断
//    if ((flags & kSCNetworkReachabilityFlagsTransientConnection) == kSCNetworkReachabilityFlagsTransientConnection)
//    {
//        if((flags & kSCNetworkReachabilityFlagsConnectionRequired) == kSCNetworkReachabilityFlagsConnectionRequired)
//        {
//            returnValue =  kReachableVia2G;
//            return returnValue;
//        }
//        returnValue =  kReachableVia3G;
//        return returnValue;
//    }
    
    
    
}

//1.获取网卡IP
- (NSString *)getIPAddress {
    /*
     #import <ifaddrs.h>
     #import <arpa/inet.h>
     */
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            
            if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"] ||
                [[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"pdp_ip0"]) {
                
                if(temp_addr->ifa_addr->sa_family == AF_INET) {//IPV4
                    // Check if interface is en0 which is the wifi connection on the iPhone
                    
                    char dstStr[INET_ADDRSTRLEN];
                    char srcStr[INET_ADDRSTRLEN];
                    
                    struct in_addr ipv4Addr = ((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr;
                    
                    memcpy(srcStr, &ipv4Addr, sizeof(struct in_addr));
                    if(inet_ntop(AF_INET, srcStr, dstStr, INET_ADDRSTRLEN) != NULL){
                        address = [NSString stringWithUTF8String:dstStr];
                    }
                    
//                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
//                    Get NSString from C String, IPV4特有的方法
//                    NSString* a = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
//                }
                } else if (temp_addr->ifa_addr->sa_family == AF_INET6) {//IPV6
                    
                    char dstStr[INET6_ADDRSTRLEN];
                    char srcStr[INET6_ADDRSTRLEN];
                    
                    struct in6_addr ipv6Addr = ((struct sockaddr_in6 *)temp_addr->ifa_addr)->sin6_addr;
                    
                    memcpy(srcStr, &ipv6Addr, sizeof(struct in6_addr));
                    if(inet_ntop(AF_INET6, srcStr, dstStr, INET6_ADDRSTRLEN) != NULL){
                        address = [NSString stringWithUTF8String:dstStr];
                    }
                    
                    if (address && ![address isEqualToString:@""] && ![address.uppercaseString hasPrefix:@"FE80"]) break;
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

- (NSString *)getDeviceIPIpAddresses

{
    
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    
    if (sockfd == 0) return nil;
    
    NSMutableArray *ips = [NSMutableArray array];
    
    
    
    int BUFFERSIZE = 4096;
    
    struct ifconf ifc;
    
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    
    struct ifreq *ifr, ifrcopy;
    
    ifc.ifc_len = BUFFERSIZE;
    
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            
            ifr = (struct ifreq *)ptr;
            
            int len = sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                
                len = ifr->ifr_addr.sa_len;
                
            }
            
            ptr += sizeof(ifr->ifr_name) + len;
            
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            
            ifrcopy = *ifr;
            
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            
            
            NSString *ip = [NSString  stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            
            [ips addObject:ip];
            
        }
        
    }
    
    close(sockfd);
    
    
    
    
    
    NSString *deviceIP = @"";
    
    for (int i=0; i < ips.count; i++)
        
    {
        
        if (ips.count > 0)
            
        {
            
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
            
            
            
        }
        
    }
    
    return deviceIP;
    
}





//- (NSString *)deviceIPAdress
//{
//    struct ifaddrs temp_addr;
//    while (temp_addr != nil) {
//        NSLog(@"ifa_name===%@",[NSString stringWithUTF8String:temp_addr.ifa_name]);
//        // Check if interface is en0 which is the wifi connection on the iPhone
//        if ([[NSString stringWithUTF8String:temp_addr.ifa_name] isEqualToString:@"en0"] || [[NSString stringWithUTF8String:temp_addr.ifa_name] isEqualToString:@"pdp_ip0"])
//        {
//            // 如果是 IPv4 地址，直接转化
//            if (temp_addr.ifa_addr->sa_family == AF_INET){
//                // Get NSString from C String
//                address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr.ifa_addr)->sin_addr)];
//                //                    if (address && ![address isEqualToString:@""] && ![address.uppercaseString hasPrefix:@"FE80"]) break;
//            }
//            
//            // 如果是 IPv6 地址
//            else if (temp_addr.ifa_addr->sa_family == AF_INET6){
//                address = [self formatIPv6Address:((struct sockaddr_in6 *)temp_addr.ifa_addr)->sin6_addr];
//                if (access && ![access isEqualToString:@""] && ![address.uppercaseString hasPrefix:@"FE80"]) break;
//            }
//        }
//        
//        temp_addr = *temp_addr.ifa_next;
//    }
//}


@end
