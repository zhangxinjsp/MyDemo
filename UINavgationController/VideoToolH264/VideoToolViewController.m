//
//  VideoToolViewController.m
//  UINavgationController
//
//  Created by xsw on 15/6/16.
//  Copyright (c) 2015年 niexin. All rights reserved.
//

#import "VideoToolViewController.h"

#import <VideoToolbox/VideoToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoToolViewController (){
    
    
    
}




@end

@implementation VideoToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // create our AVSampleBufferDisplayLayer and add it to the view
    videoLayer = [[AVSampleBufferDisplayLayer alloc] init];
    videoLayer.frame = self.view.frame;
    videoLayer.bounds = self.view.bounds;
    videoLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    videoLayer.borderColor = [UIColor greenColor].CGColor;
    videoLayer.borderWidth = 4;
    
    // set Timebase, you may need this if you need to display frames at specific times
    // I didn't need it so I haven't verified that the timebase is working
    CMTimebaseRef controlTimebase;
    CMTimebaseCreateWithMasterClock(CFAllocatorGetDefault(), CMClockGetHostTimeClock(), &controlTimebase);
    
    //videoLayer.controlTimebase = controlTimebase;
    CMTimebaseSetTime(videoLayer.controlTimebase, kCMTimeZero);
    CMTimebaseSetRate(videoLayer.controlTimebase, 1.0);
    
    [[self.view layer] addSublayer:videoLayer];
    
    
    [self performSelector:@selector(decode) withObject:nil afterDelay:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static AVSampleBufferDisplayLayer *videoLayer;
- (void)decode {
    
    dispatch_queue_t que = dispatch_queue_create("test", NULL);
    dispatch_async(que, ^{
        NSString* path = [[NSBundle mainBundle] pathForResource:@"REVideo3" ofType:@"264"];//REVideo06151507, 320x240, REVideo3
        NSData* data = [NSData dataWithContentsOfFile:path];
        
        Byte *byte = (Byte *)[data bytes];
        
        NSInteger localtion1 = -1;
        NSInteger localtion2 = -1;
        for (int i = 0; i < data.length - 4; i ++) {
            if (byte[i + 3] == 0x01 && byte[i+2] == 0x00 && byte[i+1] == 0x00 && byte[i] == 0x00) {
                if (localtion1 == -1) {
                    localtion1 = i;
                } else {
                    
                    localtion2 = i;
                    NSData* subData = [data subdataWithRange:NSMakeRange(localtion1, localtion2 - localtion1)];
                    [self reveiceFrame:subData];
                    
                    localtion1 = localtion2;
                }
            }
        }
    });
}

NSString * const naluTypesStrings[] =
{
    @"0: Unspecified (non-VCL)",
    @"1: Coded slice of a non-IDR picture (VCL)",    // P frame
    @"2: Coded slice data partition A (VCL)",
    @"3: Coded slice data partition B (VCL)",
    @"4: Coded slice data partition C (VCL)",
    @"5: Coded slice of an IDR picture (VCL)",      // I frame
    @"6: Supplemental enhancement information (SEI) (non-VCL)",
    @"7: Sequence parameter set (non-VCL)",         // SPS parameter
    @"8: Picture parameter set (non-VCL)",          // PPS parameter
    @"9: Access unit delimiter (non-VCL)",
    @"10: End of sequence (non-VCL)",
    @"11: End of stream (non-VCL)",
    @"12: Filler data (non-VCL)",
    @"13: Sequence parameter set extension (non-VCL)",
    @"14: Prefix NAL unit (non-VCL)",
    @"15: Subset sequence parameter set (non-VCL)",
    @"16: Reserved (non-VCL)",
    @"17: Reserved (non-VCL)",
    @"18: Reserved (non-VCL)",
    @"19: Coded slice of an auxiliary coded picture without partitioning (non-VCL)",
    @"20: Coded slice extension (non-VCL)",
    @"21: Coded slice extension for depth view components (non-VCL)",
    @"22: Reserved (non-VCL)",
    @"23: Reserved (non-VCL)",
    @"24: STAP-A Single-time aggregation packet (non-VCL)",
    @"25: STAP-B Single-time aggregation packet (non-VCL)",
    @"26: MTAP16 Multi-time aggregation packet (non-VCL)",
    @"27: MTAP24 Multi-time aggregation packet (non-VCL)",
    @"28: FU-A Fragmentation unit (non-VCL)",
    @"29: FU-B Fragmentation unit (non-VCL)",
    @"30: Unspecified (non-VCL)",
    @"31: Unspecified (non-VCL)",
};

static OSStatus status;
static NSData* spsData;
static NSData* ppsData;
static VTDecompressionSessionRef session;
static CMFormatDescriptionRef videoFormatDescr;
static UIImageView* imageView;

- (void)reveiceFrame:(NSData*)frameData {
    
    Byte *byte = (Byte *)[frameData bytes];
    
    int naluType = byte[4] & 0x1f;
    NSLog(@"NALU with Type \"%@\" received.", naluTypesStrings[naluType]);
    
    
    
    if (naluType == 7) {
        spsData = [frameData subdataWithRange:NSMakeRange(4, frameData.length - 4)];
    } else if (naluType == 8) {
        ppsData = [frameData subdataWithRange:NSMakeRange(4, frameData.length - 4)];
    }
    
    if (spsData != nil && ppsData != nil) {
        const uint8_t* const parameterSetPointers[2] = { (const uint8_t*)[spsData bytes], (const uint8_t*)[ppsData bytes] };
        const size_t parameterSetSizes[2] = { [spsData length], [ppsData length] };
        status = CMVideoFormatDescriptionCreateFromH264ParameterSets(kCFAllocatorDefault, 2, parameterSetPointers, parameterSetSizes, 4, &videoFormatDescr);
        NSLog(@"Found all data for CMVideoFormatDescription. Creation: %@.", (status == noErr) ? @"successfully." : @"failed.");
    }
    
    if (videoFormatDescr) {
        [self createDecompressionSession];
        
    }
    [self startDecodeFrame:frameData];
}

- (void)createDecompressionSession {
    VTDecompressionOutputCallbackRecord callback;
    callback.decompressionOutputCallback = didDecompress;
    callback.decompressionOutputRefCon = (__bridge void *)self;
    
    NSDictionary *destinationImageBufferAttributes =[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],(id)kCVPixelBufferOpenGLESCompatibilityKey,[NSNumber numberWithInt:kCVPixelFormatType_32BGRA],(id)kCVPixelBufferPixelFormatTypeKey,nil];
    
    //    NSDictionary *destinationImageBufferAttributes =[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],(id)kCVPixelBufferOpenGLESCompatibilityKey,nil];
    
    //    NSDictionary *destinationImageBufferAttributes = [NSDictionary dictionaryWithObject: [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] forKey: (id)kCVPixelBufferPixelFormatTypeKey];
    
    //    CFDictionaryRef destinationImageBufferAttributes = NULL;
    //    const void *keys[] = { kCVPixelBufferPixelFormatTypeKey };
    //      kCVPixelFormatType_420YpCbCr8Planar is YUV420
    //      kCVPixelFormatType_420YpCbCr8BiPlanarFullRange is NV12
    //    uint32_t v = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange;
    //    const void *values[] = { CFNumberCreate(NULL, kCFNumberSInt32Type, &v) };
    //    destinationImageBufferAttributes = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    
    status = VTDecompressionSessionCreate(kCFAllocatorDefault, videoFormatDescr, NULL, (__bridge CFDictionaryRef)destinationImageBufferAttributes, &callback, &session);
    //    status = VTDecompressionSessionCreate(kCFAllocatorDefault, videoFormatDescr, NULL, NULL, &callback, &session);
    NSLog(@"Creating Video Decompression Session: %@.", (status == noErr) ? @"successfully." : @"failed.");
}

- (void) startDecodeFrame:(NSData*)_frameData {
    
    NSData* data = [_frameData copy];
    Byte *packet = (Byte*)[data bytes];
    
    int nalu_type = ((uint8_t)packet[4] & 0x1F);
    NSLog(@"NALU with Type \"%@\" received.", naluTypesStrings[nalu_type]);
    
    if (nalu_type == 1 || nalu_type == 5) {
        // 4. get NALUnit payload into a CMBlockBuffer,
        CMBlockBufferRef videoBlock = NULL;
        status = CMBlockBufferCreateWithMemoryBlock(NULL, packet, data.length, kCFAllocatorNull, NULL, 0, data.length, 0, &videoBlock);
        NSLog(@"BlockBufferCreation: %@", (status == kCMBlockBufferNoErr) ? @"successfully." : @"failed.");
        
        // 5.  making sure to replace the separator code with a 4 byte length code (the length of the NalUnit including the unit code)
        int reomveHeaderSize = data.length - 4;
        const uint8_t sourceBytes[] = {(uint8_t)(reomveHeaderSize >> 24), (uint8_t)(reomveHeaderSize >> 16), (uint8_t)(reomveHeaderSize >> 8), (uint8_t)reomveHeaderSize};
        status = CMBlockBufferReplaceDataBytes(sourceBytes, videoBlock, 0, 4);
        NSLog(@"BlockBufferReplace: %@", (status == kCMBlockBufferNoErr) ? @"successfully." : @"failed.");
        
        //        NSString *tmp3 = [NSString new];
        //        for(int i = 0; i < sizeof(sourceBytes); i++) {
        //            NSString *str = [NSString stringWithFormat:@" %.2X",sourceBytes[i]];
        //            tmp3 = [tmp3 stringByAppendingString:str];
        //        }
        //        NSLog(@"size = %i , 16Byte = %@",reomveHeaderSize,tmp3);
        
        // 6. create a CMSampleBuffer.
        CMSampleBufferRef sbRef = NULL;
        //        int32_t timeSpan = 90000;
        //        CMSampleTimingInfo timingInfo;
        //        timingInfo.presentationTimeStamp = CMTimeMake(0, timeSpan);
        //        timingInfo.duration =  CMTimeMake(3000, timeSpan);
        //        timingInfo.decodeTimeStamp = kCMTimeInvalid;
        const size_t sampleSizeArray[] = {data.length};
        //        status = CMSampleBufferCreate(kCFAllocatorDefault, videoBlock, true, NULL, NULL, videoFormatDescr, 1, 1, &timingInfo, 1, sampleSizeArray, &sbRef);
        status = CMSampleBufferCreate(kCFAllocatorDefault, videoBlock, true, NULL, NULL, videoFormatDescr, 1, 0, NULL, 1, sampleSizeArray, &sbRef);
        NSLog(@"SampleBufferCreate: %@", (status == noErr) ? @"successfully." : @"failed.");
        
        CFArrayRef attachments = CMSampleBufferGetSampleAttachmentsArray(sbRef, YES);
        CFMutableDictionaryRef dict = (CFMutableDictionaryRef)CFArrayGetValueAtIndex(attachments, 0);
        CFDictionarySetValue(dict, kCMSampleAttachmentKey_DisplayImmediately, kCFBooleanTrue);
        
        
        // 7. use VTDecompressionSessionDecodeFrame
        if (1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [videoLayer enqueueSampleBuffer:sbRef];
                
                CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sbRef);
                CIImage* ciImage = [[CIImage alloc]initWithCVPixelBuffer:pixelBuffer];
                if (ciImage) {
                    LOGINFO(@"%@", @"success  ");
                }
            });
        } else {
            
            VTDecodeFrameFlags flags = kVTDecodeFrame_EnableAsynchronousDecompression;
            VTDecodeInfoFlags flagOut;
            status = VTDecompressionSessionDecodeFrame(session, sbRef, flags, &sbRef, &flagOut);
            NSLog(@"VTDecompressionSessionDecodeFrame: %@", (status == noErr) ? @"successfully." : @"failed.");
            CFRelease(sbRef);
        }
    }
}

void didDecompress( void *decompressionOutputRefCon, void *sourceFrameRefCon, OSStatus status, VTDecodeInfoFlags infoFlags, CVImageBufferRef imageBuffer, CMTime presentationTimeStamp, CMTime presentationDuration )
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (status != noErr || !imageBuffer) {
            // error -8969 codecBadDataErr
            // -12909 The operation couldn’t be completed. (OSStatus error -12909.)
            NSLog(@"Error decompresssing frame at time: %.3f error: %d infoFlags: %u", (float)presentationTimeStamp.value/presentationTimeStamp.timescale, (int)status, (unsigned int)infoFlags);
            return;
        }
        
        CIImage* ciImage = [[CIImage alloc]initWithCVPixelBuffer:imageBuffer];
        if (ciImage ) {
            
            UIImage *uiImage = [UIImage imageWithCIImage:ciImage];
            imageView.image = uiImage;
            
            NSLog(@"success success success success success success success ");
        }
    });
}



@end
