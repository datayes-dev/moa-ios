//
//  MOATradeInfoAdapter.h
//  moa
//
//  Created by liangkai.zheng on 16/9/14.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYDataSourceBase.h"
#import "DYCellDataItem.h"
#import "DingTradeInfoItem.h"

@interface MOATradeInfoAdapter : DYDataSourceBase

+ (instancetype)shareInstance;

- (void)getAllHotelsInfo:(DYInterfaceResultBlock)resultBlock;

- (void)getHotelInfoWith:(NSString *)hotelQRCode withBlock:(DYInterfaceResultBlock)resultBlock;

- (void)makeDealWithPrice:(NSString *)price
                  inHotel:(NSString*)pkId
              andMemoInfo:(NSString*)memoInfo
           andResultBlock:(DYInterfaceResultBlock)resultBlock;

- (void)getTradeListInfoWithResultBlock:(DYInterfaceResultBlock)resultBlock;

- (void)saveLastTradeInfo:(DYCellDataItem *)item;

- (DYCellDataItem *)getLastTradeInfo;

#pragma mark - 新接口

- (void)getTradeListInfoWithBeginDate:(NSString *)beginDate
                              endDate:(NSString *)endDate
                                admin:(NSString *)admin
                          ResultBlock:(DYInterfaceResultBlock)resultBlock;

- (void)getUserPayQRWithResultBlock:(DYInterfaceResultBlock)resultBlock;

- (void)addTransWithRestaurant:(NSString *)restaurant
                      QRString:(NSString *)qrStr
                   ResultBlock:(DYInterfaceResultBlock)resultBlock;
@end
