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
//  DYNetStatusManager.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/10/23.
//

#import <Foundation/Foundation.h>
#import "AFNetworkReachabilityManager.h"

#define NETWORK_ENABLE_NOTIFY   @"networkEnableNotify"

@interface DYNetStatusManager : NSObject
{
    //
}

/**
 *	@brief	网络状态是否已有效
 */
@property (nonatomic)BOOL isStatusValid;

/**
 *	@brief	当前网络状态
 */
@property (atomic)AFNetworkReachabilityStatus netWorkStatus;


/**
 *	@brief	获取认证token管理对象
 *
 *	@return	返回单例对象
 */
+ (instancetype)shareInstance;

/**
 *	@brief	当前网络是否可用
 *
 *	@return	返回YES表示可用，返回NO表示不可用
 */
- (BOOL)isNetWorkAvaliable;

/**
 *	@brief	当前网络是否为WIFI
 *
 *	@return	返回YES表示为WIFI网络，返回NO表示不是WIFI网络
 */
- (BOOL)netWorkIsWifi;

/**
 *	@brief	开始监听网络
 */
- (void)startMonitorNetWork;

@end
