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
//  DYNoticeInfoManager.h
//  IntelligenceResearchReport
//
//  Created by 鄢彭超 on 16/8/12.
//

#import "DYDataSourceBase.h"

#define NoticeArray_Key             @"noticeArray"
#define NoticeId_Key                @"noticeId"
#define NoticeType_Key              @"noticeType"
#define ViewPageId_Key              @"viewPageId"
#define NoticeTitle_Key             @"noticeTitle"
#define NoticeContent_Key           @"noticeContent"
#define NoticeUrl_Key               @"noticeUrl"
#define ExtraInfo_Key               @"extraInfo"
#define ShowLevel2_Key              @"showLevel2"
#define NoticeDesc_Key              @"noticeDesc"

typedef NS_ENUM(NSUInteger, ENoticeType) {
    eNoticeTypeUnkown = 0,                              // 未知状态
    eNoticeTypeSilentFlag = eNoticeTypeUnkown,          // 不显示，当页面的开关来使用
    eNoticeTypeShowOnce,                                // 只在某一个页面上显示一次（版本更新了也不再显示）
    eNoticeTypeShowAllTime,                             // 每次都在这个页面上显示
    eNoticeTypeShowOnceInNewVersion,                    // 只在某一个页面上显示一次（版本更新了会再显示一次）
};

@interface DYNoticeInfoManager : DYDataSourceBase

+ (instancetype)shareInstance;

/**
 *	@brief	更新notice信息（理论上，App每次从后端切到前端都应该调用这个函数）
 */
- (void)updateNoticeInfoWithFinishedBlock:(void (^)(void))finishedBlock;

/**
 *	@brief	从notice列表里面获取到指定页面需要显示的notice列表
 *
 *	@param 	viewPageId 	指定页面Id
 *
 *	@return	返回notice列表（字典）
 */
- (NSArray<NSDictionary*>*)fetchNoticeInfoForView:(NSUInteger)viewPageId;

/**
 *	@brief	获取指定页面指定显示方式的notice
 *
 *	@param 	viewPageId 	指定页面
 *	@param 	noticeType 	指定显示方式
 *
 *	@return	返回notice列表（字典）
 */
- (NSArray<NSDictionary*>*)fetchNoticeInfoForView:(NSUInteger)viewPageId withNoticeTypeFilter:(ENoticeType)noticeType;

/**
 *	@brief	告知系统这个notice已经在这个页面上显示了一次了
 *
 *	@param 	noticeId 	notice的Id
 *	@param 	viewPageId 	在这个页面上显示过了
 */
- (void)notice:(NSInteger)noticeId showOnceTimeInViewPage:(NSInteger)viewPageId;

/**
 *	@brief	判断指定notice是否还需要在页面上再显示
 *
 *	@param 	noticeId 	指定notice
 *	@param 	viewPageId 	是否需要在这个页面上再显示
 *
 *	@return	返回YES表示需要再显示，返回NO表示不需要再显示了
 */
- (BOOL)needShowNotice:(NSInteger)noticeId inViewPage:(NSInteger)viewPageId;

@end
