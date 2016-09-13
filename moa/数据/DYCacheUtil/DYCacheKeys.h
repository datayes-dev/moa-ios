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
//  DYCacheKeys.h
//  IntelligenceResearchReport
//
//  Created by datayes on 16/8/15.
/*  文件夹目录结构
Documents|cache  |common |net    |
         |       |       |device |
         |       |user   |id1    |
         |       |       |id2    |
         |file   |
*/

#import <Foundation/Foundation.h>


//-----------net----------

//资讯页新闻详情缓存，key = 文件夹名 + / + MD5(url)
//文件夹名：
#define CK_NewsContentURLDatas           @"NewsURLDatas"

#define CK_NewsReuseFiles                @"NewsReuseFiles"

//----------device--------

//当前数据分组id
#define CK_DataFollowGroupID     @"DataFollowGroupID"

//网络无法访问时提示，3秒内不会再提示
#define CK_ShowNoNetWorkFlag     @"showNoNetWorkFlag"

//web字体size
#define CK_WebTextFontSize       @"WebFontSize"

//未登录时的搜索历史
#define CK_SearchHistory         @"SearchHistory"

//记录已读过的indicId的时间，key = 文件夹名 + / + indecId
//文件夹名：
#define CK_IndicIDs              @"IndicIDs"

