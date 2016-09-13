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
//  DYCacheManager.m
//  IntelligenceResearchReport
//
//  Created by liangkai.zheng on 16/8/9.
//

#import "DYCacheManager.h"
#import "DYInterfacePropertiesManager.h"
#import "DYInterfaceInfo.h"
#import "DYAppConfigManager.h"


static DYCacheManager* _DYCacheManager = nil;
static NSArray* _cacheArray = nil;
static NSArray* _sepcifyCacheArray = nil;
static NSArray* _reuseURLArray = nil;

@interface DYCacheManager()

@end

@implementation DYCacheManager

#pragma mark - Init
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _DYCacheManager = [[DYCacheManager alloc] init];
    });
    
    return _DYCacheManager;
}

#pragma mark - Property Init
//- (NSArray *)cacheArray
//{
//    
//    if (_cacheArray == nil) {
//
//        _cacheArray = @[
//                        [DYInterfacePropertiesManager shareInstance].infoSubUrl,
//                        [DYInterfacePropertiesManager shareInstance].announcementSubUrl,
//                        [DYInterfacePropertiesManager shareInstance].researchSubUrl,
//                        @"achilles.wmcloud.com",
//                        @"achilles.wmcloud-stg.com",
//                        @"app.wmcloud.com/ira/js",
//                        @"app.wmcloud-stg.com/ira/js",
//                        @"app.wmcloud.com/ira/css",
//                        @"app.wmcloud.com-stg/ira/css",
//                        @"gw.wmcloud.com/rrp/mobile/whitelist/info/",
//                        @"gw.wmcloud-stg.com/rrp/mobile/whitelist/info/",
//                        @"app.wmcloud.com/ira/img",
//                        @"wpimg.wallstcn.com"
//                        ] ;
//    }
//    return _cacheArray;
//}
//
//- (NSArray *)reuseURLArray
//{
//    
//    //该文件可以复用
//    if (_reuseURLArray == nil) {
//        _reuseURLArray = @[@"https://app.wmcloud.com/ira/information/news/",
//                           @"https://app.wmcloud.com/ira/information/announcement/",
//                           @"https://app.wmcloud.com/ira/information/research/",
//                           @"https://app.wmcloud-stg.com/ira/information/news/",
//                           @"https://app.wmcloud-stg.com/ira/information/announcement/",
//                           @"https://app.wmcloud-stg.com/ira/information/research/"];
//    }
//    return _reuseURLArray;
//}

#pragma mark - Public
+ (BOOL)checkIfNeedCache:(NSString *)urlStr
{
    
    if (_cacheArray == nil) {
        
        _cacheArray = @[
                        [DYInterfacePropertiesManager shareInstance].infoSubUrl,
                        [DYInterfacePropertiesManager shareInstance].announcementSubUrl,
                        [DYInterfacePropertiesManager shareInstance].researchSubUrl,
                        @"achilles.wmcloud.com",
                        @"achilles.wmcloud-stg.com",
                        @"bigdata-s3.wmcloud.com",
                        @"app.wmcloud.com/ira/js",
                        @"app.wmcloud-stg.com/ira/js",
                        @"app.wmcloud.com/ira/css",
                        @"app.wmcloud.com-stg/ira/css",
                        @"gw.wmcloud.com/rrp/mobile/whitelist/info/",
                        @"gw.wmcloud-stg.com/rrp/mobile/whitelist/info/",
                        @"app.wmcloud.com/ira/img",
                        @"wpimg.wallstcn.com"
                        ] ;
    }
    
    if (_sepcifyCacheArray == nil) {
        
        _sepcifyCacheArray = @[[DYInterfacePropertiesManager interfaceInfoWithInterfaceId:eGetBasicInfoForDataset].subUrl];
    }

    //common URL
    for (NSString *url in _cacheArray) {
        
        if ([urlStr containsString:url]) {
            return YES;
        }
    }
    
    //指定sub URL，sub URL有包含关系，例如/whitelist/data,/whitelist/data/relativeStock,因此需要精确判断
    for (NSString *url in _sepcifyCacheArray) {
        
        if ([urlStr containsString:url]) {
            
            NSArray *array = [urlStr componentsSeparatedByString:url];
            
            if ([array count] == 2) {
                NSString *parma = [array lastObject];
                NSString *firstLetter = [parma substringToIndex:1];
                if ([firstLetter isEqualToString:@"?"]) {
                    return YES;
                }
                
            } else if ([array count] == 1){
                return YES;
            }
        }
    }
    
    return NO;
}

+ (NSString *)checkIfCanGetReuseFilename:(NSString *)urlStr
{
    
    if (_reuseURLArray == nil) {
        _reuseURLArray = @[@"https://app.wmcloud.com/ira/information/news/",
                           @"https://app.wmcloud.com/ira/information/announcement/",
                           @"https://app.wmcloud.com/ira/information/research/",
                           @"https://app.wmcloud-stg.com/ira/information/news/",
                           @"https://app.wmcloud-stg.com/ira/information/announcement/",
                           @"https://app.wmcloud-stg.com/ira/information/research/"];
    }
    
    NSString *proURL = @"https://app.wmcloud.com/ira/information/reuseFilename";
    NSString *stgURL = @"https://app.wmcloud-stg.com/ira/information/reuseFilename";
    
    for (NSString *url in _reuseURLArray) {
        
        if ([urlStr containsString:url]) {
            
            NSString *subUrl = [urlStr stringByReplacingOccurrencesOfString:url withString:@""];
            
            NSNumber *currentEvn = [DYAppConfigManager shareInstance].currentEnvironment;
            ECurrentEnvType currentEnvType = [currentEvn integerValue];
            
            //公告、新闻、研报的该URL虽然链接不同，但其实内容相同，是可以复用的，因此在同一环境下存成统一文件
            switch (currentEnvType) {
                case eCurrentEnvTypeDev:
                    return [subUrl containsString:@"/"] ? nil : stgURL;
                    break;
                    
                case eCurrentEnvTypeQA:
                    return [subUrl containsString:@"/"] ? nil : stgURL;
                    break;
                    
                case eCurrentEnvTypeStag:
                    return [subUrl containsString:@"/"] ? nil : stgURL;
                    break;
                    
                case eCurrentEnvTypeProduct:
                    return [subUrl containsString:@"/"] ? nil : proURL;
                    break;
                    
                default:
                    break;
            }
        }
    }
    return nil;
}

+ (void)sendRequestURL:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    
    //添加http header的必选项
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    NSNumber *currentEvn = [DYAppConfigManager shareInstance].currentEnvironment;
    ECurrentEnvType currentEnvType = [currentEvn integerValue];
    
    NSString *proURL = @"https://app.wmcloud.com";
    NSString *stgURL = @"https://app.wmcloud-stg.com";
    
    switch (currentEnvType) {
        case eCurrentEnvTypeDev:
            [request addValue:stgURL forHTTPHeaderField:@"Origin"];
            break;
            
        case eCurrentEnvTypeQA:
            [request addValue:stgURL forHTTPHeaderField:@"Origin"];
            break;
            
        case eCurrentEnvTypeStag:
            [request addValue:stgURL forHTTPHeaderField:@"Origin"];
            break;
            
        case eCurrentEnvTypeProduct:
            [request addValue:proURL forHTTPHeaderField:@"Origin"];
            break;
            
        default:
            break;
    }

    //以下是一次webview真实访问，截取到的http header，其中accept、Origin是必选项
//    Accept = "application/json";
//    Origin = "https://app.wmcloud.com";
//    Referer = "https://app.wmcloud.com/ira/information/news/24407737";
//    "User-Agent" = "Mozilla/5.0 (iPhone; CPU iPhone OS 8_1_3 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12B466";
    
    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            
//            DDLogInfo(@"sendRequestURL:%@",dict);
        }
    }];
    
    [dataTask resume];
}

+ (void)sendRequestURLArray:(NSArray<NSString *> *)urlStrArray
{
    
    if ([urlStrArray count] <= 0) {
        
        return;
    }
    
    for (NSString *url in urlStrArray) {
        
        [DYCacheManager sendRequestURL:url];
    }
}
@end
