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
//  DYErrorHelper.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/8/11.
//

#import <Foundation/Foundation.h>

extern NSString* const kNetWorkingErrorDomain;
extern NSString* const kCodingErrorDomain;
extern NSString* const kParameterErrorDomain;
extern NSString* const kAuthorityrErrorDomain;
extern NSString* const kInterfaceDataError;
extern NSString* const kRequestError;

typedef NS_ENUM(NSInteger, NetWorkingErrorCode) {
    NetAccessError = 0,                 // 访问不通
};

typedef NS_ENUM(NSInteger, CodingErrorCode) {
    GBufferDecodeError = 0,         // GBuffer解析错误
};

typedef NS_ENUM(NSInteger, ParameterErrorCode) {
    NullParameter = 0,              // 数据为空
};

typedef NS_ENUM(NSInteger, InterfaceDataErrorCode) {
    BrokenData = 0,                 // 数据不完整
    NullData,                       // 数据为空
};

typedef NS_ENUM(NSInteger, RequestErrorCode) {
    RepeatedRequest = 0,            // 重复的请求
};

typedef NS_ENUM(NSInteger, AuthorityErrorCode) {
    Sucess = 0,                 // 成功
    InvalidName = 13,           //输入username字段为空字符串, 输入username不满足用户名规则
    MobileFormat = 16,          // 输入mobile字段为空字符串, 输入mobile不满足手机号规则
    MobileHasResigted = 17,     //该手机号已注册
    IncorrectValidateCode = 18, //验证码输入不正确 或 输入验证码后修改手机号
    PasswordFormatError = 19,   //password不满足密码规则
    ValidateCodeExpired = 20,   //验证码过期
    SendCodeFailed = 21,        //验证码发送失败
    UserNameWithAllNumber = 23, //输入username字段为纯数字
    UserNameUsed = 24,          //该用户名已经存在
    IntervalTooShort = 27,      //50秒内连续发送
    InvalidActivityCode = 39,   //活动注册码不符合规则
    NeedLogin = -403,           // access_token过期
};

@interface DYErrorHelper : NSObject

/**
 *	@brief	处理error
 *
 *	@param 	error 	error
 */
+ (void)dealWithError:(NSError*)error;
/**
 *	@brief	检查是否需要刷新access token
 *
 *	@param 	data 	包含AuthorityErrorCode的
 *
 *	@return	返回yes表示需要重新获取
 */
+ (BOOL)checkIfNeedRefreshAccessTokenWith:(id)data;

@end
