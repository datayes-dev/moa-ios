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
//  DatabaseDefine.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/8/20.
//

#ifndef IntelligenceResearchReport_DatabaseDefine_h
#define IntelligenceResearchReport_DatabaseDefine_h

typedef NS_ENUM(NSUInteger, DataSearchTag) {
    SearchWhatever = 0,             // 管他搜啥呢
    SearchAllStocksProperty,        // 获取所有股票列表
    SearchStockPropertyInfo,        // 根据关键字搜索股票列表
    FetchStockPropertyInfo,         // 指定Code列表获取股票列表
    FetchFavoriteInfo,              // 获取收藏数据
};

#endif
