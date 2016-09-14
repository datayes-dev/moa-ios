//
//  MOATradeInfoAdapter.m
//  moa
//
//  Created by liangkai.zheng on 16/9/14.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "MOATradeInfoAdapter.h"
#import "MOAPayDataSourceBase.h"

static MOATradeInfoAdapter *gMOATradeInfoAdapter = nil;

@interface MOATradeInfoAdapter()

@property (nonatomic, strong) MOAPayDataSourceBase *datasource;

/**
 *	@brief	存放cell的信息的数组（可变数组）
 */
@property (nonatomic, strong)NSMutableArray* cellDataArray;

/**
 *	@brief	存放饭店列表的数组
 */
@property (nonatomic, strong)NSArray* hotelsArray;

@end

@implementation MOATradeInfoAdapter

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gMOATradeInfoAdapter = [[MOATradeInfoAdapter alloc] init];
    });
    
    return gMOATradeInfoAdapter;
}

#pragma mark - Property Init
- (MOAPayDataSourceBase *)datasource
{
    
    if (_datasource == nil) {
        
        _datasource = [MOAPayDataSourceBase shareInstance];
    }
    return _datasource;
}

#pragma mark - Network
- (void)getAllHotelsInfo:(DYInterfaceResultBlock)resultBlock
{
//    if ([self.hotelsArray count] > 0) {
//        
//        resultBlock(self.hotelsArray, nil);
//        return;
//    }
    WS(weakSelf);
    
    self.hotelsArray = nil;
    
    [self.datasource getAllHotelsWithResultBlock:^(id data, NSError *error) {
        
        if (error == nil && data != nil && [data isKindOfClass:[NSData class]]) {
            
            NSArray* hotelInfoArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (hotelInfoArray != nil && [hotelInfoArray isKindOfClass:[NSArray class]]) {
                
                weakSelf.hotelsArray = hotelInfoArray;
            }
        } else {
            
        }
        
        resultBlock(weakSelf.hotelsArray, error);
    }];
}

- (void)makeDealWithPrice:(NSString *)price
                  inHotel:(NSString*)pkId
              andMemoInfo:(NSString*)memoInfo
           andResultBlock:(DYInterfaceResultBlock)resultBlock
{
    
    [self.datasource diningTradeWithPrice:[price floatValue] inHotel:pkId andMemoInfo:memoInfo andResultBlock:^(id data, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            resultBlock(data,error);
        });
    }];

}

- (void)getHotelInfoWith:(NSString *)hotelQRCode withBlock:(DYInterfaceResultBlock)resultBlock
{
    
    WS(weakSelf);
        
    [self getAllHotelsInfo:^(id data, NSError *error) {
        
        resultBlock([weakSelf getHotelInfo:hotelQRCode], nil);
    }];
}

- (void)getTradeListInfoWithResultBlock:(DYInterfaceResultBlock)resultBlock
{
    
    [self.datasource getTradeListInfoWithResultBlock:^(id data, NSError *error) {
        
        if (error == nil && data != nil && [data isKindOfClass:[NSData class]]) {
            
            NSArray* tradeListInfoArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            for (NSDictionary* dic in tradeListInfoArray) {
                
                NSString* hotelId = dic[@"restaurant"];
                NSDictionary* hotelDicInfo = [self getHotelInfo:hotelId];
                NSString* hotelName = hotelDicInfo[@"name"];
                
                DYCellDataItem* item = [DYCellDataItem new];
                item.titleText = hotelName;
                item.detailText = [NSString stringWithFormat:@"于%@成功收到%@", dic[@"time_stamp"], dic[@"price"]];
                
                [self.cellDataArray insertObject:item atIndex:0];
            }
        }

        
        dispatch_async(dispatch_get_main_queue(), ^{
            resultBlock(self.cellDataArray,error);
        });
    }];
}

#pragma mark - Get Info
- (NSDictionary *)getHotelInfo:(NSString *)hotelQRCode
{
    
    for (NSDictionary* dic in self.hotelsArray) {
        
        if ([dic[@"id"] isEqualToString:hotelQRCode]) {
            return dic;
        }
    }
    return nil;
}
@end
