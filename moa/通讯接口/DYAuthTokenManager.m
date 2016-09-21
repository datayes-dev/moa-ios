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
//  DYAuthTokenManager.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/10/23.
//

#import "DYAuthTokenManager.h"
#import "DYInterfaceRequestHelper.h"
#import "DYInterfaceRequesterBase.h"
#import "DYNetStatusManager.h"
#import "DYAuthorityManager.h"
#import "DYAppConfigManager.h"
#import "DYTools.h"

#define REFRESH_TIME_ALLOWANCE  10      // 时间容差，提前判断过期

static DYAuthTokenManager* gAuthTokenManager = nil;

@implementation DYAuthTokenManager

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gAuthTokenManager = [[DYAuthTokenManager alloc] init];
    });
    
    return gAuthTokenManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadAuthInfo];
    }
    
    return self;
}

- (void)setAccessToken:(NSString *)accessToken
{
    _accessToken = accessToken;
    [[DYInterfaceRequestHelper shareInstance].dataInfoWithAuthParamsRequest setAccessToken:accessToken];
    [[DYInterfaceRequestHelper shareInstance].authInfoRequest setAccessToken:accessToken];
    [[DYInterfaceRequestHelper shareInstance].notifyRequest setAccessToken:accessToken];
    [[DYInterfaceRequestHelper shareInstance].cmsNeedAuthInfoRequest setAccessToken:accessToken];
    [[DYInterfaceRequestHelper shareInstance].addMutipartFormDataRequest setAccessToken:accessToken];
    [[DYInterfaceRequestHelper shareInstance].diningRequest setAccessToken:accessToken];
    [[DYInterfaceRequestHelper shareInstance].diningRequest2 setAccessToken:accessToken];
    
    // 如果accessToken还有效，则重新发起请求
    if ([accessToken length] > 0) {
        [[DYInterfaceRequestHelper shareInstance] resumeAllRequstNeedToBeResume];
    }
    [self performSelector:@selector(postAccessTokenStatusNotification) withObject:nil afterDelay:.1];
    
}

- (void)postAccessTokenStatusNotification
{
    if ([self.accessToken length] > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ACCESS_TOKEN_VALID object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:ACCESS_TOKEN_INVALID object:nil];
    }
}

- (void)setRefreshToken:(NSString *)refreshToken
{
    _refreshToken = refreshToken;
    if ([refreshToken length] > 0) {
        [DYAppConfigManager shareInstance].isLogined = YES;
    }
    else
    {
        [DYAppConfigManager shareInstance].isLogined = NO;
        [self performSelector:@selector(setAccessToken:) withObject:nil afterDelay:.1];
    }
    
    [[DYAppConfigManager shareInstance] saveIntoFile];
}

- (void)loadAuthInfo
{
    if ([DYAppConfigManager shareInstance].isLogined) {
        NSString *userTokenString = [DYTools getInfoFromKeychainForKey:@"token"];
        NSData *data = [userTokenString dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        self.userName = json[@"user_name"];
        self.tokenType = json[@"token_type"];
        self.refreshToken = json[@"refresh_token"];
        self.expiredTime = [json[@"expired_time"] integerValue];
        NSString* accessToken = json[@"access_token"];
        
        if ([self isAccessTokenExpired] && [accessToken length] > 0) {
            self.accessToken = accessToken;
        }
    }
    else
    {
        [self logout];
    }
}

- (void)setExpiredTime:(NSTimeInterval)expiredTime
{
    NSTimeInterval expiredTimeSince2015 = (2015.0 - 1970)*365*24*60*60;
    NSTimeInterval delayRefreshSeconds = 0;

    // 如果参数为到期的时间，则得到还有多长时间过期；如果参数为延迟刷新的秒数，则直接转成毫秒数
    if (expiredTime > expiredTimeSince2015) {
        delayRefreshSeconds = expiredTime - [[NSDate date] timeIntervalSince1970];
        _expiredTime = expiredTime;
    }
    else
    {
        delayRefreshSeconds = expiredTime;
        _expiredTime = [[NSDate date] timeIntervalSince1970] + expiredTime;
    }
    
    if (delayRefreshSeconds > 0) {
        [self prepareNeedRefreshTokenNotification:delayRefreshSeconds];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:ACCESS_TOKEN_NEED_UPDATE object:nil];
    }
}

- (BOOL)isAccessTokenExpired
{
    return self.expiredTime - [[NSDate date] timeIntervalSince1970] > REFRESH_TIME_ALLOWANCE;
}

- (void)prepareNeedRefreshTokenNotification:(NSTimeInterval)seconds
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(postNeedRefreshTokenNotification)
                                               object:nil];
    [self performSelector:@selector(postNeedRefreshTokenNotification)
               withObject:nil
               afterDelay:seconds-REFRESH_TIME_ALLOWANCE];   // 提前10秒刷
}

- (void)postNeedRefreshTokenNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ACCESS_TOKEN_NEED_UPDATE object:nil];
}

- (void)saveAuthInfo
{
    NSDictionary *dict = @{
                           @"user_name" : self.userName,
                           @"token_type" : self.tokenType,
                           @"access_token" : self.accessToken,
                           @"refresh_token" : self.refreshToken,
                           @"expired_time" : @(self.expiredTime)
                           };
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    
    NSString *jsonString = nil;
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    if([jsonString length] > 0) {
        [DYTools saveInfoIntoKeychainForKey:@"token" withValue:jsonString];
    }
}

- (void)clearAuthInfoAtKeychain
{
    [DYTools clearInfoFromKeychainForKey:@"token"];
}

- (BOOL)isAccessTokenValid
{
    return [self isAccessTokenExpired] && [self.accessToken length] > 0;
}

- (BOOL)isLogined
{
    return [self.refreshToken length] > 0;
}

- (void)logout
{
    self.userName = @"";
    self.tokenType = @"";
    self.accessToken = @"";
    self.refreshToken = @"";
    self.expiredTime = 0;
    
    [self clearAuthInfoAtKeychain];
}

- (void)registerRefreshNotification:(id)whoNeedRegister withSelector:(SEL)selector
{
    [[NSNotificationCenter defaultCenter] addObserver:whoNeedRegister selector:selector name:ACCESS_TOKEN_NEED_UPDATE object:nil];
}

- (void)unregisterRefreshNotification:(id)whoNeedUnRegister withSelector:(SEL)selector
{
    [[NSNotificationCenter defaultCenter]removeObserver:whoNeedUnRegister name:ACCESS_TOKEN_NEED_UPDATE object:nil];
}

@end
