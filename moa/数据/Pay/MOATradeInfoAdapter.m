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
    
    [self.datasource getAllHotelsWithResultBlock:^(id data, NSError *error) {
        
        if (error == nil && data != nil && [data isKindOfClass:[NSData class]]) {
            
            NSArray* hotelInfoArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (hotelInfoArray != nil && [hotelInfoArray isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary* dic in hotelInfoArray) {
                    DYCellDataItem* item = [DYCellDataItem new];
                    item.titleText = dic[@"name"];
                    item.detailText = dic[@"address"];
                    
                    [self.cellDataArray insertObject:item atIndex:0];
                }
                
                DYCellDataItem* item = [DYCellDataItem new];
                item.titleText = @"成功获取到以下餐馆";
                item.detailText = @"--->下一步请扫餐馆的二维码";
                [self.cellDataArray insertObject:item atIndex:0];
                
                self.hotelsArray = hotelInfoArray;
            }
        } else {
            
            DYCellDataItem* item = [DYCellDataItem new];
            item.titleText = @"获取餐馆列表失败，请稍候再试";
            item.detailText = @"--->左上角按钮退出该页面再进来";
            [self.cellDataArray insertObject:item atIndex:0];
        }
        
        resultBlock(self.hotelsArray, error);
    }];
}

- (void)

- (void)getHotelInfoWith:(NSString *)hotelQRCode withBlock:(DYInterfaceResultBlock)resultBlock
{
    
    WS(weakSelf);
        
    [self getAllHotelsInfo:^(id data, NSError *error) {
        
        resultBlock([weakSelf getHotelInfo:hotelQRCode], nil);
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
