//
//  MQTTClient.m
//  MyDemo
//
//  Created by 张鑫 on 16/4/1.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "MQTTClient.h"
#import "mosquitto.h"

@implementation MQTTClient

@synthesize host;
@synthesize port;
@synthesize username;
@synthesize password;
@synthesize keepAlive;
@synthesize cleanSession;
@synthesize delegate;

/**
 * @brief 单例模式的设置
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */

static MQTTClient *qttInstance = nil;

+(MQTTClient *)getMQTTInstance
{
    @synchronized(self)
    {
        if(qttInstance==nil)
        {
            qttInstance=[[self alloc]init];
        }
    }
    return qttInstance;
}

/**
 * @brief 连接mqtt
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */
static void on_connect(struct mosquitto *mosq, void *obj, int rc)
{
    MQTTClient* client = (__bridge MQTTClient *)obj;
    [[client delegate] didConnect:(NSUInteger)rc];
}


/**
 * @brief 断开与mqtt的连接
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */
static void on_disconnect(struct mosquitto *mosq, void *obj, int rc)
{
    MQTTClient* client = (__bridge MQTTClient *)obj;
    [[client delegate] didDisconnect];
}

/**
 * @brief publish  message
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */
static void on_publish(struct mosquitto *mosq, void *obj, int message_id)
{
    MQTTClient* client = (__bridge MQTTClient *)obj;
    [[client delegate] didPublish:(NSUInteger)message_id];
}

/**
 * @brief receive  message
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */
static void on_message(struct mosquitto *mosq, void *obj, const struct mosquitto_message *message)
{
    MQTTClient * client = (__bridge MQTTClient *)obj;
    NSString *topic = [NSString stringWithUTF8String: message->topic];
    NSString *payload = [[NSString alloc] initWithBytes:message->payload
                                                  length:message->payloadlen
                                                encoding:NSUTF8StringEncoding];
    
    // FIXME: create MosquittoMessage class instead
    [[client delegate] didReceiveMessage:payload topic:topic];
}

/**
 * @brief didSubscribe
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */
static void on_subscribe(struct mosquitto *mosq, void *obj, int message_id, int qos_count, const int *granted_qos)
{
    MQTTClient * client = (__bridge MQTTClient *)obj;
    // FIXME: implement this
    [[client delegate] didSubscribe:message_id grantedQos:nil];
}

/**
 * @brief
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */
static void on_unsubscribe(struct mosquitto *mosq, void *obj, int message_id)
{
    MQTTClient * client = (__bridge MQTTClient *)obj;
    [[client delegate] didUnsubscribe:message_id];
}

/**
 * @brief  Initialize is called just before the first object is allocated
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */

+ (void)initialize
{
    mosquitto_lib_init();
}

/**
 * @brief 版本信息
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */
+ (NSString*)version
{
    int major, minor, revision;
    mosquitto_lib_version(&major, &minor, &revision);
    return [NSString stringWithFormat:@"%d.%d.%d", major, minor, revision];
}

/**
 * @brief 设置些参数状态配置
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */
- (MQTTClient *) initWithClientId: (NSString*) clientId
{
    if ((self = [super init]))
    {
        const char* cstrClientId = [clientId cStringUsingEncoding:NSUTF8StringEncoding];
        [self setHost: nil];
        [self setPort: 1883];
        [self setKeepAlive: 60];
        [self setCleanSession: YES];
        
        mosq = mosquitto_new(cstrClientId, cleanSession, (__bridge void *)(self));
        mosquitto_connect_callback_set(mosq, on_connect);
        mosquitto_disconnect_callback_set(mosq, on_disconnect);
        mosquitto_publish_callback_set(mosq, on_publish);
        mosquitto_message_callback_set(mosq, on_message);
        mosquitto_subscribe_callback_set(mosq, on_subscribe);
        mosquitto_unsubscribe_callback_set(mosq, on_unsubscribe);
        timer = nil;
    }
    return self;
}


- (void) connect
{
    const char *cstrHost = [host cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cstrUsername = NULL, *cstrPassword = NULL;
    
    if (username)
        cstrUsername = [username cStringUsingEncoding:NSUTF8StringEncoding];
    
    if (password)
        cstrPassword = [password cStringUsingEncoding:NSUTF8StringEncoding];
    
    // FIXME: check for errors
    mosquitto_username_pw_set(mosq, cstrUsername, cstrPassword);
    
    int ret = mosquitto_connect(mosq, cstrHost, port, keepAlive);
    
    NSLog(@"mqtt-ret-code = %d",ret);
    if (ret == 0)
    {
        NSLog(@"//连接成功   设置ud");
    }
    else
    {
        
        NSLog(@"//连接失败");
    }
    
    // Setup timer to handle network events
    // FIXME: better way to do this - hook into iOS Run Loop select() ?
    // or run in seperate thread?
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 // 10ms
                                             target:self
                                           selector:@selector(loop:)
                                           userInfo:nil
                                            repeats:YES];
}

- (void) connectToHost: (NSString*)aHost
{
    [self setHost:aHost];
    [self connect];
}

- (void) reconnect
{
    mosquitto_reconnect(mosq);
}

- (void) disconnect
{
    mosquitto_disconnect(mosq);
}

- (void) loop: (NSTimer *)timer
{
    mosquitto_loop(mosq, 1, 1);
}

// FIXME: add QoS parameter?
- (void)publishString: (NSString *)payload toTopic:(NSString *)topic retain:(BOOL)retain
{
    const char* cstrTopic = [topic cStringUsingEncoding:NSUTF8StringEncoding];
    const uint8_t* cstrPayload = (const uint8_t*)[payload cStringUsingEncoding:NSUTF8StringEncoding];
    mosquitto_publish(mosq, NULL, cstrTopic, [payload length], cstrPayload, 0, retain);
}

- (void)subscribe: (NSString *)topic
{
    [self subscribe:topic withQos:0];
}

- (void)subscribe: (NSString *)topic withQos:(NSUInteger)qos
{
    const char* cstrTopic = [topic cStringUsingEncoding:NSUTF8StringEncoding];
    mosquitto_subscribe(mosq, NULL, cstrTopic, qos);
}

- (void)unsubscribe: (NSString *)topic
{
    const char* cstrTopic = [topic cStringUsingEncoding:NSUTF8StringEncoding];
    mosquitto_unsubscribe(mosq, NULL, cstrTopic);
}


- (void) setMessageRetry: (NSUInteger)seconds
{
    mosquitto_message_retry_set(mosq, (unsigned int)seconds);
}

- (void) dealloc
{
    if (mosq)
    {
        mosquitto_destroy(mosq);
        mosq = NULL;
    }
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
//    [super dealloc];
}

// FIXME: how and when to call mosquitto_lib_cleanup() ?

@end


