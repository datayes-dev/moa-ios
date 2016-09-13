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
//  DYJsonRequestWithGBufResponseRequest.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/10/20.
//

#import "DYJsonRequestWithGBufResponseRequest.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

#define TIMEOUT_VALUE       30.0f                               // 超时时长

@implementation DYJsonRequestWithGBufResponseRequest

- (void)setupRequestOperationManager
{
    self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] init];
    self.requestOperationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.requestOperationManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [self.requestOperationManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.requestOperationManager.requestSerializer.timeoutInterval = TIMEOUT_VALUE;
    [self.requestOperationManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    self.requestOperationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [self.requestOperationManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/x-protobuf", nil]];
    [self.requestOperationManager.requestSerializer setValue:@"application/x-protobuf" forHTTPHeaderField:@"Accept"];
}

@end
