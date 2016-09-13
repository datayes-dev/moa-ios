/** 
 * 通联数据机密
 * --------------------------------------------------------------------
 * 通联数据股份公司版权所有 © 2013-2016
 * 
 * 注意：本文所载所有信息均属于通联数据股份公司资产。本文所包含的知识和技术概念均属于
 * 通联数据产权，并可能由中国、美国和其他国家专利或申请中的专利所覆盖，并受商业秘密或
 * 版权法保护。
 * 除非事先获得通联数据股份公司书面许可，严禁传播文中信息或复制本材料。
 * 
 * DataYes CONFIDENTIAL
 * --------------------------------------------------------------------
 * Copyright © 2013-2016 DataYes, All Rights Reserved.
 * 
 * NOTICE: All information contained herein is the property of DataYes 
 * Incorporated. The intellectual and technical concepts contained herein are 
 * proprietary to DataYes Incorporated, and may be covered by China, U.S. and 
 * Other Countries Patents, patents in process, and are protected by trade 
 * secret or copyright law. 
 * Dissemination of this information or reproduction of this material is 
 * strictly forbidden unless prior written permission is obtained from DataYes.
 */
//
//  UIImage+Creation.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/8/19.
//

#import "UIImage+Creation.h"

@implementation UIImage (Creation)


+ (UIImage *)pureimageWithColor:(UIColor *)color
{
    return  [[self pureImageWithSize:CGSizeMake(2, 2) color:color]resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
}


+ (UIImage *)pureImageWithSize:(CGSize)size
                         color:(UIColor *)color
{
  return   [self pureImageWithSize:size color:color CornerRadius:0];
}


+ (UIImage *)pureImageWithSize:(CGSize)size
                         color:(UIColor *)color
                  CornerRadius:(CGFloat)cornerRadius
{
    return [self pureImageWithSize:size color:color CornerRadius:0 borderWidth:0 borderColor:nil];
}


+ (UIImage *)pureImageWithSize:(CGSize)size
                         color:(UIColor *)color
                  CornerRadius:(CGFloat)cornerRadius
                   borderWidth:(CGFloat)borderWith
                   borderColor:(UIColor *)borderColor
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect rect = CGRectZero;
    rect.size = size;
    UIBezierPath *path;
    CGRect contentRect = rect;
    contentRect.origin.x += fabs(cornerRadius - borderWith);
    contentRect.origin.y += fabs(cornerRadius - borderWith);
    contentRect.size.width -= 2 *fabs(cornerRadius - borderWith);
    contentRect.size.height -=2*fabs(cornerRadius - borderWith);
    if (cornerRadius >0) {
        path = [UIBezierPath bezierPathWithRoundedRect:contentRect cornerRadius:cornerRadius];
    }else{
        path = [UIBezierPath bezierPathWithRect:contentRect];
    }
    [color setFill];
    [path fill];
    if (borderWith && borderColor) {
        UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:contentRect cornerRadius:cornerRadius];
        [borderColor setStroke];
        [path appendPath:borderPath];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
