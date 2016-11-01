//
//  DingTradeInfoItem.m
//  moa
//
//  Created by liangkai.zheng on 16/11/1.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "DingTradeInfoItem.h"

@implementation DingTradeInfoItem

- (instancetype)initWithInfoId:(NSString *)infoId
                          memo:(NSString *)memo
                         price:(double)price
                    restaurant:(NSString *)restaurant
               restaurant_name:(NSString *)restaurant_name
                    time_stamp:(NSString *)time_stamp
                          user:(NSString *)user
{
    
    if (self = [super init]) {
        
        self.infoId = infoId;
        self.memo = memo;
        self.price = price;
        self.restaurant = restaurant;
        self.restaurant_name = restaurant_name;
        self.time_stamp = time_stamp;
        self.user = user;
    }
    
    return self;
}

@end
