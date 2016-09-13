//
//  NSString+URL.m
//  moa
//
//  Created by 鄢彭超 on 16/9/13.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "NSString+URL.h"
#import <Foundation/NSURL.h>

@implementation NSString (URL)

- (NSString*)urlEncodeString
{
//    NSString *encodedString = (NSString *)
//    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                              (CFStringRef)self,
//                                                              NULL,
//                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
//                                                              kCFStringEncodingUTF8));
//    
//    return encodedString;
    NSCharacterSet *set = [NSCharacterSet URLHostAllowedCharacterSet];
    return [self stringByAddingPercentEncodingWithAllowedCharacters:set];
}

- (NSString *)urlDecodedString
{
    return [self stringByRemovingPercentEncoding];
//    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8));
}

@end
