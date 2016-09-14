/** 
 * 通联数据机密
 * --------------------------------------------------------------------
 * 通联数据股份公司版权所有 © 2013-2016
 * 
 * 注意：本文所载所有信息均属于通联数据股份公司资产。本文所包含的知识和技术概念均属于
 * 通联数据产权，并可能由中国、美国和其他国家专利或申请中的专利所覆盖，并受商业秘密或
 * 版权法保护。
 * 除非事先获得通联数据股份公司书面许可，严禁传播文中信息或复制本材料。
 * 
 * DataYes CONFIDENTIAL
 * --------------------------------------------------------------------
 * Copyright © 2013-2016 DataYes, All Rights Reserved.
 * 
 * NOTICE: All information contained herein is the property of DataYes 
 * Incorporated. The intellectual and technical concepts contained herein are 
 * proprietary to DataYes Incorporated, and may be covered by China, U.S. and 
 * Other Countries Patents, patents in process, and are protected by trade 
 * secret or copyright law. 
 * Dissemination of this information or reproduction of this material is 
 * strictly forbidden unless prior written permission is obtained from DataYes.
 */
//
//  DYAppNotification.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/9/2.
//

#import "DYAppNotification.h"
#import "DYAppConfigManager.h"
#import "DYTools+DeviceInfo.h"
#import "DYTools+AppInfo.h"
#import "DYAuthTokenManager.h"

static DYAppNotification* gAppNotification = nil;

@implementation DYAppNotification

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gAppNotification = [[DYAppNotification alloc] init];
    });
    
    return gAppNotification;
}


- (void)fetchAppLogin:(BOOL)islogin NotificationWithResultBlock:(DYInterfaceResultBlock)resultBlock
{
    DYAppConfigManager* cfgManager = [DYAppConfigManager shareInstance];
//    NSString* uid = [NSString stringWithFormat:@"%@-%@", [DYTools deviceId], cfgManager.productId];
    
    if (islogin) {
        [self sendRequestWithMsgId:eAppBind
                        parameters:@{
                                     @"deviceId":[DYTools deviceId],
                                     @"deviceToken":cfgManager.notifyToken,
                                     @"version":[DYTools appVersion],
                                     @"prodId": cfgManager.productId,
                                     @"channelId":cfgManager.channelId,
                                     @"mobileTypeId":cfgManager.mobileTypeId
                                     }
                     canUsingCache:NO
                       forceReload:NO
                       resultBlock:^(id data, NSError *error) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               resultBlock(data, error);
                           });
                        }];
    }
    else
    {
        [self sendRequestWithMsgId:eAppUnbnind
                        parameters:@{
                                     @"deviceId":[DYTools deviceId],
                                     @"deviceToken":cfgManager.notifyToken,
                                     @"version":[DYTools appVersion],
                                     @"prodId": cfgManager.productId,
                                     @"channelId":cfgManager.channelId,
                                     @"mobileTypeId":cfgManager.mobileTypeId
                                     }
                     canUsingCache:NO
                       forceReload:NO
                       resultBlock:^(id data, NSError *error) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               resultBlock(data, error);
                           });
                        }];
    }
}


- (void)fetchAppNotificationWithResultBlock:(DYInterfaceResultBlock)resultBlock
{
    DYAppConfigManager* cfgManager = [DYAppConfigManager shareInstance];
//    NSString* uid = [NSString stringWithFormat:@"%@-%@", [DYTools deviceId], cfgManager.productId];
    
    [self sendRequestWithMsgId:eAppHandshake
                    parameters:@{
                                 @"deviceId":[DYTools deviceId],
                                 @"deviceToken":cfgManager.notifyToken,
                                 @"version":[DYTools appVersion],
                                 @"prodId": cfgManager.productId,
                                 @"channelId":cfgManager.channelId,
                                 @"mobileTypeId":cfgManager.mobileTypeId
                                  }
                 canUsingCache:NO forceReload:NO resultBlock:^(id data, NSError *error) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         resultBlock(data, error);
                     });
                  }];
}

@end
