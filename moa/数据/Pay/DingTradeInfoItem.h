//
//  DingTradeInfoItem.h
//  moa
//
//  Created by liangkai.zheng on 16/11/1.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DingTradeInfoItem : NSObject

@property (nonatomic, strong) NSString *infoId;
@property (nonatomic, strong) NSString *memo;
@property (assign) double price;
@property (nonatomic, strong) NSString *restaurant;
@property (nonatomic, strong) NSString *restaurant_name;
@property (nonatomic, strong) NSString *time_stamp;
@property (nonatomic, strong) NSString *user;

- (instancetype)initWithInfoId:(NSString *)infoId
                          memo:(NSString *)memo
                         price:(double)price
                    restaurant:(NSString *)restaurant
               restaurant_name:(NSString *)restaurant_name
                    time_stamp:(NSString *)time_stamp
                          user:(NSString *)user;
@end
