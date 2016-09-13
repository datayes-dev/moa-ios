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
//  DYDataSourceBase.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/8/19.
//

#import <Foundation/Foundation.h>
#import "DYInterfaceIdDef.h"
#import "DYInterfaceRequestHelper.h"

#define kExtraAddedSubUrlKey @"extraAddedSubUrl"

typedef NS_ENUM(NSUInteger, SerializerFromat) {
    SerializerFromatProtobuf,
    SerializerFromatJson,
};

@interface DYDataSourceBase : NSObject

+ (BOOL)isString:(NSString*)string meetRegex:(NSString *)tempRegex;

/**
 *	@brief	子类如果有内容需要保存，需要实现这个方法
 */
- (void)saveIntoFile;

/**
 *	@brief	发送网络请求
 *
 *	@param 	msgId 	接口ID
 *	@param 	params 	参数
 *	@param 	usingCacheFlag 	暂时无用
 *	@param 	reloadFlag 	暂时无用
 *	@param 	resultBlock 	返回block
 */
- (void)sendRequestWithMsgId:(EInterfaceId)msgId
                  parameters:(id)params
               canUsingCache:(BOOL)usingCacheFlag
                 forceReload:(BOOL)reloadFlag
                 resultBlock:(DYInterfaceResultBlock)resultBlock;


@end
