//
//  DYJsonRequestWithTextHtmlResponseRequest.m
//  IntelligenceResearchReport
//
//  Created by 鄢彭超 on 16/9/2.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "DYJsonRequestWithTextHtmlResponseRequest.h"
#import "AFHTTPRequestOperationManager.h"

#define TIMEOUT_VALUE       30.0f                               // 超时时长

@implementation DYJsonRequestWithTextHtmlResponseRequest

- (void)setupRequestOperationManager
{
    self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] init];
    self.requestOperationManager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [self.requestOperationManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [self.requestOperationManager.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Accept"];
    
//    [self.requestOperationManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    self.requestOperationManager.requestSerializer.timeoutInterval = TIMEOUT_VALUE;
//    [self.requestOperationManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    self.requestOperationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [self.requestOperationManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
}

@end
