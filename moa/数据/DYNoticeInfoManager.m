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
//  DYNoticeInfoManager.m
//  IntelligenceResearchReport
//
//  Created by 鄢彭超 on 16/8/12.
//

#import "DYNoticeInfoManager.h"
#import "DYAppConfigManager.h"
#import "DYTools+AppInfo.h"

static DYNoticeInfoManager* gNoticeInfoManager = nil;

@interface DYNoticeInfoManager ()

/**
 *	@brief	通告存放的字典
 */
@property (nonatomic, strong)NSArray* noticeInfoArray;

/**
 *	@brief	一些用户的留痕保存到这里
 */
@property (nonatomic, strong)NSUserDefaults* userDefaults;

@end

@implementation DYNoticeInfoManager

- (NSUserDefaults*)userDefaults
{
    if (_userDefaults == nil) {
        _userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"noticeInfos"];
    }
    
    return _userDefaults;
}

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gNoticeInfoManager = [DYNoticeInfoManager new];
    });
 
    return gNoticeInfoManager;
}

- (void)updateNoticeInfoWithFinishedBlock:(void (^)(void))finishedBlock
{
    NSString* urlString = nil;
    NSNumber *currentEvn = [DYAppConfigManager shareInstance].currentEnvironment;
    ECurrentEnvType currentEnvType = [currentEvn integerValue];
    
    //公告、新闻、研报的该URL虽然链接不同，但其实内容相同，是可以复用的，因此在同一环境下存成统一文件
    switch (currentEnvType) {
        case eCurrentEnvTypeDev:
        case eCurrentEnvTypeQA:
        case eCurrentEnvTypeStag:
            urlString = @"https://mobile.wmcloud.com/mobile/irrAppNoticeStg.config.geojson";
            break;
            
        case eCurrentEnvTypeProduct:
            urlString = @"https://mobile.wmcloud.com/mobile/irrAppNotice.config";
            break;
            
        default:
            break;
    }
    
    if ([urlString length] > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData* jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
            if (jsonData != nil && [jsonData isKindOfClass:[NSData class]] && [jsonData length] > 0) {
                NSError *error;
                NSDictionary *noticeInfoDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
                if (error == nil && noticeInfoDic != nil && [noticeInfoDic isKindOfClass:[NSDictionary class]]) {
                    NSArray* noticeInfoArray = [noticeInfoDic objectForKey:NoticeArray_Key];
                    if ([noticeInfoArray isKindOfClass:[NSArray class]]) {
                        self.noticeInfoArray = noticeInfoArray;
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                finishedBlock();
            });
        });
    }
}

- (NSArray<NSDictionary*>*)fetchNoticeInfoForView:(NSUInteger)viewPageId
{
    if ([self.noticeInfoArray count] <= 0) {
        return nil;
    }
    
    NSPredicate* thePredicate = [NSPredicate predicateWithFormat:@"SELF.%@ == %d", ViewPageId_Key, viewPageId];
    NSArray* resultArray = [self.noticeInfoArray filteredArrayUsingPredicate:thePredicate];
    
    NSMutableArray* mArray = [NSMutableArray array];
    for (NSDictionary* dic in resultArray) {
        NSNumber* noticeId = dic[NoticeId_Key];
        if (noticeId != nil && [noticeId isKindOfClass:[NSNumber class]] && [noticeId integerValue] > 0) {
            if ([self needShowNotice:[noticeId integerValue] inViewPage:viewPageId]) {
                [mArray addObject:dic];
            }
        }
    }
    
    return mArray;
}

- (NSDictionary*)findNoticeFromId:(NSInteger)noticeId
{
    if ([self.noticeInfoArray count] <= 0) {
        return nil;
    }
    
    NSPredicate* thePredicate = [NSPredicate predicateWithFormat:@"SELF.%@ == %d", NoticeId_Key, noticeId];
    NSArray* resultArray = [self.noticeInfoArray filteredArrayUsingPredicate:thePredicate];
    
    if ([resultArray count] > 0) {
        return resultArray[0];
    }
    return nil;
}

- (NSArray<NSDictionary*>*)fetchNoticeInfoForView:(NSUInteger)viewPageId withNoticeTypeFilter:(ENoticeType)noticeType
{
    if ([self.noticeInfoArray count] <= 0) {
        return nil;
    }
    
    NSPredicate* thePredicate = [NSPredicate predicateWithFormat:@"SELF.%@ == %d AND SELF.%@ == %d", ViewPageId_Key, viewPageId, NoticeType_Key, noticeType];
    NSArray* resultArray = [self.noticeInfoArray filteredArrayUsingPredicate:thePredicate];
    
    return resultArray;
}

- (void)notice:(NSInteger)noticeId showOnceTimeInViewPage:(NSInteger)viewPageId
{
    NSString* buildVersion = [DYTools appBuildNumber];
    [self.userDefaults setObject:buildVersion forKey:[NSString stringWithFormat:@"%ld-%ld", (long)noticeId, (long)viewPageId]];
    [self.userDefaults synchronize];
}

- (BOOL)needShowNotice:(NSInteger)noticeId inViewPage:(NSInteger)viewPageId
{
    NSDictionary* dic = [self findNoticeFromId:noticeId];
    NSNumber* noticeType = dic[NoticeType_Key];
    if (noticeType != nil && [noticeType isKindOfClass:[NSNumber class]] && [noticeType integerValue] == eNoticeTypeShowAllTime) {
        return YES;
    }
    
    NSString* buildVersionNow = [DYTools appBuildNumber];
    NSString* buildVersionInConfig = [self.userDefaults objectForKey:[NSString stringWithFormat:@"%ld-%ld", (long)noticeId, (long)viewPageId]];
    if (buildVersionInConfig == nil) {
        return YES;
    }
    
    if ([buildVersionInConfig compare:buildVersionNow] == NSOrderedAscending) {
        return YES;
    }
    
    return NO;
}

@end
