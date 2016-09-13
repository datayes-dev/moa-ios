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
//  DYAuthorityDataSource.h
//  IntelligenceResearchReport
//
//  Created by wangshaiding on 15/9/17.
//

#import "DYDataSourceBase.h"


@interface DYAuthorityDataSource : DYDataSourceBase


+ (instancetype)shareInstance;

// 修改密码
//- (void)requestChangePasswordUser:(NSString*)userName from:(NSString*)oldPassword to:(NSString *)newPassword resultBlock:(DYInterfaceResultBlock)resultBlock;

// 增加头像
/**
 *	@brief	增加头像
 *
 *	@param 	pictureData 	pictureData
 *	@param 	resultBlock 	resultBlock description
 */
- (void)requestAddBase64Picture:(NSString*)pictureData resultBlock:(DYInterfaceResultBlock)resultBlock;


//// 通用副本 1：验证用户输入的验证码
//- (void)requestValidateCaptha:(NSString*)captha mobile:(NSString*)mobile resultBlock:(DYInterfaceResultBlock)resultBlock;
//
//// 通用副本 2：给手机发送验证码
//- (void)requestSendMobileValidCodeWithMobile:(NSString*)mobile captcha:(NSString*)captha resultBlock:(DYInterfaceResultBlock)resultBlock;

@end
