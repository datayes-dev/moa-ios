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


#pragma mark - 新接口

//获取交易流水
- (void)getTradeListInfoWithBeginDate:(NSString *)beginDate
                              endDate:(NSString *)endDate
                                admin:(NSString *)admin
                          ResultBlock:(DYInterfaceResultBlock)resultBlock
{
    
    if ([beginDate length] == 0 || [endDate length] == 0) {
        
        NSError *error = [[NSError alloc] init];
        resultBlock(nil,error);
        return;
    }
    
    NSDictionary *dic = @{@"begin":NilToEmptyString(beginDate),
                          @"end":NilToEmptyString(endDate),
                          @"admin":NilToEmptyString(admin)};
    
    [self sendRequestWithMsgId:eGetTradeList
                    parameters:dic
                 canUsingCache:NO
                   forceReload:NO
                   resultBlock:^(id data, NSError *error) {
                       
                       if (error) {
                           
                           resultBlock(nil,error);
                           return;
                       }
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           resultBlock(data,error);
                       });
                   }];
}


//执行交易
- (void)addTransWithRestaurant:(NSString *)restaurant
                      QRString:(NSString *)qrStr
                   ResultBlock:(DYInterfaceResultBlock)resultBlock
{
    
    if ([restaurant length] == 0 || [qrStr length] ==0) {
        
        resultBlock(nil,[[NSError alloc] init]);
        return;
    }
    
    [self sendRequestWithMsgId:eDiningTradeRequest
                    parameters:@{@"restaurant":NilToEmptyString(restaurant),
                                 @"qrstring":NilToEmptyString(qrStr),
                                 @"memo":@""}
                 canUsingCache:NO
                   forceReload:NO
                   resultBlock:^(id data, NSError *error) {
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           
                           resultBlock(data,error);
                       });
                   }];
}


//获取个人付款二维码
- (void)getUserPayQRWithResultBlock:(DYInterfaceResultBlock)resultBlock
{
    [self sendRequestWithMsgId:eGetUserPayQR
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
