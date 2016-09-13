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
//  DYNetStatusManager.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/10/23.
//

#import "DYNetStatusManager.h"
#import "DYProgressHUD.h"
#import "DYCacheService.h"
#import "PromptView.h"

static DYNetStatusManager* gNetStatusManager = nil;

@implementation DYNetStatusManager

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gNetStatusManager = [[DYNetStatusManager alloc] init];
    });
    
    return gNetStatusManager;
}

- (BOOL)isNetWorkAvaliable
{
    return !self.isStatusValid || self.netWorkStatus == AFNetworkReachabilityStatusReachableViaWWAN || self.netWorkStatus == AFNetworkReachabilityStatusReachableViaWiFi;
}

- (BOOL)netWorkIsWifi
{
    return self.netWorkStatus == AFNetworkReachabilityStatusReachableViaWiFi;
}

- (void)startMonitorNetWork
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    __weak __typeof(self)weakSelf = self;
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        weakSelf.netWorkStatus = status;
        weakSelf.isStatusValid = YES;
//        [DYProgressHUD hideWaiting];
        if (status == AFNetworkReachabilityStatusNotReachable || status ==AFNetworkReachabilityStatusUnknown) {
            [DYProgressHUD hideWaiting];
            NSNumber *showNoNetWorkFlag = loadFromCacheWithType(CK_ShowNoNetWorkFlag, JMDataTypeEnumObject);
            if(![showNoNetWorkFlag boolValue]){//3秒内不会再提示
                [PromptView showWithPrompt:@"网络暂时无法访问"];
                saveToCacheWithType(CK_ShowNoNetWorkFlag, @YES, JMDataTypeEnumObject);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 3.0f* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    saveToCacheWithType(CK_ShowNoNetWorkFlag, @NO, JMDataTypeEnumObject);
                });
            }
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_ENABLE_NOTIFY object:nil];
            [DYProgressHUD hideWaiting];
        }
    }];
}

@end
