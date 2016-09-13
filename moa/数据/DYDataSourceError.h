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
//  DYDataSourceError.h
//  IntelligenceResearchReport
//
//  Created by datayes on 16/5/11.
//  处理DataSourceBase层业务逻辑error

#import <Foundation/Foundation.h>
#import "DYInterfaceRequestHelper.h"
#import "DYDataSourceBase.h"


typedef enum {
    normalState  = 2468013579,//普通状态
    disuseState  = -9990,//运维模式
} DataSourceErrorState;



@interface DYDataSourceError : NSObject
@property (nonatomic)int errorState;//错误类型（状态）

#pragma mark - 单例
//单例
+ (instancetype)shareInstance;


#pragma mark - 运维模式
-(BOOL)isDisuseState;
/**
 *	@brief	将因为运维模式不成功的接口参数先保存起来
 *
 *	@param 	msgId 	接口Id
 *	@param 	params 	上行参数
 *	@param 	usingCacheFlag 	是否启用缓存，YES为启用，NO为不启用
 *	@param 	reloadFlag 	是否忽略之前的请求，强制重新加载，YES为重新加载，NO则请求可能被忽略
 *	@param 	resultBlock 	返回结果的block
 */
- (void)addRequestIntoDisuseQueueWithMsgId:(EInterfaceId)msgId
                                parameters:(id)params
                             canUsingCache:(BOOL)usingCacheFlag
                               forceReload:(BOOL)reloadFlag
                               resultBlock:(DYInterfaceResultBlock)resultBlock;

/**
 *	@brief	恢复因为运维模式不成功需要重发的请求
 */
- (void)resumeAllDisuseRequstWithTarget:(DYDataSourceBase*)target;
@end
