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

@property (nonatomic, strong) DYCellDataItem *lastTradeItem;

@end

@implementation MOATradeInfoAdapter

- (NSMutableArray *)cellDataArray
{
    
    if (_cellDataArray == nil) {
        
        _cellDataArray = [NSMutableArray array];
    }
    return _cellDataArray;
}

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
    
    self.lastTradeItem = nil;
    
    [self.datasource diningTradeWithPrice:[price floatValue] inHotel:pkId andMemoInfo:memoInfo andResultBlock:^(id data, NSError *error) {
        
        if (error) {
            
            resultBlock(nil, error);
            return;
        }
        
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
        
        self.cellDataArray = [NSMutableArray array];
        
        if (error == nil && data != nil && [data isKindOfClass:[NSData class]]) {
            
            NSArray* tradeListInfoArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            for (NSDictionary* dic in tradeListInfoArray) {
                
                NSString* time_stamp = dic[@"time_stamp"];
                NSNumber* price = dic[@"price"];
                NSString* hotelName = dic[@"restaurant_name"];
                
                DYCellDataItem* item = [DYCellDataItem new];
                item.hotelName = hotelName;
                item.timeStamp = time_stamp;
                item.price = [NSString stringWithFormat:@"%@",price];
                
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

- (void)saveLastTradeInfo:(DYCellDataItem *)item
{
    
    self.lastTradeItem = item;
}

- (DYCellDataItem *)getLastTradeInfo
{
    
    return self.lastTradeItem;
}

#pragma mark - 新接口

- (void)getTradeListInfoWithBeginDate:(NSString *)beginDate
                              endDate:(NSString *)endDate
                                admin:(NSString *)admin
                          ResultBlock:(DYInterfaceResultBlock)resultBlock
{
    
    [self.datasource getTradeListInfoWithBeginDate:beginDate
                                           endDate:endDate
                                             admin:admin
                                       ResultBlock:^(id data, NSError *error) {
                                           
                                           if (error) {
                                               
                                               resultBlock(nil, [[NSError alloc] init]);
                                               return ;
                                           }
                                           
                                           NSArray *dataArr = (NSArray *)data;
                                           
                                           NSMutableArray *muteArr = [NSMutableArray array];
                                           
                                           for (NSDictionary* dic in dataArr) {
                                               
                                               NSString* infoId = dic[@"id"];
                                               NSNumber* price = dic[@"price"];
                                               NSString* memo = dic[@"memo"];
                                               NSString* restaurant = dic[@"restaurant"];
                                               NSString* restaurant_name = dic[@"restaurant_name"];
                                               NSString* time_stamp = dic[@"time_stamp"];
                                               NSString* user = dic[@"user"];
                                               
                                               DingTradeInfoItem* item = [[DingTradeInfoItem alloc] initWithInfoId:infoId memo:memo price:[price doubleValue] restaurant:restaurant restaurant_name:restaurant_name time_stamp:time_stamp user:user];
                                               
                                               [muteArr insertObject:item atIndex:0];
                                           }

                                           
                                           resultBlock(muteArr,nil);
                                       }];
}

- (void)getUserPayQRWithResultBlock:(DYInterfaceResultBlock)resultBlock
{
    
    [self.datasource getUserPayQRWithResultBlock:^(id data, NSError *error) {
        //
    }];
}

- (void)addTransWithRestaurant:(NSString *)restaurant
                      QRString:(NSString *)qrStr
                   ResultBlock:(DYInterfaceResultBlock)resultBlock{
    
    [self.datasource addTransWithRestaurant:@"866f0bd8-a002-11e6-8f4c-0242c0a80003RES_"
                                   QRString:qrStr
                                ResultBlock:^(id data, NSError *error) {
                                    //
                                }];
}


@end
