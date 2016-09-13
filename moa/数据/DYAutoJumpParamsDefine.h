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
//  DYAutoJumpParamsDefine.h
//  IntelligenceResearchReport
//
//  Created by datayes on 16/1/8.
//

#ifndef DYAutoJumpParamsDefine_h
#define DYAutoJumpParamsDefine_h

#define KDYPushDataKey  @"redirectUrl"      //获取到长链字典中数据字符串的KEY

typedef NS_ENUM(NSUInteger, DYTabBarRootVCType) {
    DYTabBarRootVCTypeInfo    = 0,          // 资讯
    DYTabBarRootVCTypeStock,                // 股票池
    DYTabBarRootVCTypeDataWall,             // 数据墙
    DYTabBarRootVCTypeMine,                 // 我的
};

typedef NS_ENUM(NSUInteger,DYAutoJumpType) {
    kPushTypeNativeStockDetail =0,  //股票详情页
    kPushTypeNativeDataDetail,      //数据详情页
    kPushTypeNativeEventDetail,     //事件详情页
    kPushTypeNativeNewsInfo,        //新闻详情页
    kPushTypeNativeAnnounce,        //公告详情页
    kPushTypeNativeResearch,        //研报详情页
    kPushTypeNotJump,               //不跳转页面
    kPushTypeWEBMessage,            //Web消息页

};

//页面类型
static NSString * DYautoJumpUrlKeys[] = {
    @"^.*wordType=.&*secCode=.*$",                          //股票详情参数
    @"^.*wordType=.&*id=.*&*name=.*$",                      //数据详情参数
    @"^.*wordType=.&*eventId=.*$",                          //事件详情参数
    @"^.*wordType=.&*infoUId=.*$",                          //新闻详情参数
    @"^.*wordType=.&*announceUId=.*$",                      //公告详情参数
    @"^.*wordType=.&*researchUId=.*$",                      //研报详情参数
    @"^about:blank$",                                       //不跳转
    @"^.*www.*"                                               //Web
};


#define WORDTYPE_KEY              @"wordType"     // 跳转类型KEY
#define byWebPage_KEY             @"webFlag"      // 是否走本地 ：1为是 ，其他为默认
#define byWebPage_YES             @"1"            // ：1为是走Web页的类型
#define kDYNotJumpMark            @"about:blank"  // 不跳转标志

// 股票详情页的key
#define STOCK_SECCODE_KEY       @"secCode"      // 股票代码KEY

// 数据详情页的key
#define DATA_ID_KEY             @"id"           // 数据Id的key
#define DATA_TYPE_KEY           @"type"         // 数据类型的key
#define DATA_DBCODE_KEY         @"dbCode"       // dbCode的key
#define DATA_TITLE_KEY          @"name"         // title的key
#define DATA_PERIODDATE_KEY     @"periodDate"   // periodDate的key
 #define DATA_FREQUENCY         @"frequency"    // frequency的key

#define Event_ID                @"eventId"      // eventId的key
#define infoUId_ID              @"infoUId"      // eventId的key
#define announceUId_ID          @"announceUId"  // announceUId的key
#define researchUId_ID          @"researchUId"  // researchUId的key

#endif /* DYAutoJumpParamsDefine_h */

