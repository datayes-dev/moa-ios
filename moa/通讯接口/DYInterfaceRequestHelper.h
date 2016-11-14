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
//  DYInterfaceRequestHelper.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/10/21.
//

#import <Foundation/Foundation.h>
#import "DYInterfaceIdDef.h"

typedef void (^DYInterfaceResultBlock)(id data, NSError *error);
typedef void (^DYInterfacehasMoreDataBlock)(id data,BOOL hasMoreBool, NSError *error);

@class DYInterfaceRequesterBase;

@interface DYInterfaceRequestHelper : NSObject

/**
 *	@brief	展示数据请求
 */
@property (nonatomic, strong)DYInterfaceRequesterBase* dataInfoRequest;

/**
 *	@brief	依赖认证信息的数据请求
 */
@property (nonatomic, strong)DYInterfaceRequesterBase* dataInfoWithAuthParamsRequest;

/**
 *	@brief	认证相关数据请求
 */
@property (nonatomic, strong)DYInterfaceRequesterBase* authInfoRequest;

/**
 *	@brief	刷新access_token的请求
 */
@property (nonatomic, strong)DYInterfaceRequesterBase* accessRefreshRequest;

/**
 *	@brief	收取站内信的请求
 */
@property (nonatomic, strong)DYInterfaceRequesterBase* notifyRequest;

/**
 *	@brief	收取appPush的请求
 */
@property (nonatomic, strong)DYInterfaceRequesterBase* appPushRequest;

/**
 *	@brief	获取CMS平台的数据
 */
@property (nonatomic, strong)DYInterfaceRequesterBase* cmsRequest;

/**
 *	@brief	获取CMS平台的数据（需要认证信息）
 */
@property (nonatomic, strong)DYInterfaceRequesterBase* cmsNeedAuthInfoRequest;

/**
 *	@brief	mutipart-form-data型数据需要特殊的http头，单起个request
 */
@property (nonatomic, strong)DYInterfaceRequesterBase* addMutipartFormDataRequest;

/**
 *	@brief	吃饭付款使用的接口
 */
@property (nonatomic, strong)DYInterfaceRequesterBase* diningRequest;

@property (nonatomic, strong)DYInterfaceRequesterBase* diningRequest2;

@property (nonatomic, strong)DYInterfaceRequesterBase* weixinRequest;

/**
 *	@brief	获取单例对象
 *
 *	@return	返回单例对象
 */
+ (instancetype)shareInstance;
/**
 *	@brief	获取展示数据请求的主URL
 *
 *	@return	返回url
 */
+ (NSString*)dataInfoInterfaceBasicUrl;

/**
 *	@brief	获取依赖认证信息的数据请求的主URL
 *
 *	@return	返回url
 */
+ (NSString*)authInterfaceBasicUrl;

/**
 *	@brief	获取站内信数据请求的url
 *
 *	@return	返回url
 */
+ (NSString*)notifyUrl;


/**
 *	@brief	app推送
 *
 *	@return	返回url
 */
+ (NSString *)appPushUrl;

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
                 resultBlock:(DYInterfaceResultBlock)resultBlock;

/**
 *	@brief	将因为需要先更新accessToken再发的接口参数先保存起来
 *
 *	@param 	msgId 	接口Id
 *	@param 	params 	上行参数
 *	@param 	usingCacheFlag 	是否启用缓存，YES为启用，NO为不启用
 *	@param 	reloadFlag 	是否忽略之前的请求，强制重新加载，YES为重新加载，NO则请求可能被忽略
 *	@param 	resultBlock 	返回结果的block
 */
- (void)addRequestIntoResumeQueueWithMsgId:(EInterfaceId)msgId
                                parameters:(id)params
                             canUsingCache:(BOOL)usingCacheFlag
                               forceReload:(BOOL)reloadFlag
                               resultBlock:(DYInterfaceResultBlock)resultBlock;

/**
 *	@brief	恢复所有需要重发的请求
 */
- (void)resumeAllRequstNeedToBeResume;

/**
 *	@brief	更改现有环境
 */
- (void)changeCurrentEnvironment;

@end
