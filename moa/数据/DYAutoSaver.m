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
//  DYAutoSaver.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/8/25.
//

#import "DYAutoSaver.h"
#import "DYDataSourceBase.h"

static DYAutoSaver* gAutoSaver = nil;

@interface DYAutoSaver ()

@property (nonatomic, strong) NSMutableArray *itemsNeedToSave;

@end

@implementation DYAutoSaver

- (id)init
{
    self = [super init];
    if (self) {
        self.itemsNeedToSave = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminNotify:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gAutoSaver = [[DYAutoSaver alloc] init];
    });
    
    return gAutoSaver;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)INeedAutoSave:(DYDataSourceBase*)saveMeItem
{
    if (saveMeItem != nil) {
        @synchronized (_itemsNeedToSave) {
            [_itemsNeedToSave addObject:saveMeItem];
        }
    }
}

-(void)IDontNeedAutoSave:(DYDataSourceBase*)notSaveMeIte
{
    if (notSaveMeIte != nil) {
        @synchronized (_itemsNeedToSave) {
            [_itemsNeedToSave removeObject:notSaveMeIte];
        }
    }
}

#pragma mark -
#pragma mark saveOnExit

- (void)appWillTerminNotify:(NSNotification *)notification
{
    @synchronized (_itemsNeedToSave) {
        for (DYDataSourceBase* item in _itemsNeedToSave) {
            if ([item respondsToSelector:@selector(saveIntoFile)]) {
                [item saveIntoFile];
            }
        }
    }
}

- (void)appDidReceiveMemoryWarning:(NSNotification *)notification
{
    @synchronized (_itemsNeedToSave) {
        for (DYDataSourceBase* item in _itemsNeedToSave) {
            if ([item respondsToSelector:@selector(saveIntoFile)]) {
                [item saveIntoFile];
            }
        }
    }
}

@end
