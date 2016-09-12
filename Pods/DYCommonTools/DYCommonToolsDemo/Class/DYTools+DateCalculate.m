//
//  DYTools+DateCalculate.m
//  DYCommonToolsDemo
//
//  Created by liangkai.zheng on 16/8/5.
//  Copyright © 2016年 鄢彭超. All rights reserved.
//

#import "DYTools+DateCalculate.h"

#define kMonthInOneYearNum 12

static NSDateFormatter *dateFormatter = nil;


@implementation DYTools (DateCalculate)
+ (NSString *)simpleCalBeginWithEndDate:(NSString *)date number:(NSInteger)number DateFrequency:(EDateFrequencyType)type
{
    
    if ([date length] < 8 || number < 0) {
        
        return nil;
    }
    
    if (number == 0) {
        return date;
    }
    
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
    }
    
    date = [date stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSDate *nowDate = [dateFormatter dateFromString:date];
    NSString *formatDate = [dateFormatter stringFromDate:nowDate];
    
    NSString *yearStr = [formatDate substringToIndex:4];
    NSInteger yearNum = [yearStr integerValue];
    
    NSString *monthStr = [formatDate substringWithRange:NSMakeRange(4, 2)];
    NSInteger monthNum = [monthStr integerValue];
    
    switch (type) {
            
        case eDateFrequencyYear:{
            
            yearNum -= number;
        }
            break;
            
        case eDateFrequencyMonth:{
            
            if (number > 12) {
                
                monthNum -= number%kMonthInOneYearNum;
                yearNum = yearNum - number/kMonthInOneYearNum;
                
            } else if(number == 12) {
                
                yearNum--;
                
            } else {
                
                monthNum -= number;
            }
            
            
            if (monthNum <= 0) {
                
                monthNum += kMonthInOneYearNum;
                yearNum--;
            }
        }
            break;
            
        default:
            return nil;
            break;
    }
    
    formatDate = [DYTools converDateToYYYYMMDD:yearNum AndMonth:monthNum AndDay:1];
    
    return [DYTools converDate:formatDate];
}

+ (NSString *)calBeginWithEndDate:(NSString *)date number:(NSInteger)number DateFrequency:(EDateFrequencyType)type
{
    
    if ([date length] < 8 || number < 0) {
        
        return nil;
    }
    
    if (number == 0) {
        return date;
    }
    
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
    }
    
    date = [date stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSDate *nowDate = [dateFormatter dateFromString:date];
    NSString *formatDate = [dateFormatter stringFromDate:nowDate];
    
    NSString *yearStr = [formatDate substringToIndex:4];
    NSInteger yearNum = [yearStr integerValue];
    
    NSString *monthStr = [formatDate substringWithRange:NSMakeRange(4, 2)];
    NSInteger monthNum = [monthStr integerValue];
    
    NSString *dayStr = [formatDate substringWithRange:NSMakeRange(6, 2)];
    NSInteger dayNum = [dayStr integerValue];
    
    switch (type) {
            
        case eDateFrequencyYear:{
            
            yearNum -= number;
        }
            break;
            
        case eDateFrequencyMonth:{
            
            if (number > 12) {
                
                monthNum -= number%kMonthInOneYearNum;
                yearNum = yearNum - number/kMonthInOneYearNum;
                
            } else if(number == 12) {
                
                yearNum--;
                
            } else {
                
                monthNum -= number;
            }
            
            
            if (monthNum <= 0) {
                
                monthNum += kMonthInOneYearNum;
                yearNum--;
            }
        }
            break;
            
        default:
            return nil;
            break;
    }
    
    dayNum++;
    
    formatDate = [DYTools converDateToYYYYMMDD:yearNum AndMonth:monthNum AndDay:dayNum];
    
    return [DYTools converDate:formatDate];
}

+ (NSString *)converDateToYYYYMMDD:(NSInteger)yearNum AndMonth:(NSInteger)monthNum AndDay:(NSInteger)dayNum
{
    
    NSString *formatDate = [NSString stringWithFormat:@"%ld%ld%ld",(long)yearNum,(long)monthNum,(long)dayNum];
    
    if (monthNum < 10 && monthNum > 0) {
        
        NSMutableString *string = [formatDate mutableCopy];
        [string insertString:@"0" atIndex:4];
        formatDate = [string copy];
    }
    
    if (dayNum < 10 && dayNum > 0) {
        
        NSMutableString *string = [formatDate mutableCopy];
        [string insertString:@"0" atIndex:6];
        formatDate = [string copy];
    }
    
    return formatDate;
}

+ (NSString *)converDate:(NSString *)date
{
    
    if ([date length] <= 0) {
        
        return date;
    }
    
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
    }
    
    date = [date stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *yearStr = [date substringToIndex:4];
    NSInteger yearNum = [yearStr integerValue];
    
    NSString *monthStr = [date substringWithRange:NSMakeRange(4, 2)];
    NSInteger monthNum = [monthStr integerValue];
    
    NSString *dayStr = [date substringWithRange:NSMakeRange(6, 2)];
    NSInteger dayNum = [dayStr integerValue];
    
    NSInteger monthDayNum = 30;
    
    switch ([DYTools checkMonthType:monthNum]) {
        case eMonthTypeSpecialMonth:{
            
            if ([DYTools checkIfLeapYear:yearNum]) {
                
                monthDayNum = 29;
                
            } else {
                
                monthDayNum = 28;
            }
        }
            break;
            
        case eMonthTypeBigMonth:
            
            monthDayNum = 31;
            break;
            
        default:
            break;
    }
    
    if (dayNum > monthDayNum) {
        monthNum++;
        dayNum = 1;
        
        if (monthNum > kMonthInOneYearNum) {
            monthNum -= kMonthInOneYearNum;
            yearNum++;
        }
    }
    
    date = [DYTools converDateToYYYYMMDD:yearNum AndMonth:monthNum AndDay:dayNum];
    
    return date;
}

#pragma mark - 闰年
+ (BOOL)checkIfLeapYear:(NSInteger)yearNum
{
    
    
    if (yearNum % 100 == 0) {
        
        if (yearNum % 400 == 0) {
            //能被400整除的是闰年
            return YES;
        }
        
    } else {
        
        if (yearNum % 4 == 0) {
            //非整百年：年数除以4余数为0是闰年
            return YES;
        }
    }
    
    return NO;
}


#pragma mark - 月份分类
+ (EMonthType)checkMonthType:(NSInteger)month
{
    
    if ([DYTools specialMonth:month]) {
        
        return eMonthTypeSpecialMonth;
        
    } else if ([DYTools smallMonth:month]){
        
        return eMonthTypeSmallMonth;
        
    } else {
        
        return eMonthTypeBigMonth;
    }
}

+ (BOOL)bigMonth:(NSInteger)month
{
    static NSArray *bigMonth;
    if (bigMonth == nil) {
        bigMonth = [[NSArray alloc] initWithObjects:@(1),@(3),@(5),@(7),@(8),@(10),@(12),nil];
    }
    
    for (NSNumber *num in bigMonth) {
        
        if ([num integerValue] == month) {
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL)smallMonth:(NSInteger)month
{
    static NSArray *smallMonth;
    if (smallMonth == nil) {
        smallMonth = [[NSArray alloc] initWithObjects:@(4),@(6),@(9),@(11),nil];
    }
    
    for (NSNumber *num in smallMonth) {
        
        if ([num integerValue] == month) {
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL)specialMonth:(NSInteger)month
{
    static NSArray *specialMonth;
    if (specialMonth == nil) {
        specialMonth = [[NSArray alloc] initWithObjects:@(2),nil];
    }
    
    if (month == 2) {
        
        return YES;
        
    } else {
        
        return NO;
    }
}

@end
