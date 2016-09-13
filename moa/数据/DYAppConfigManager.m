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
//  DYAppConfigManager.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/8/25.
//

#import "DYAppConfigManager.h"
#import "SEUtilities.h"
#import "NSObject+Representation.h"
#import "SEDatabase.h"
#import "DYInterfaceRequestHelper.h"

static DYAppConfigManager* gAppConfigManager = nil;
static NSString* gFilePathName = nil;

@implementation DYAppConfigManager

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *filePath = [SEUtilities duplicateBundleFileWithName:@"appConfig.plist"
                                                          toDirectory:NSLibraryDirectory
                                                            overwrite:NO];
        gAppConfigManager = [DYAppConfigManager objectWithContentsOfFile:filePath];
        gFilePathName = filePath;
        
        
        NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
        if([@"com.datayes.irr" isEqualToString:identifier]){
            gAppConfigManager.productId=gAppConfigManager.irrProductId;
        }
        else{
        
        }
    });
    
    return gAppConfigManager;
}

- (void)saveIntoFile
{
    NSDictionary* dic = [self representation];
    [dic writeToFile:gFilePathName atomically:YES];
}

- (BOOL)checkIfNeedUpdate
{
    NSString *name = @"appConfig";
    NSString *originPath = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:originPath];
    NSNumber* newVersion = [dic objectForKey:@"version"];
    NSNumber* newDBVersion = [dic objectForKey:@"dbVersion"];

    // 有新版本
    if ([newVersion intValue] > [self.version intValue]) {
        // 这些属性使用新数据，其他的属性使用老配置文件里的数据
        self.version = newVersion;

        // 这些属性使用新库里的属性：注意新增加的值，如果有BOOL类型的，最好默认值都是NO
        self.currentEnvironment = dic[@"currentEnvironment"];       // 当前环境默认配置成线上
        
        
        // 在这里添加其他需要替换的版本号
        if ([newDBVersion intValue] > [self.dbVersion intValue]) {
            self.dbVersion = newDBVersion;
            
            // 加载旧数据
            [[SEDatabase sharedDatabase] setDbName:@"ira.db"];
        }
        else
        {
            [[SEDatabase sharedDatabase] setDbName:@"ira.db"];
        }
        
        
        [self saveIntoFile];
        
        return YES;
    }
    else
    {
        [[SEDatabase sharedDatabase] setDbName:@"ira.db"];
    }
    
    return NO;
}
@end
