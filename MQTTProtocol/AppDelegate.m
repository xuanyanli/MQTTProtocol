//
//  AppDelegate.m
//  MQTTProtocol
//
//  Created by 李选雁 on 2017/8/22.
//  Copyright © 2017年 李选雁. All rights reserved.
//

#import "AppDelegate.h"

#import <MQTTClient/MQTTClient.h>

@interface AppDelegate ()<MQTTSessionDelegate>

@property (nonatomic,strong) MQTTSession *mySession;

@end

#define MQTT_HOST @"192.168.0.112"
#define MQTT_PORT 1883

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //初始化session
    self.mySession = [self createMQTTSession];
    
    //订阅主题
    [self subscribeToTopic];
    
    return YES;
}

#pragma mark- 初始化一个MQTTSession
- (MQTTSession *)createMQTTSession
{
    MQTTSession *mySession = [[MQTTSession alloc]init];
    // 给mySession对象设置基本信息
    mySession.transport = [self createSocketTransport];
    mySession.delegate = self;
    //设定超时时长，如果超时则认为是连接失败，如果设为0则是一直连接。
    [mySession connectAndWaitTimeout:30];
    
    return mySession;
}

#pragma mark- 初始化一个 MQTTCFSocketTransport 对象
- (MQTTCFSocketTransport *)createSocketTransport
{
    MQTTCFSocketTransport *transport = [[MQTTCFSocketTransport alloc]init];
    //设置MQTT服务器地址
    transport.host = MQTT_HOST;
    //设置MQTT端口号
    transport.port = MQTT_PORT;
    
    return transport;
}

#pragma mark- 订阅主题
- (void)subscribeToTopic
{
    
    [self.mySession subscribeToTopic:@"example/#" atLevel:2 subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
        
        if (error)
        {
            NSLog(@"subscribe failed %@",error.localizedDescription);
        }else
        {
            NSLog(@"subscribe success");
        }
    }];
}

#pragma mark- 发布消息
- (void)publicMessageWithData:(NSData *)sendData onTopic:(NSString *)topic
{
    [self.mySession publishAndWaitData:sendData onTopic:topic retain:NO qos:MQTTQosLevelAtLeastOnce];
}

#pragma mark- MQTTSessionDelegate
#pragma mark 收到消息回调
- (void)session:(MQTTSession *)session newMessage:(NSData *)data onTopic:(NSString *)topic
{
    //发布消息
    [self publicMessageWithData:data onTopic:topic];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
