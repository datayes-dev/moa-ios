//
//  DYAppearance.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/8/20.
//  Copyright (c) 2015年 datayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//标准颜色
#define DYAppearanceColor(key,alpha)   [[DYAppearance shareInstance] DYAppearanceColorWithKey:key AndAlpha:alpha]
//标准字体
#define DYAppearanceFont(key)          [[DYAppearance shareInstance] DYAppearanceFontWithKey:key IsBold:NO]
//标准加粗字体
#define DYAppearanceBoldFont(key)      [[DYAppearance shareInstance] DYAppearanceFontWithKey:key IsBold:YES]

@interface DYAppearance : NSObject{
}
@property (nonatomic,strong)NSDictionary *appearanceDic;


//----------------新方法--------------
//单例
+ (instancetype)shareInstance;
//返回key所指的颜色
- (UIColor *)DYAppearanceColorWithKey:(NSString *)key AndAlpha:(CGFloat)alpha;
//返回key所指的Font
- (UIFont *)DYAppearanceFontWithKey:(NSString *)key IsBold:(BOOL)bold;
//返回uicolor
+ (UIColor *)colorWithRGB:(NSInteger)rgb andAlpha:(CGFloat)alpha;
//-------------------------------------









//UINavigationBar颜色
//蓝
+ (UIColor *)dyBarBlue;
//灰（enable=no）
+ (UIColor *)dyBarGery;
//股票红
+ (UIColor *)dyRed;
//股票绿
+ (UIColor *)dygreen;
//白色
+ (UIColor *)dyWhite;
//软件背景
+ (UIColor *)dybackGroundBlack;
//默认背景颜色
+ (UIColor *)defaultBackGroundColor;
//
+ (UIColor *)dyHighlightColor;

+ (UIColor *)dyButtonNotEnable;
+ (UIColor *)dyButtonNormal;

//标题中背景黑色
+ (UIColor *)dyTitleViewDarkGray;

//字体
+ (UIColor *)dyTextBlack;
+ (UIColor *)dyTextGray;
+ (UIColor *)dyTextWhite;
+ (UIColor *)dyTextUnSelectedColor;
//停盘的文字颜色
+(UIColor *)dyTextStopMark;
/**
 * @author zhizhong.zhou
 *
 * 根据颜色值
 *
 * @param rgb 十六进制
 *
 * @return 颜色
 */
+ (UIColor *)colorWithRGB:(NSInteger)rgb;
+ (UIColor *)colorWithRGBA:(NSInteger)rgba;

@end

//////颜色适配标准化

@interface DYAppearance (ColorStandard)

//通联红1号
+ (UIColor *)dyR1Color;

//通联白1号
+ (UIColor *)dyW1Color;

//通联绿1号-2号
+ (UIColor *)dyG1Color;
+ (UIColor *)dyG2Color;

//通联黄1号-2号
+ (UIColor *)dyY1Color;
+ (UIColor *)dyY2Color;
+ (UIColor *)dyY3Color;

// 通联紫1号
+ (UIColor *)dyP1Color;

//通联蓝1号--5号
+ (UIColor *)dyB1Color;
+ (UIColor *)dyB2Color;
+ (UIColor *)dyB3Color;
+ (UIColor *)dyB4Color;
+ (UIColor *)dyB5Color;
+ (UIColor *)dyB6Color;
+ (UIColor *)dyB7Color;
+ (UIColor *)dyB8Color;
+ (UIColor *)dyB9Color;
+ (UIColor *)dyB10Color;
+ (UIColor *)dyB11Color;
+ (UIColor *)dyB12Color;

//通联灰1号--9号
+ (UIColor *)dyH1Color;
+ (UIColor *)dyH2Color;
+ (UIColor *)dyH3Color;
+ (UIColor *)dyH4Color;
+ (UIColor *)dyH5Color;
+ (UIColor *)dyH6Color;
+ (UIColor *)dyH7Color;
+ (UIColor *)dyH8Color;
+ (UIColor *)dyH9Color;
+ (UIColor *)dyH10Color;
+ (UIColor *)dyH11Color;
+ (UIColor *)dyH12Color;

// 允许设置透明度
//通联红1号
+ (UIColor *)dyR1ColorWithAlpha:(CGFloat)alpha;

//通联白1号
+ (UIColor *)dyW1ColorWithAlpha:(CGFloat)alpha;

//通联绿1号-2号
+ (UIColor *)dyG1ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyG2ColorWithAlpha:(CGFloat)alpha;

//通联黄1号-2号
+ (UIColor *)dyY1ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyY2ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyY3ColorWithAlpha:(CGFloat)alpha;

// 通联紫1号
+ (UIColor *)dyP1ColorWithAlpha:(CGFloat)alpha;

//通联蓝1号--5号
+ (UIColor *)dyB1ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyB2ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyB3ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyB4ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyB5ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyB6ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyB7ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyB8ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyB9ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyB10ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyB11ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyB12ColorWithAlpha:(CGFloat)alpha;

//通联灰1号--9号
+ (UIColor *)dyH1ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyH2ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyH3ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyH4ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyH5ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyH6ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyH7ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyH8ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyH9ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyH10ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyH11ColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dyH12ColorWithAlpha:(CGFloat)alpha;

@end


//////字体适配标准化
@interface DYAppearance (FontStandard)

//通联字体1号--11号
+ (UIFont *)dyT0Font;
+ (UIFont *)dyT1Font;
+ (UIFont *)dyT2Font;
+ (UIFont *)dyT3Font;
+ (UIFont *)dyT4Font;
+ (UIFont *)dyT5Font;
+ (UIFont *)dyT6Font;
+ (UIFont *)dyT7Font;
+ (UIFont *)dyT8Font;
+ (UIFont *)dyT9Font;
+ (UIFont *)dyT10Font;
+ (UIFont *)dyT11Font;
+ (UIFont *)dyT12Font;
+ (UIFont *)dyT13Font;
+ (UIFont *)dyT14Font;
+ (UIFont *)dyT15Font;
+ (UIFont *)dyT16Font;

+ (UIFont *)dyBoldT0Font;
+ (UIFont *)dyBoldT1Font;
+ (UIFont *)dyBoldT2Font;
+ (UIFont *)dyBoldT3Font;
+ (UIFont *)dyBoldT4Font;
+ (UIFont *)dyBoldT5Font;
+ (UIFont *)dyBoldT6Font;
+ (UIFont *)dyBoldT7Font;
+ (UIFont *)dyBoldT8Font;
+ (UIFont *)dyBoldT9Font;
+ (UIFont *)dyBoldT10Font;
+ (UIFont *)dyBoldT11Font;
+ (UIFont *)dyBoldT12Font;
+ (UIFont *)dyBoldT13Font;
+ (UIFont *)dyBoldT14Font;
+ (UIFont *)dyBoldT15Font;
+ (UIFont *)dyBoldT16Font;
@end

