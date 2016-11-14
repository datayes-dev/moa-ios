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
//  DYInterfacePropertiesManager.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/10/22.
//

#import <Foundation/Foundation.h>
#import "DYAppModuleItem.h"
#import "DYInterfaceIdDef.h"

@interface DYInterfacePropertiesManager : NSObject

/**
 *	@brief	开发环境BaseUrl
 */
@property (nonatomic, strong)NSString* devBaseUrl;

/**
 *	@brief	测试环境BaseUrl
 */
@property (nonatomic, strong)NSString* qaBaseUrl;

/**
 *	@brief	仿真环境BaseUrl
 */
@property (nonatomic, strong)NSString* stageBaseUrl;

/**
 *	@brief	线上环境BaseUrl
 */
@property (nonatomic, strong)NSString* productBaseUrl;

/**
 *	@brief	开发环境相关网页的baseUrl
 */
@property (nonatomic, strong)NSString* webpageDevBaseUrl;

/**
 *	@brief	测试环境相关网页的baseUrl
 */
@property (nonatomic, strong)NSString* webpageQaBaseUrl;

/**
 *	@brief	资讯、公告、研报落地页URL
 */
@property (nonatomic, strong)NSString* infoWebHTMLProductBaseURl;

/**
 *	@brief	资讯、公告、研报落地页URL
 */
@property (nonatomic, strong)NSString* infoWebHTMLStageBaseURl;

/**
 *	@brief	仿真环境相关网页的baseUrl
 */
@property (nonatomic, strong)NSString* webpageStageBaseUrl;

/**
 *	@brief	线上环境相关网页的baseUrl
 */
@property (nonatomic, strong)NSString* webpageProductBaseUrl;

/**
 *	@brief	新闻页面的subUrl
 */
@property (nonatomic, strong)NSString* infoSubUrl;

/**
 *	@brief	研报页面的subUrl
 */
@property (nonatomic, strong)NSString* researchSubUrl;

/**
 *	@brief	公告页面的subUrl
 */
@property (nonatomic, strong)NSString* announcementSubUrl;

/**
 *	@brief	个股公告的subUrl
 */
@property (nonatomic, strong)NSString* subscribeSubUrl;

/**
 *	@brief	通知落地页的subUrl
 */
@property (nonatomic, strong)NSString* notifySubUrl;

/**
 *	@brief	测试环境 authority Url
 */
@property (nonatomic, strong)NSString* qaAuthorityUrl;

/**
 *	@brief	仿真环境 authority Url
 */
@property (nonatomic, strong)NSString* stageAuthorityUrl;

/**
 *	@brief	线上环境 authority Url
 */
@property (nonatomic, strong)NSString* productAuthorityUrl;

/**
 *	@brief	站内信（通知）dev环境url
 */
@property (nonatomic, strong)NSString* devNotifyUrl;

/**
 *	@brief	站内信（通知）qa环境url
 */
@property (nonatomic, strong)NSString* qaNotifyUrl;

/**
 *	@brief	站内信（通知）stage环境url
 */
@property (nonatomic, strong)NSString* stageNotifyUrl;

/**
 *	@brief	站内信（通知）product环境url
 */
@property (nonatomic, strong)NSString* productNotifyUrl;

/**
 *	@brief app推送 url
 */
@property (nonatomic, strong)NSString *devAppPushUrl;

/**
 *	@brief app推送 url
 */
@property (nonatomic, strong)NSString *qaAppPushUrl;

/**
 *	@brief app推送 url
 */
@property (nonatomic, strong)NSString *stageAppPushUrl;

/**
 *	@brief app推送 url
 */
@property (nonatomic, strong)NSString *productAppPushUrl;

/**
 *	@brief CMS url
 */
@property (nonatomic, strong)NSString *devCMSUrl;

/**
 *	@brief CMS url
 */
@property (nonatomic, strong)NSString *qaCMSUrl;

/**
 *	@brief CMS url
 */
@property (nonatomic, strong)NSString *stageCMSUrl;

/**
 *	@brief CMS url
 */
@property (nonatomic, strong)NSString *productCMSUrl;

/**
 *	@brief	微信API dev环境
 */
@property (nonatomic, strong)NSString *devWeixinAPIUrl;

/**
 *	@brief	微信API qa环境
 */
@property (nonatomic, strong)NSString *qaWeixinAPIUrl;

/**
 *	@brief	微信API stage环境
 */
@property (nonatomic, strong)NSString *stageWeixinAPIUrl;

/**
 *	@brief	微信API product环境
 */
@property (nonatomic, strong)NSString *productWeixinAPIUrl;

/**
 *	@brief	接口参数列表
 */
@property (nonatomic, strong)NSArray<DYAppModuleItem>* interfaceModules;

/**
 *	@brief	单例方法
 *
 *	@return	返回单例
 */
+ (instancetype)shareInstance;
/**
 *	@brief	根据请求ID获取请求接口信息
 *
 *	@param 	msgId 	msgId
 *
 *	@return	返回接口信息
 */
+ (DYInterfaceInfo*)interfaceInfoWithInterfaceId:(EInterfaceId)msgId;

@end
