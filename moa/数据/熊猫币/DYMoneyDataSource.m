//
//  DYMoneyDataSource.m
//  moa
//
//  Created by 鄢彭超 on 16/9/20.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "DYMoneyDataSource.h"
#import "DYLoginUserInfo.h"
#import "DYErrorHelper.h"

static DYMoneyDataSource* gDYMoneyDataSource = nil;
@implementation DYMoneyDataSource

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gDYMoneyDataSource = [[DYMoneyDataSource alloc] init];
    });
    
    return gDYMoneyDataSource;
}

- (void)getWalletInfoWithResultBlock:(DYInterfaceResultBlock)resultBlock
{
    NSString* principleName = [[DYLoginUserInfo shareInstance] principleName];
    if ([principleName length] <= 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            resultBlock(nil, [NSError errorWithDomain:kParameterErrorDomain code:NullParameter userInfo:nil]);
        });
    }
    
    NSDictionary* dic = @{@"kExtraAddedSubUrlKey":principleName};
    [self sendRequestWithMsgId:eGetWalletInfo
                    parameters:dic
                 canUsingCache:NO
                   forceReload:NO
                   resultBlock:^(id data, NSError *error) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           resultBlock(data,error);
                       });
                   }];
}

- (void)createNewWalletWithResultBlock:(DYInterfaceResultBlock)resultBlock
{
    NSString* principleName = [[DYLoginUserInfo shareInstance] principleName];
    if ([principleName length] <= 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            resultBlock(nil, [NSError errorWithDomain:kParameterErrorDomain code:NullParameter userInfo:nil]);
        });
    }
    
    NSDictionary* dic = @{@"kExtraAddedSubUrlKey":principleName};
    [self sendRequestWithMsgId:eCreateWallet
                    parameters:dic
                 canUsingCache:NO
                   forceReload:NO
                   resultBlock:^(id data, NSError *error) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           resultBlock(data,error);
                       });
                   }];
}

- (void)getWalletDetailInfoWithResultBlock:(DYInterfaceResultBlock)resultBlock
{
    NSString* principleName = [[DYLoginUserInfo shareInstance] principleName];
    if ([principleName length] <= 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            resultBlock(nil, [NSError errorWithDomain:kParameterErrorDomain code:NullParameter userInfo:nil]);
        });
    }
    
    NSDictionary* dic = @{@"kExtraAddedSubUrlKey":principleName};
    [self sendRequestWithMsgId:eGetWalletDetailInfo
                    parameters:dic
                 canUsingCache:NO
                   forceReload:NO
                   resultBlock:^(id data, NSError *error) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           resultBlock(data,error);
                       });
                   }];
}

- (void)getWalletPaymentsInfoWithResultBlock:(DYInterfaceResultBlock)resultBlock
{
    NSString* principleName = [[DYLoginUserInfo shareInstance] principleName];
    if ([principleName length] <= 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            resultBlock(nil, [NSError errorWithDomain:kParameterErrorDomain code:NullParameter userInfo:nil]);
        });
    }
    
    NSDictionary* dic = @{@"kExtraAddedSubUrlKey":principleName};
    [self sendRequestWithMsgId:eGetWalletPaymentsInfo
                    parameters:dic
                 canUsingCache:NO
                   forceReload:NO
                   resultBlock:^(id data, NSError *error) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           resultBlock(data,error);
                       });
                   }];
}

@end
