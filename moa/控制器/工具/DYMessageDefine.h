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
//  DYMessageDefine.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/9/22.
//

#ifndef IntelligenceResearchReport_DYMessageDefine_h
#define IntelligenceResearchReport_DYMessageDefine_h

/* 手机号最大11位，前面＋86等不支持 */
#define kDYInputMobilePhoneNumMaxCount  11

/* 验证码最大6位 */
#define kDYVerifyCodeMaxCount  6
#define KDYChangePasswordMaxCount  4        // 修改密码验证码最大位数

/* 登录密码最大20位 */
#define kDYLoginPswMaxCount  20
#define kDYLoginPswMinCount  6
/* 正则表达式 */
#define kDYRegexPhoneNums       @"^((\\+86)|(86))?(1)\\d{10}$" // 手机号码
#define kDYRegexLoginPassword   @"^[0-9A-Za-z]+$"   // 登录密码，为数字与字母的组合
#define kDYRegexRegisterPassword @"^[\\S]{6,20}$"    // 注册密码，支持字母、数字和符号

#define kDYNickNameString @"^[a-zA-Z]{1}[a-zA-Z0-9\\.]{2,28}[a-zA-Z0-9]{1}$"

#endif
