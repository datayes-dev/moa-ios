//
//  MOAPayDataSourceBase.m
//  moa
//
//  Created by liangkai.zheng on 16/9/13.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "MOAPayDataSourceBase.h"
#import "DYInterfaceIdDef.h"
#import "DYDefine.h"

#define kExtraAddedSubUrlKey @"extraAddedSubUrl"

static MOAPayDataSourceBase* gMOAPayDataSourceBase = nil;

@implementation MOAPayDataSourceBase

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gMOAPayDataSourceBase = [[MOAPayDataSourceBase alloc] init];
    });
    
    return gMOAPayDataSourceBase;
}

- (void)getAllHotelsWithResultBlock:(DYInterfaceResultBlock)resultBlock
{
    [self sendRequestWithMsgId:eDiningGetAllHotelsInfo
                    parameters:nil
                 canUsingCache:NO
                   forceReload:NO
                   resultBlock:^(id data, NSError *error) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           resultBlock(data,error);
                       });
                   }];
}

- (void)getHotelsWithID:(NSString *)hotelID andResultBlock:(DYInterfaceResultBlock)resultBlock
{
    
    if ([hotelID length] <= 0) {
        
        return;
    }
    
    
    [self sendRequestWithMsgId:eDiningGetAllHotelsInfo
                    parameters:@{kExtraAddedSubUrlKey:hotelID}
                 canUsingCache:NO
                   forceReload:NO
                   resultBlock:^(id data, NSError *error) {
                       
                       NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

                       dispatch_async(dispatch_get_main_queue(), ^{
                           resultBlock(json,error);
                       });
                   }];
}

- (void)getHotelQRCodeWithId:(NSString*)pkId andResultBlock:(DYInterfaceResultBlock)resultBlock
{
    
    if ([pkId length] == 0) {
        
        return;
    }
    
    [self sendRequestWithMsgId:eDiningGetQRCodeWithPK
                    parameters:@{kExtraAddedSubUrlKey:pkId}
                 canUsingCache:NO
                   forceReload:NO
                   resultBlock:^(id data, NSError *error) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           resultBlock(data,error);
                       });
                   }];
}

- (void)diningTradeWithPrice:(float)price inHotel:(NSString*)pkId andMemoInfo:(NSString*)memoInfo andResultBlock:(DYInterfaceResultBlock)resultBlock
{
    
    [self sendRequestWithMsgId:eDiningTradeRequest
                    parameters:@{@"restaurant":NilToEmptyString(pkId), @"price":@(price), @"memo":NilToEmptyString(memoInfo)}
                 canUsingCache:NO
                   forceReload:NO
                   resultBlock:^(id data, NSError *error) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           resultBlock(data,error);
                       });
                   }];
}

- (void)getTradeListInfoWithResultBlock:(DYInterfaceResultBlock)resultBlock
{
    [self sendRequestWithMsgId:eDiningGetTradeList
                    parameters:nil
                 canUsingCache:NO
                   forceReload:NO
                   resultBlock:^(id data, NSError *error) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           resultBlock(data,error);
                       });
                   }];
}

@end
