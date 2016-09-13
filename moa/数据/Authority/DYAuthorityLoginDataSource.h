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
//  DYAuthorityLoginDataSource.h
//  IntelligenceResearchReport
//
//  Created by wangshaiding on 15/9/22.
//

#import "DYDataSourceBase.h"


typedef NS_ENUM(NSUInteger, GrantType) {
    Password, // 使用用户名密码登录，当tenant未指定时，视为通行证登录
    RefreshToken, // 使用refresh_token刷新access_token
    Permanent, // 获取永久token
    RefreshPermanent, // 使用refresh_token刷新permanent token
    Anonymous, // 获取匿名token
    Wechat, // 使用微信oauth接口返回的code进行登录
    WechatCorp, // 微信企业号登录
};


@interface UserLoginData : NSObject

#pragma mark - required
@property(assign, nonatomic) GrantType grantType;


#pragma mark - optional
// user login
@property(strong, nonatomic) NSString *userName;
@property(strong, nonatomic) NSString *password;
@property(strong, nonatomic) NSString *captcha;
// refresh token
@property(strong, nonatomic) NSString *refreshToken;

@property(strong, nonatomic) NSString *appId;
@property(strong, nonatomic) NSString *appSecret;
@property(strong, nonatomic) NSString *setContext;
@property(strong, nonatomic) NSString *authCode;
@property(strong, nonatomic) NSString *tenant;


/**
 *	@brief	返回GrantType类型String
 *
 *	@param 	grantType 	grantType
 *
 *	@return	返回GrantType类型String
 */
+ (NSString*)grantTypeString:(GrantType)grantType;


/**
 *	@brief	生成登录参数
 *
 *	@return	返回参数字典
 */
- (NSDictionary *)generateLoginParameters;

@end


typedef NS_ENUM(NSInteger, OAuth2ErrorCode) {
    Successful = 0,             // successful
    InvalidInput = -100,        // invalid input,
    InvalidFormat = -102,       // invalid data format
    InvalidPassword = -101,     // invalid password
    InvalidRecord = -103,       // invalid record
    InvalidVerifyCode = -105,   // invalide verify code
    DuplicatedValue = -110,     // duplicated value
    NotExist = -120,            // not exist
    CodeRequired = -130,        // code required
    UserDenied = -202,          // user didn't grant access.
    Redirect = -407,            // redirect
    InternalError = -500,       // internal error
    RemoteError = -501          // remote error

};


@interface DYAuthorityLoginDataSource : DYDataSourceBase

@property(strong, nonatomic) UserLoginData *userLoginData;

/**
 *	@brief	单例方法
 *
 *	@return	返回单例
 */
+ (instancetype)shareInstance;


// 登录
/**
 *	@brief	登录
 *
 *	@param 	resultBlock 	resultBlock description
 */
- (void)requestUserNameLoginWithResultBlock:(DYInterfaceResultBlock)resultBlock;

// 登出
/**
 *	@brief	登出
 *
 *	@param 	accessToken 	accessToken
 *	@param 	resultBlock 	resultBlock description
 */
- (void)requestLogoutWithAccessToken:(NSString*)accessToken resultBlock:(DYInterfaceResultBlock)resultBlock;


@end
