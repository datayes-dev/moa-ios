//
//  DYTools+AppInfo.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/9/15.
//  Copyright (c) 2015年 datayes. All rights reserved.
//

#import "DYTools+AppInfo.h"

@implementation DYTools (AppInfo)

+ (NSString *)appVersion
{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* version =[infoDict objectForKey:@"CFBundleShortVersionString"];
    return version;
}

+ (NSString *)appBuildNumber
{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* buildNumber =[infoDict objectForKey:@"CFBundleVersion"];
    return buildNumber;
}

+ (NSString *)appDisplayName
{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* displayName =[infoDict objectForKey:@"CFBundleDisplayName"];
    return displayName;
}

@end
