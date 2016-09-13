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
//  AppDelegate+Initialization.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/8/25.
//

#import "AppDelegate+Initialization.h"
#import "CocoaLumberjack.h"
#import "SEDatabase.h"
#import "DYAutoSaver.h"
#import "DYAppConfigManager.h"
#import "DYAuthorityManager.h"
#import "DYInterfacePropertiesManager.h"
#import "DYNetStatusManager.h"
#import "DYAuthTokenManager.h"
#import "DYTools+Formatting.h"
#import "DYLoginViewController.h"
#import "RNCachingURLProtocol.h"
#import "DYNoticeInfoManager.h"
#import "DYGetUserInfoDataSource.h"
#import "DYLoginUserInfo.h"
#import "DYAuthTokenManager.h"
#import "DYDefine.h"
#import "DYLogFormatter.h"
#import "DDFileLogger.h"

#pragma mark - 退出账号相关
#import "DYGuestureLockViewController.h"
#import "DYAppNotification.h"
#import "DYAppConfigManager.h"

#define MAX_MEMORY_CACHE_SIZE (4 * 1024 * 1024)                 // 内存缓存最大值
#define MAX_DISK_CACHE_SIZE (20 * 1024 * 1024)                  // 磁盘缓存最大值

//static BOOL isShowingUpdateToast; //与notify token 调用握手分离

@implementation AppDelegate (Initialization)

- (void)appStart
{   
    [[DYNetStatusManager shareInstance] startMonitorNetWork];
    [DYInterfacePropertiesManager shareInstance];
    
    [NSURLProtocol registerClass:[RNCachingURLProtocol class]];

    [[DYAutoSaver shareInstance] INeedAutoSave:[DYAppConfigManager shareInstance]];
    
    [self setupDDLog];
}

- (void)appActived
{
    if([DYAuthTokenManager shareInstance].isLogined) {
        if (![DYAuthTokenManager shareInstance].isAccessTokenValid) {
            [[DYAuthorityManager sharedInstance] refreshAccessTokenWithRefreshToken];
        }
        else {
            [self fetchUserIdentityInfo];
        }
    }
}

//登录成功后用户信息初始化
-(void)userInit{
    [self fetchUserIdentityInfo];
}

- (void)fetchUserIdentityInfo
{
    if ([DYLoginUserInfo shareInstance].userIdentityInfo == nil) {
        [[DYGetUserInfoDataSource shareInstance] requestUserInfoResultBlock:^(id data, NSError *error) {
            if (error == nil && data != nil) {
                [DYLoginUserInfo shareInstance].userIdentityInfo = data;
            }
        }];
    }
}

- (void)setupDDLog
{
    
    //log formatter
    DYLogFormatter *formatter = [[DYLogFormatter alloc] init];
    
    //输出到console
    [DDTTYLogger sharedInstance].logFormatter = formatter;
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // Initialize File Logger
    self.fileLogger = [[DDFileLogger alloc] init];
    self.fileLogger.logFormatter = formatter;
    
    // Configure File Logger
    [self.fileLogger setMaximumFileSize:(1024 * 1024)];
    [self.fileLogger setRollingFrequency:(3600.0 * 24.0)];
    [[self.fileLogger logFileManager] setMaximumNumberOfLogFiles:1];
    [DDLog addLogger:self.fileLogger];
    
}

- (NSString *)getFileLoggerPath
{
    return [[self.fileLogger currentLogFileInfo] filePath];
}
@end
