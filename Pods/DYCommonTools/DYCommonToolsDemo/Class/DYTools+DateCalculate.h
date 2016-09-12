//
//  DYTools+DateCalculate.h
//  DYCommonToolsDemo
//
//  Created by liangkai.zheng on 16/8/5.
//  Copyright © 2016年 鄢彭超. All rights reserved.
//

#import "DYTools.h"
typedef NS_ENUM(NSInteger, EDateFrequencyType) {
    
    eDateFrequencyYear = 0,
    eDateFrequencyMonth,
};

typedef NS_ENUM(NSInteger, EMonthType) {
    
    eMonthTypeBigMonth = 0,
    eMonthTypeSmallMonth,
    eMonthTypeSpecialMonth
};

@interface DYTools (DateCalculate)

+ (NSString *)calBeginWithEndDate:(NSString *)date number:(NSInteger)number DateFrequency:(EDateFrequencyType)type;

+ (NSString *)simpleCalBeginWithEndDate:(NSString *)date number:(NSInteger)number DateFrequency:(EDateFrequencyType)type;

+ (BOOL)checkIfLeapYear:(NSInteger)yearNum;

+ (EMonthType)checkMonthType:(NSInteger)month;

@end
