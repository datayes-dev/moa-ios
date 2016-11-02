//
//  DYTools+AppInfo.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/9/15.
//  Copyright (c) 2015年 datayes. All rights reserved.
//

#import "DYTools.h"

@interface DYTools (AppInfo)

/**
 *	@brief	返回appVersion
 *
 *	@return	返回appVersion
 */
+ (NSString *)appVersion;

/**
 *	@brief	返回appBuildNumber
 *
 *	@return	返回appBuildNumber
 */
+ (NSString *)appBuildNumber;

/**
 *	@brief	获取app的名称
 *
 *	@return	返回app的名称
 */
+ (NSString *)appDisplayName;

@end
