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
//  DYErrorHandlerHelper.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/10/21.
//

#import <Foundation/Foundation.h>
#import "DYInterfaceIdDef.h"
#import "DYInterfaceRequestHelper.h"

@class AFHTTPRequestOperation;

@interface DYErrorHandlerHelper : NSObject

/**
 *	@brief	处理网络请求的返回
 *
 *	@param 	response 	response
 *	@param 	className 	错误类型
 *	@param 	requester 	网络请求
 *	@param 	msgId 	请求ID
 *	@param 	usingCacheFlag 	是否缓存
 *	@param 	reloadFlag 	是否强制reload
 *	@param 	params 	请求参数
 *	@param 	resultBlock 	请求返回
 *
 *	@return	如果有错则返回错误
 */
+ (NSError*)dealWithResponse:(id)response
           andErrorClassName:(NSString*)className
               fromRequester:(DYInterfaceRequesterBase*)requester
              andInterfaceId:(EInterfaceId)msgId
       withcanUsingCacheFlag:(BOOL)usingCacheFlag
          andforceReloadFlag:(BOOL)reloadFlag
                   andParams:(id)params
              andResultBlock:(DYInterfaceResultBlock)resultBlock;


@end
