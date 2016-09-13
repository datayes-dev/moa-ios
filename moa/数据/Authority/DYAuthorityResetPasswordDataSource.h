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
//  DYAuthoritrResetPasswordDataSource.h
//  IntelligenceResearchReport
//
//  Created by wangshaiding on 15/9/21.
//

#import "DYDataSourceBase.h"

@interface DYAuthorityResetPasswordDataSource : DYDataSourceBase


/**
 *	@brief	根据手机获取该用户的信息（不需要图片验证码）
 *
 *	@param 	mobile 	手机号
 *	@param 	imageValidateCode 	图片验证码
 *	@param 	resultBlock 	返回结果Block
 */
- (void)requestUserInfoWithMobile:(NSString*)mobile resultBlock:(DYInterfaceResultBlock)resultBlock;


/**
 *	@brief	根据邮箱获取该用户的信息（不需要图片验证码）
 *
 *	@param 	email 	邮箱地址
 *	@param 	imageValidateCode 	图片验证码
 *	@param 	resultBlock 	返回结果Block
 */
- (void)requestUserInfoWithEmail:(NSString*)email resultBlock:(DYInterfaceResultBlock)resultBlock;


/**
 *	@brief	根据手机获取该用户的信息
 *
 *	@param 	mobile 	手机号
 *	@param 	imageValidateCode 	图片验证码
 *	@param 	resultBlock 	返回结果Block
 */
- (void)requestUserInfoWithMobile:(NSString*)mobile imageValidateCode:(NSString*)imageValidateCode resultBlock:(DYInterfaceResultBlock)resultBlock;


/**
 *	@brief	根据邮箱获取该用户的信息
 *
 *	@param 	email 	邮箱地址
 *	@param 	imageValidateCode 	图片验证码
 *	@param 	resultBlock 	返回结果Block
 */
- (void)requestUserInfoWithEmail:(NSString*)email imageValidateCode:(NSString*)imageValidateCode resultBlock:(DYInterfaceResultBlock)resultBlock;


/**
 *	@brief	发送手机验证码
 *
 *	@param 	resultBlock 	返回结果Block
 */
- (void)requestMobileValidCodeWithResultBlock:(DYInterfaceResultBlock)resultBlock;


/**
 *	@brief	 验证手机验证码，获取token
 *
 *	@param 	validCode 	短信收到的验证码
 *	@param 	resultBlock 	返回结果Block
 */
- (void)requestResetTokenWithValidCode:(NSString*)validCode resultBlock:(DYInterfaceResultBlock)resultBlock;


/**
 *	@brief	重置密码
 *
 *	@param 	newPassword 	新密码
 *	@param 	token 	上一步得到的token
 *	@param 	resultBlock 	返回结果Block
 */
- (void)requestResetPassword:(NSString *)newPassword withToken:(NSString*)token resultBlock:(DYInterfaceResultBlock)resultBlock;


/**
 *	@brief	发送修改密码邮件
 *
 *	@param 	resultBlock 	返回结果Block
 */
- (void)requestValidEmailWithResultBlock:(DYInterfaceResultBlock)resultBlock;


- (NSString *)getErrorMessageWithCode:(int)errorCode;

@end
