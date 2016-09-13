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
//  DYInterfaceRequesterBase.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/10/20.
//

#import <Foundation/Foundation.h>
#import "DYInterfaceIdDef.h"
#import "DYInterfaceInfo.h"
//#import "DYHttpRequestWithCacheOperationManager.h"

@class AFHTTPRequestOperationManager;
@class AFHTTPRequestOperation;
//@class DYHttpRequestWithCacheOperationManager;

typedef void (^DYRequestResultBlock)(AFHTTPRequestOperation *operation, id data, NSError *error);

@interface DYInterfaceRequesterBase : NSObject

/**
 *	@brief	主URL
 */
@property (nonatomic, strong)NSString* basicUrl;

/**
 *	@brief	请求管理员
 */
@property (nonatomic, strong) AFHTTPRequestOperationManager *requestOperationManager;

/**
 *	@brief	网络相关操作丢到这个队列里进行
 */
@property (nonatomic, strong)dispatch_queue_t networkProcessingQueue;

/**
 *	@brief	初始化
 *
 *	@param 	url 	指定 basicUrl
 *
 *	@return	返回 DYInterfaceRequesterBase 对象
 */
- (instancetype)initWithUrl:(NSString*)url;

/**
 *	@brief	设置认证信息
 *
 *	@param 	accessToken 	认证的access_token
 */
- (void)setAccessToken:(NSString*)accessToken;

/**
 *	@brief	发送接口请求
 *
 *	@param 	msgId 	接口Id
 *	@param 	params 	上行参数
 *	@param 	usingCacheFlag 	是否启用缓存，YES为启用，NO为不启用
 *	@param 	reloadFlag 	是否忽略之前的请求，强制重新加载，YES为重新加载，NO则请求可能被忽略
 *	@param 	resultBlock 	返回结果的block
 */
- (void)sendRequestWithMsgId:(EInterfaceId)msgId
                  parameters:(id)params
               canUsingCache:(BOOL)usingCacheFlag
                 forceReload:(BOOL)reloadFlag
                 resultBlock:(DYRequestResultBlock)resultBlock;

#pragma mark - 子类重载的方法

/**
 *	@brief	部署请求管理员
 */
- (void)setupRequestOperationManager;

/**
 *	@brief	部署网络相关操作执行的操作队列
 */
- (void)setupNetWorkProcessingQueue;

@end
