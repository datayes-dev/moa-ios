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
//  DYAuthorityManager.m
//  IntelligenceResearchReport
//
//  Created by wangshaiding on 15/9/17.
//

#import "DYAuthorityManager.h"
#import "DYErrorHelper.h"
#import "DYAuthTokenManager.h"


NSString* const kNotiAccessTokenAvailable = @"NotiAccessTokenAvailable";
NSString* const kNotiUserShouldLogin = @"NotiUserShouldLogin";
#define MAX_REFRESH_RETRY   15      // 同一个refreshToken去刷新accessToken的次数

static DYAuthorityManager *_sharedInstance;

@interface DYAuthorityManager ()
@end


@implementation DYAuthorityManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[DYAuthorityManager alloc] init];
    });
    
    return _sharedInstance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registerAccessTokenRefreshNotification];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)requestAccessTokenWithUserName:(NSString *)userName password:(NSString*)password captcha:(NSString*)captcha tenant:(NSString *)tenant resultBlock:(DYInterfaceResultBlock)resultBlock
{
    //login
    __weak __typeof(self)weakSelf = self;
    [DYAuthorityLoginDataSource shareInstance].userLoginData.grantType = Password;
    [DYAuthorityLoginDataSource shareInstance].userLoginData.userName = userName;
    [DYAuthorityLoginDataSource shareInstance].userLoginData.password = password;
    [DYAuthTokenManager shareInstance].userName = userName;
    
    if ([tenant length] > 0) {
        [DYAuthorityLoginDataSource shareInstance].userLoginData.tenant = tenant;
    }else {
        [DYAuthorityLoginDataSource shareInstance].userLoginData.tenant = nil;
    }
    
    if([captcha length] > 0) {
        [DYAuthorityLoginDataSource shareInstance].userLoginData.captcha = captcha;
    }
    else
    {
        [DYAuthorityLoginDataSource shareInstance].userLoginData.captcha = nil;
    }
    [[DYAuthorityLoginDataSource shareInstance] requestUserNameLoginWithResultBlock:^(id data, NSError *error) {
        if(!error && data != nil) {
            [weakSelf parseLoginResult:data];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            resultBlock(data, error);
        });

    }];
}

- (void)refreshAccessTokenWithRefreshToken
{
    __weak __typeof(self)weakSelf = self;
    NSString* refreshToken = [DYAuthTokenManager shareInstance].refreshToken;
    static NSString* sRefreshToken = nil;
    static NSInteger sRetryCount = 0;
    if (sRefreshToken == nil ||
        [sRefreshToken compare:refreshToken] != NSOrderedSame) {
        sRefreshToken = [refreshToken copy];
        sRetryCount = 0;
    }
    
    if ([refreshToken length] > 0) {
        // 使用refresh token更新access token
        sRetryCount ++;
        
        // 使用同一个refreshToken刷新不能超过15次，要不就死循环了
        if (sRetryCount < MAX_REFRESH_RETRY) {
            [self requestAccessTokenByRefreshTokenWithResultBlock:^(id data, NSError *error) {
                if (!error && data != nil) {
                    // 更新成功
                    [weakSelf parseLoginResult:data];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiAccessTokenAvailable object:nil];
                } else {
                    // 只有无效时获取这东西，才需要重置
                    if (![[DYAuthTokenManager shareInstance] isAccessTokenValid]) {
                        if (error.code == NotExist) {   // 账户不存在，登出
                            [[NSNotificationCenter defaultCenter] postNotificationName:kNotiUserShouldLogin object:nil];
                            [DYAuthTokenManager shareInstance].refreshToken = @"";
                        }
                    }
                }
            }];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotiUserShouldLogin object:nil];
            [DYAuthTokenManager shareInstance].refreshToken = @"";
        }
    }
//    else {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiUserShouldLogin object:nil];
//    }
}

#pragma mark - Private

- (void)requestAccessTokenByRefreshTokenWithResultBlock:(DYInterfaceResultBlock)resultBlock
{
    //login
    [DYAuthorityLoginDataSource shareInstance].userLoginData.grantType = RefreshToken;
    [DYAuthorityLoginDataSource shareInstance].userLoginData.refreshToken = [DYAuthTokenManager shareInstance].refreshToken;
    [[DYAuthorityLoginDataSource shareInstance] requestUserNameLoginWithResultBlock:^(id data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            resultBlock(data, error);
        });
    }];
}

- (void)parseLoginResult:(NSDictionary*)result
{
    NSString* accessToken = result[@"access_token"];
    NSString* refreshToken = result[@"refresh_token"];
    NSString* tokenType = result[@"token_type"];
    NSTimeInterval expiresTime = [result[@"expires_in"] floatValue];
    
    [DYAuthTokenManager shareInstance].accessToken = accessToken;
    [DYAuthTokenManager shareInstance].refreshToken = refreshToken;
    [DYAuthTokenManager shareInstance].expiredTime = expiresTime;
    [DYAuthTokenManager shareInstance].tokenType = tokenType;
    [[DYAuthTokenManager shareInstance] saveAuthInfo];
}

- (void)registerAccessTokenRefreshNotification
{
    [[DYAuthTokenManager shareInstance] registerRefreshNotification:self withSelector:@selector(refreshAccessTokenWithRefreshToken)];
}

@end
