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
//  DYAuthTokenManager.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/10/23.
//

#import <Foundation/Foundation.h>

#define ACCESS_TOKEN_VALID          @"access_token_valid"           // access_token已更新
#define ACCESS_TOKEN_INVALID        @"access_token_invalid"         // access_token已失效
#define ACCESS_TOKEN_NEED_UPDATE    @"access_token_need_update"     // access_token需要更新
#define NEED_LOGIN                  @"need_login"                   // 用户需要重新登录

@interface DYAuthTokenManager : NSObject

/**
 *	@brief	保存当前的accessToken
 */
@property (nonatomic, strong)NSString* accessToken;

/**
 *	@brief	保存当前的refreshToken
 */
@property (nonatomic, strong)NSString* refreshToken;

/**
 *	@brief	是否已经登录
 */
@property (nonatomic)BOOL isLogined;

/**
 *	@brief	用户名
 */
@property (nonatomic)NSString* userName;

/**
 *	@brief	token类型
 */
@property(strong, nonatomic) NSString *tokenType;

/**
 *	@brief	accesstoken过期时间
 */
@property(nonatomic) NSTimeInterval expiredTime;

/**
 *	@brief	获取认证token管理对象
 *
 *	@return	返回单例对象
 */
+ (instancetype)shareInstance;

/**
 *	@brief	判断当前accessToken是否有效
 *
 *	@return	有效时返回YES；无效时返回NO
 */
- (BOOL)isAccessTokenValid;

/**
 *	@brief	判断当前是否已登录
 *
 *	@return	返回登录状态
 */
- (BOOL)isLogined;

/**
 *	@brief	登出（清理token）
 */
- (void)logout;

/**
 *	@brief	保存认证数据
 */
- (void)saveAuthInfo;

/**
 *	@brief	注册需要更新refreshToken的通知
 *
 *	@param 	whoNeedRegister 	需要注册的实例
 */
- (void)registerRefreshNotification:(id)whoNeedRegister withSelector:(SEL)selector;

/**
 *	@brief  反注册需要更新refreshToken的通知
 *
 *	@param 	whoNeedUnRegister 	需要反注册的实例
 */
- (void)unregisterRefreshNotification:(id)whoNeedUnRegister withSelector:(SEL)selector;

@end
