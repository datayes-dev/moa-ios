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
//  DYAppConfigManager.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/8/25.
//

#import "DYDataSourceBase.h"
typedef NS_ENUM(NSUInteger, ECurrentEnvType){
    eCurrentEnvTypeDev = 0,       //开发环境
    eCurrentEnvTypeQA,            //QA环境
    eCurrentEnvTypeStag,          //Stag环境
    eCurrentEnvTypeProduct        //Product环境
};

@interface DYAppConfigManager : DYDataSourceBase

/**
 *	@brief	获取单例对象
 *
 *	@return	返回单例对象
 */
+ (instancetype)shareInstance;

/**
 *	@brief	保存配置到文件
 */
- (void)saveIntoFile;

/**
 *	@brief	渠道Id
 */
@property (nonatomic, strong)NSNumber* channelId;

/**
 *	@brief	产品Id
 */
@property (nonatomic, strong)NSNumber* productId;

/**
 *	@brief	irr产品Id
 */
@property (nonatomic, strong)NSNumber* irrProductId;

/**
 *	@brief	机型Id
 */
@property (nonatomic, strong)NSNumber* mobileTypeId;

/**
 *	@brief	股票基本属性的时间戳
 */
@property (nonatomic, strong)NSDate* stockPropertyInfoTimestamp;

/**
 *	@brief	访问数据使用的token
 */
@property (nonatomic, strong)NSString* accessToken;

/**
 *	@brief	刷新token使用的token
 */
@property (nonatomic, strong)NSString* refreshToken;

/**
 *	@brief	苹果推送相关的token
 */
@property (nonatomic, strong)NSString* notifyToken;

/**
 *	@brief	设备相关Id
 */
@property (nonatomic, strong)NSString* deviceId;

/**
 *	@brief	数据库的版本
 */
@property (nonatomic, strong)NSNumber* dbVersion;

/**
 *	@brief	当前配置文件版本
 */
@property (nonatomic, strong)NSNumber* version;

/**
 *	@brief	用户登录后，置该标志，表示代表保存在钥匙串里的token是有效的；用户登出后，reset该标志
 */
@property (nonatomic)BOOL isLogined;

/**
 *	@brief	屏幕是否被用户手动锁定
 */
@property (nonatomic)BOOL isScreenLocked;

/**
 *	@brief	是否第一次安装运行
 */
@property (nonatomic)BOOL isFirstTimeRun;

/**
 *	@brief	是否已选择研究兴趣
 */
@property (nonatomic) BOOL hasChooseIntersting;


/**
 *	@brief	是否展示默认数据
 */
@property (nonatomic) BOOL isShowDefaultData;

/**
 *	@brief	当前环境
 */
@property (nonatomic) NSNumber *currentEnvironment;

/**
 *	@brief	是否为顾客
 */
@property (nonatomic) BOOL isCustomer;

@property (nonatomic, strong) NSString *lastTimeHongguanPreload;
@property (nonatomic, strong) NSString *lastTimeChanjingPreload;
@property (nonatomic, strong) NSString *lastTimeCompanyPreload;
@property (nonatomic, strong) NSString *lastTimeSubscribePreload;
@property (nonatomic, strong) NSString *lastTimeAnnPreload;

#pragma mark - functions

- (BOOL)checkIfNeedUpdate;

@end
