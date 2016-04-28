//
//  MQTTClient.h
//  MyDemo
//
//  Created by 张鑫 on 16/4/1.
//  Copyright © 2016年 zhangxin. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol MQTTDelegate <NSObject>
/**
 * @brief 连接服务器
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */

- (void) didConnect: (NSUInteger)code;

/**
 * @brief 与服务器断开连接
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */
- (void) didDisconnect;

/**
 * @brief
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */
- (void) didPublish: (NSUInteger)messageId;

// FIXME: create MosquittoMessage class
/**
 * @brief  接收消息
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */
- (void) didReceiveMessage: (NSString*)message topic:(NSString*)topic;
/**
 * @brief
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */
- (void) didSubscribe: (NSUInteger)messageId grantedQos:(NSArray*)qos;
/**
 * @brief
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */
- (void) didUnsubscribe: (NSUInteger)messageId;

@end

@interface MQTTClient : NSObject
{
    struct mosquitto      *mosq;
    NSString              *host;
    unsigned short        port;
    NSString              *username;
    NSString              *password;
    unsigned short        keepAlive;
    BOOL                  cleanSession;
    
    NSTimer               *timer;
}

@property (readwrite,retain) NSString             *host;
@property (readwrite,assign) unsigned short       port;
@property (readwrite,retain) NSString             *username;
@property (readwrite,retain) NSString             *password;
@property (readwrite,assign) unsigned short       keepAlive;
@property (readwrite,assign) BOOL                 cleanSession;
@property (nonatomic,assign) id<MQTTDelegate>     delegate;


/**
 * @brief 单例模式的设置
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */

+(MQTTClient *)getMQTTInstance;

/**
 * @brief
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */
+ (void) initialize;

/**
 * @brief
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */
+ (NSString*) version;

/**
 * @brief
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */
- (MQTTClient *) initWithClientId: (NSString*) clientId;

/**
 * @brief
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */
- (void) setMessageRetry: (NSUInteger)seconds;

/**
 * @brief    连接服务器
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */
- (void) connect;
/**
 * @brief    连接到主机
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */
- (void) connectToHost: (NSString*)host;

/**
 * @brief
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */
- (void) reconnect;
/**
 * @brief
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */
- (void) disconnect;
/**
 * @brief
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */

- (void)publishString: (NSString *)payload toTopic:(NSString *)topic retain:(BOOL)retain;
//- (void)publishMessage

/**
 * @brief
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */
- (void)subscribe: (NSString *)topic;
/**
 * @brief
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */
- (void)subscribe: (NSString *)topic withQos:(NSUInteger)qos;

/**
 * @brief
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　void
 * @note
 */
- (void)unsubscribe: (NSString *)topic;


// This is called automatically when connected
- (void) loop: (NSTimer *)timer;
@end