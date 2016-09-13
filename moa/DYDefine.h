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
//  DYDefine.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/8/19.
//

#ifndef IntelligenceResearchReport_DYDefine_h
#define IntelligenceResearchReport_DYDefine_h


typedef NS_ENUM(NSInteger,StockPoolType) {
    kStockPoolTypeDefault = -1, //默认
    kStockPoolTypePrice =0,     //现价
    kStockPoolTypeRise,         //日涨幅
    kStockPoolTypePE,           //PE
    kStockPoolTypeBargain,      //成交额
    kStockPoolTypeShiZi,        //流通市值
    kStockPoolTypeGuBen,        //流通股本
    kStockPoolTypeZongShizi,    //总市值
    kStockPoolTypeChange,       //涨跌额

};

typedef NS_ENUM(NSInteger,StockPoolSortType) {
    kStockPoolSortTypeDefault = 0,  //正常
    kStockPoolSortTypeAscending ,   //升序
    kStockPoolSortTypeDscending ,   //降序
};

typedef NS_ENUM(NSInteger, EInformationType) {
    eInformationTypeNews = 0,           // 0为新闻
    eInformationTypeAnnouncement = 1,   // 1为公告
    eInformationTypeReport = 2,         // 2为研报
    eInformationTypeMonitor = 3,        // 3为监控数据
};

typedef NS_ENUM(NSInteger, SyncStatus) {
    statusUnknown = 0,              // 未知
    statusNormal,                   // 正常状态
    statusAdded,                    // 已添加状态，未上传添加信息
    statusDeleted,                  // 已删除，未上传删除信息
};

//颜色值
#define UIColorFromRGB(R,G,B)        [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]
#define UIColorFromRGBValue(V)       [UIColor colorWithRed:(((V)>>16)&0xFF)/255.0 green:(((V)>>8)&0xFF)/255.0 blue:((V)&0xFF)/255.0 alpha:1]
#define UIColorFromRGBValueAndAlpha(V,a) [UIColor colorWithRed:(((V)>>16)&0xFF)/255.0 green:(((V)>>8)&0xFF)/255.0 blue:((V)&0xFF)/255.0 alpha:a]


//屏幕宽高
#define DYScreenWidth [UIScreen mainScreen].bounds.size.width
#define DYScreenHeight [UIScreen mainScreen].bounds.size.height
#define DYSelfViewWidth self.view.bounds.size.width
#define DYSelfViewHeight self.view.bounds.size.height
#define isIphone4  ([UIScreen mainScreen].bounds.size.height ==480 ?YES : NO)
#define isIphone5  ([UIScreen mainScreen].bounds.size.width ==320 ?YES : NO)
#define isIphone6  ([UIScreen mainScreen].bounds.size.width ==375 ?YES : NO)
#define isIphone6p  ([UIScreen mainScreen].bounds.size.width ==414 ?YES : NO)
#define DYNavigationBarHeight 44
#define DYStatusBarHeight 20
#define DYTabbarFrame [[[UIApplication sharedApplication] delegate].tabBarController getTabbarFrame]
#define DYTabbarHeight 49

//系统版本
#pragma mark - 设备系统版本相关
#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
#define IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending)
#define IOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending)
#define IOS_VERSION     [[[UIDevice currentDevice] systemVersion] floatValue]

//字体
#define DefaultFontWithSize(_size)  [UIFont fontWithName:kHBDefaultFontName size:_size]
#define MediumFontWithSize(_size)   [UIFont fontWithName:kHBMediumFontName size:_size]

//
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define NilToEmptyString(s)             ((s) ? (s) : @"")   // nil to ""


#define OJC_ISNOT_NIL_NULL(__POINTER) ((__POINTER == nil || (NSNull *)__POINTER == [NSNull null]) ? NO : YES)
#define STRING_NIL_TO_NONE(__POINTER) if (__POINTER == nil || (NSNull *)__POINTER == [NSNull null]){__POINTER = @"";}
#define NSNUMBER_NULL_TO_NIL(__POINTER) if ((NSNull *)__POINTER == [NSNull null]){__POINTER = nil;}

#define STRING_NIL_TO_LINE(__POINTER) if (__POINTER == nil || (NSNull *)__POINTER == [NSNull null]||[__POINTER isEqualToString:@""]){__POINTER = @"--";}

#define STRING_ISNIL(__POINTER) ((__POINTER == nil || (NSNull *)__POINTER == [NSNull null] || [__POINTER isEqualToString:@""])?YES:NO)

#define NANZERO(x)    if(isnan(x)) x=0;

//
#define SUSPENSION_STRING @"--"


//Key:
#define kFuquanIndexKey @"fuquanIndexKey"
#define kFuquanFirstTimeKey @"kFuquanFirstTimeKey"
#define KDYCompanyGroupCurrentIndex @"KDYCompanyGroupCurrentIndex"
static NSString * const kAdvertisementKey = @"kAdvertisementKey";
#endif
