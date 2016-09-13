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
//  DYDataSourceBase.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/8/19.
//

#import "PromptView.h"
#import "DYErrorHelper.h"
#import "DYDataSourceError.h"
#import "DYDataSourceErrorView.h"
#import "DYInterfaceInfo.h"
#import "DYInterfacePropertiesManager.h"

@implementation DYDataSourceBase

#pragma mark - 正则表达式
/* 字符串正则表达式判断 */
+ (BOOL)isString:(NSString*)string meetRegex:(NSString *)tempRegex
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:tempRegex options:0 error:nil];
    if (regex)
    {
        NSTextCheckingResult *result = [regex firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
        if (result)
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)saveIntoFile
{
    // 子类如果有内容需要保存，需要实现这个方法
}

- (void)sendRequestWithMsgId:(EInterfaceId)msgId
                  parameters:(id)params
               canUsingCache:(BOOL)usingCacheFlag
                 forceReload:(BOOL)reloadFlag
                 resultBlock:(DYInterfaceResultBlock)resultBlock
{
    if([[DYDataSourceError shareInstance] isDisuseState]){//是否已经是运维模式状态
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [[DYDataSourceError shareInstance] addRequestIntoDisuseQueueWithMsgId:msgId parameters:params canUsingCache:usingCacheFlag forceReload:reloadFlag resultBlock:resultBlock]; //把请求加到待刷新列表
        
        WS(weakSelf);
        [[DYDataSourceErrorView shareInstance]showMyDatasourceErrorViewWithBlock:^(int num) {
            [[DYDataSourceError shareInstance] resumeAllDisuseRequstWithTarget:weakSelf];
        }];
        
    }
    else{
        WS(weakSelf);
        
        [[DYInterfaceRequestHelper shareInstance] sendRequestWithMsgId:msgId parameters:params canUsingCache:usingCacheFlag forceReload:reloadFlag resultBlock:^(id data, NSError *error) {
            
            NSDictionary *dic;
            if ([data isKindOfClass:[NSDictionary class]]) {
                dic=(NSDictionary *)data;
                int errorCode=[[dic objectForKey:@"code"] intValue];
                
                if (disuseState == errorCode ) {//运维模式-9990
                    [[NSURLCache sharedURLCache] removeAllCachedResponses];
                    DDLogInfo(@"进入运维模式");
                    [DYDataSourceError shareInstance].errorState = disuseState;//设置为运维模式
                    [[DYDataSourceError shareInstance] addRequestIntoDisuseQueueWithMsgId:msgId parameters:params canUsingCache:usingCacheFlag forceReload:reloadFlag resultBlock:resultBlock];//把请求加到待刷新列表
                    [[DYDataSourceErrorView shareInstance]showMyDatasourceErrorViewWithBlock:^(int num) {
                        [[DYDataSourceError shareInstance] resumeAllDisuseRequstWithTarget:weakSelf];
                    }];//显示界面模式（已/未显示）
                }
                else{
                    [DYDataSourceError shareInstance].errorState = normalState;//关闭运维模式
                    
                    DYInterfaceInfo* interfaceInfo = [DYInterfacePropertiesManager interfaceInfoWithInterfaceId:msgId];
                    if (interfaceInfo.responseBodyTiedType == eResponseBodyTiedTypeGBuf) {
                        //
                    }
                    else
                    {
                        resultBlock(data,error);
                    }
                }
            }
            else{
                resultBlock(data,error);
            }
        }];
    }
//    [[DYInterfaceRequestHelper shareInstance] sendRequestWithMsgId:msgId parameters:params canUsingCache:usingCacheFlag forceReload:reloadFlag resultBlock:resultBlock];
}
@end
