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
//  DYAuthorityRegisterDataSource.h
//  IntelligenceResearchReport
//
//  Created by wangshaiding on 15/9/21.
//

#import "DYDataSourceBase.h"

@interface MobileReqisterData : NSObject

@property(strong, nonatomic) NSString *mobile;
@property(strong, nonatomic) NSString *imageValidateCode;
@property(strong, nonatomic) NSString *validCode;
@property(strong, nonatomic) NSString *userName;
@property(strong, nonatomic) NSString *password;
@property(strong, nonatomic) UIImage *avatar;


- (NSDictionary *)generateParameters;

@end



@interface DYAuthorityRegisterDataSource : DYDataSourceBase

@property(strong, nonatomic) MobileReqisterData *mobileReqisterData;


+ (instancetype)shareInstance;


// 手机注册
/**
 *	@brief	手机注册
 *
 *	@param 	resultBlock 	回调
 */
- (void)requestMobileRegisterWithResultBlock:(DYInterfaceResultBlock)resultBlock;

// 手机注册 获取手机验证码
/**
 *	@brief	手机注册 获取手机验证码
 *
 *	@param 	resultBlock 	回调
 */
- (void)requestRegisterMobileValidCodeWithResultBlock:(DYInterfaceResultBlock)resultBlock;

// 手机注册 获取手机验证码(带图片验证码)
/**
 *	@brief	手机注册 获取手机验证码(带图片验证码)
 *
 *	@param 	resultBlock 	回调
 */
- (void)requestRegisterMobileValidCodeWithinImagecodeWithResultBlock:(DYInterfaceResultBlock)resultBlock;

// 手机注册 验证用户输入的验证码是否正确
/**
 *	@brief	手机注册 验证用户输入的验证码是否正确
 *
 *	@param 	resultBlock 	回调
 */
- (void)requestRegisterValidateCodeWithResultBlock:(DYInterfaceResultBlock)resultBlock;

@end
