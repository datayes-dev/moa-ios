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

@interface MOATradeInfoAdapter : DYDataSourceBase

+ (instancetype)shareInstance;

- (void)getAllHotelsInfo:(DYInterfaceResultBlock)resultBlock;

- (void)getHotelInfoWith:(NSString *)hotelQRCode withBlock:(DYInterfaceResultBlock)resultBlock;

- (void)makeDealWithPrice:(NSString *)price
                  inHotel:(NSString*)pkId
              andMemoInfo:(NSString*)memoInfo
           andResultBlock:(DYInterfaceResultBlock)resultBlock;
@end
