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
//  DYInterfacePropertiesManager.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/10/22.
//

#import "DYInterfacePropertiesManager.h"

static DYInterfacePropertiesManager* gInterfacePropertiesManager = nil;

@implementation DYInterfacePropertiesManager

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gInterfacePropertiesManager = [DYInterfacePropertiesManager objectWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"interfaceUri" ofType:@"plist"]];
    });
    
    return gInterfacePropertiesManager;
    
}

+ (DYInterfaceInfo*)interfaceInfoWithInterfaceId:(EInterfaceId)msgId
{
    if (gInterfacePropertiesManager == nil) {
        DDLogError(@"未完成初始化，请先调用（initWithContentsOfFile:）方法完成初始化");
        return nil;
    }
    
    NSInteger moduleIndex = msgId/100;
    NSInteger interfaceIndex = msgId%100;
    
    if ([gInterfacePropertiesManager.interfaceModules count] > moduleIndex)
    {
        DYAppModuleItem* item = gInterfacePropertiesManager.interfaceModules[moduleIndex];
        if ([item.interfaces count] > interfaceIndex) {
            return item.interfaces[interfaceIndex];
        }
    }
    
    DDLogError(@"未从配置文件中找到msgId为：%ld的接口配置信息，请检查interfaceUri.plist文件", (long)msgId);
    
    return nil;
}

@end
