//
//  DYAppearance.m
//  IntelligenceResearchReport
//
//  Created by datayes on 15/8/20.
//  Copyright (c) 2015年 datayes. All rights reserved.
//

#import "DYAppearance.h"

static DYAppearance* dyAppearance = nil;

@implementation DYAppearance


//---------------新方法------------------

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dyAppearance = [[DYAppearance alloc] init];
        
        NSString *dyAppearanceBundlePath;
        dyAppearanceBundlePath = [[NSBundle mainBundle] pathForResource:@"DYAppearance" ofType:@"bundle"];
        if(!dyAppearanceBundlePath){//在pod中是取不到上面路径的
            dyAppearanceBundlePath =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Frameworks/DYAppearance.framework/DYAppearance.bundle"];
        }
        
        NSString *plistPath = [[NSBundle bundleWithPath:dyAppearanceBundlePath] pathForResource:@"DYAppearance" ofType:@"plist"];
        dyAppearance.appearanceDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    });
    return dyAppearance;
}

- (UIColor *)DYAppearanceColorWithKey:(NSString *)key AndAlpha:(CGFloat)alpha{
    NSDictionary *color=self.appearanceDic[@"Color"];
    NSString *str=color[key];
    unsigned long rgb = strtoul([str UTF8String],0,16);
    UIColor *dycolor=[DYAppearance colorWithRGB:rgb andAlpha:alpha];
    return dycolor;
}

- (UIFont *)DYAppearanceFontWithKey:(NSString *)key IsBold:(BOOL)bold{
    NSDictionary *font=self.appearanceDic[@"Font"];
    NSString *str=font[key];
    CGFloat size=[str floatValue];
    if(bold){
        return [UIFont boldSystemFontOfSize:size];
    }
    else{
        return [UIFont systemFontOfSize:size];
    }
}


+ (UIColor *)colorWithRGB:(NSInteger)rgb andAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0
                           green:((float)((rgb & 0xFF00) >> 8))/255.0
                            blue:((float)(rgb & 0xFF))/255.0
                           alpha:alpha];
}

//---------------------------------












+ (UIColor *)dyBarBlue
{
    return [self colorWithRGB:0x3d77c7];
}

+ (UIColor *)dyBarGery
{
    return [self colorWithRGB:0xaaaaaa];
}


+ (UIColor *)dyRed
{
    return [self colorWithRGB:0xe6514a];
}

+ (UIColor *)dygreen
{
    return [self colorWithRGB:0x07cc89];
}

+ (UIColor *)dyWhite
{
    return  [UIColor whiteColor];
}

+ (UIColor *)dybackGroundBlack
{
    return [self colorWithRGB:0x233040];
}




+ (UIColor *)defaultBackGroundColor
{
    return [self colorWithRGB:0xf4f5f9];
}



+ (UIColor *)dyHighlightColor
{
    return [self colorWithRGB:0x3598DC];
}

+ (UIColor *)dyTitleViewDarkGray
{
    return [self colorWithRGB:0x2D3E50];
}

+ (UIColor *)dyButtonNotEnable
{
    return [self colorWithRGB:0xbdbdbd];
}

+ (UIColor *)dyButtonNormal
{
    return [self colorWithRGB:0x7c7c7e];
}


//text
+ (UIColor *)dyTextBlack
{
    return [self colorWithRGB:0x404040];
}

+ (UIColor *)dyTextGray
{
    return [self colorWithRGB:0xa5a5a5];
}

+ (UIColor *)dyTextWhite
{
    return [self colorWithRGB:0xffffff];
}
+ (UIColor *)dyTextUnSelectedColor
{
    return [self colorWithRGB:0x99a2a1];
}
//停盘的颜色
+(UIColor *)dyTextStopMark
{
    return [self colorWithRGB:0x7d848d];
}

+ (UIColor *)colorWithRGB:(NSInteger)rgb
{
    return [self colorWithRGB:rgb andAlpha:1.0];
}

+ (UIColor *)colorWithRGBA:(NSInteger)rgba
{
    return [UIColor colorWithRed:((float)((rgba & 0xFF000000) >> 24))/255.0
                           green:((float)((rgba & 0xFF0000) >> 16))/255.0
                            blue:((float)((rgba & 0xFF00) >> 8))/255.0 alpha:((float)(rgba & 0xFF))/255.0];
}
@end

@implementation DYAppearance (ColorStandard)


//通联红1号
+ (UIColor *)dyR1Color
{
    return [self colorWithRGB:0xe6514a];
}
//通联白
+ (UIColor *)dyW1Color
{
    return [self colorWithRGB:0xffffff];
}

//通联蓝1号--5号
+ (UIColor *)dyB1Color
{
    return [self colorWithRGB:0x3d77c7];
}
+ (UIColor *)dyB2Color
{
    return [self colorWithRGB:0xe1f0fa];
}
+ (UIColor *)dyB3Color
{
    return [self colorWithRGB:0x233040];
}
+ (UIColor *)dyB4Color
{
    return [self colorWithRGB:0x2d3e50];
    
}
+ (UIColor *)dyB5Color
{
    return [self colorWithRGB:0x546a79];
    
}
+ (UIColor *)dyB6Color
{
    return [self colorWithRGB:0xf3f7fc];
    
}
+ (UIColor *)dyB7Color
{
    return [self colorWithRGB:0xcddef4];
    
}
+ (UIColor *)dyB8Color
{
    return [self colorWithRGB:0x5389d2];
    
}
+ (UIColor *)dyB9Color
{
    return [self colorWithRGB:0x99c9ff];
    
}
+ (UIColor *)dyB10Color
{
    return [self colorWithRGB:0x5a9bd1];
    
}
+ (UIColor *)dyB11Color
{
    return [self colorWithRGB:0x82b0eb];
    
}
+ (UIColor *)dyB12Color
{
    return [self colorWithRGB:0xd8e4f4];
    
}

//通联绿1号-2号
+ (UIColor *)dyG1Color
{
    return [self colorWithRGB:0x0bb908];
}
+ (UIColor *)dyG2Color
{
    return [self colorWithRGB:0x34ba95];
}

//通联黄1号-2号
+ (UIColor *)dyY1Color
{
    return [self colorWithRGB:0xfff5d5];
    
}
+ (UIColor *)dyY2Color
{
    return [self colorWithRGB:0x65541d];
}
+ (UIColor *)dyY3Color
{
    return [self colorWithRGB:0xf9d10e];
}

// 通联紫1号
+ (UIColor *)dyP1Color
{
    return [self colorWithRGB:0xdd60bc];
}

//通联灰1号--9号
+ (UIColor *)dyH1Color
{
    return [self colorWithRGB:0xf4f5f9];
}
+ (UIColor *)dyH2Color
{
    return [self colorWithRGB:0xe5e5e5];
}
+ (UIColor *)dyH3Color
{
    return [self colorWithRGB:0xc7c7c7];
}
+ (UIColor *)dyH4Color
{
    return [self colorWithRGB:0xbdbdbd];
}
+ (UIColor *)dyH5Color
{
    return [self colorWithRGB:0xa5a5a5];
}
+ (UIColor *)dyH6Color
{
    return [self colorWithRGB:0x99a2a1];
}
+ (UIColor *)dyH7Color
{
    return [self colorWithRGB:0x7e7e7e];
}
+ (UIColor *)dyH8Color
{
    return [self colorWithRGB:0x676767];
}
+ (UIColor *)dyH9Color
{
    return [self colorWithRGB:0x404040];
}
+ (UIColor *)dyH10Color
{
    return [self colorWithRGB:0x7d848d];
}
+ (UIColor *)dyH11Color
{
    return [self colorWithRGB:0x9f9f9f];
}
+ (UIColor *)dyH12Color
{
    return [self colorWithRGB:0xf3f3f3];
}

#pragma mark - 允许设置透明度

//通联红1号
+ (UIColor *)dyR1ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0xe6514a andAlpha:alpha];
}
//通联白
+ (UIColor *)dyW1ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0xffffff andAlpha:alpha];
}

//通联蓝1号--5号
+ (UIColor *)dyB1ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0x3d77c7 andAlpha:alpha];
}
+ (UIColor *)dyB2ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0xe1f0fa andAlpha:alpha];
}
+ (UIColor *)dyB3ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0x233040 andAlpha:alpha];
}
+ (UIColor *)dyB4ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0x2d3e50 andAlpha:alpha];
}
+ (UIColor *)dyB5ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0x546a79 andAlpha:alpha];
}
+ (UIColor *)dyB6ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0xf3f7fc andAlpha:alpha];
}
+ (UIColor *)dyB7ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0xcddef4 andAlpha:alpha];
}
+ (UIColor *)dyB8ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0x5389d2 andAlpha:alpha];
}
+ (UIColor *)dyB9ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0x99c9ff andAlpha:alpha];
}
+ (UIColor *)dyB10ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0x5a9bd1 andAlpha:alpha];
}
+ (UIColor *)dyB11ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0x82b0eb andAlpha:alpha];
}
+ (UIColor *)dyB12ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0xd8e4f4 andAlpha:alpha];
}

//通联绿1号-2号
+ (UIColor *)dyG1ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0x0bb908 andAlpha:alpha];
}
+ (UIColor *)dyG2ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0x34ba95 andAlpha:alpha];
}

//通联黄1号-2号
+ (UIColor *)dyY1ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0xfff5d5 andAlpha:alpha];
    
}
+ (UIColor *)dyY2ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0x65541d andAlpha:alpha];
}
+ (UIColor *)dyY3ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0xf9d10e andAlpha:alpha];
}

// 通联紫1号
+ (UIColor *)dyP1ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0xdd60bc andAlpha:alpha];
}

//通联灰1号--9号
+ (UIColor *)dyH1ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0xf4f5f9 andAlpha:alpha];
}
+ (UIColor *)dyH2ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0xe5e5e5 andAlpha:alpha];
}
+ (UIColor *)dyH3ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0xc7c7c7 andAlpha:alpha];
}
+ (UIColor *)dyH4ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0xbdbdbd andAlpha:alpha];
}
+ (UIColor *)dyH5ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0xa5a5a5 andAlpha:alpha];
}
+ (UIColor *)dyH6ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0x99a2a1 andAlpha:alpha];
}
+ (UIColor *)dyH7ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0x7e7e7e andAlpha:alpha];
}
+ (UIColor *)dyH8ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0x676767 andAlpha:alpha];
}
+ (UIColor *)dyH9ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0x404040 andAlpha:alpha];
}
+ (UIColor *)dyH10ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0x7d848d andAlpha:alpha];
}
+ (UIColor *)dyH11ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0x9f9f9f andAlpha:alpha];
}
+ (UIColor *)dyH12ColorWithAlpha:(CGFloat)alpha
{
    return [self colorWithRGB:0xf3f3f3 andAlpha:alpha];
}
@end



//////字体适配标准化
@implementation DYAppearance (FontStandard)

+ (UIFont *)dyT0Font
{
    return [UIFont systemFontOfSize:11];
}
+ (UIFont *)dyT1Font
{
    return [UIFont systemFontOfSize:12];
}
+ (UIFont *)dyT2Font
{
    return [UIFont systemFontOfSize:13];
}
+ (UIFont *)dyT3Font
{
    return [UIFont systemFontOfSize:14];
}
+ (UIFont *)dyT4Font
{
    return [UIFont systemFontOfSize:15];
}
+ (UIFont *)dyT5Font
{
    return [UIFont systemFontOfSize:16];
}
+ (UIFont *)dyT6Font
{
    return [UIFont systemFontOfSize:17];
}
+ (UIFont *)dyT7Font
{
    return [UIFont systemFontOfSize:18];
}
+ (UIFont *)dyT8Font
{
    return [UIFont systemFontOfSize:19];
}
+ (UIFont *)dyT9Font
{
    return [UIFont systemFontOfSize:20];
}
+ (UIFont *)dyT10Font
{
    return [UIFont systemFontOfSize:21];
}
+ (UIFont *)dyT11Font
{
    return [UIFont systemFontOfSize:22];
}
+ (UIFont *)dyT12Font
{
    return [UIFont systemFontOfSize:45];
}
+ (UIFont *)dyT13Font
{
    return [UIFont systemFontOfSize:9];
}
+ (UIFont *)dyT14Font
{
    return [UIFont systemFontOfSize:8];
}
+ (UIFont *)dyT15Font
{
    return [UIFont systemFontOfSize:10];
}
+ (UIFont *)dyT16Font
{
    return [UIFont systemFontOfSize:35];
}
+ (UIFont *)dyBoldT0Font
{
    return [UIFont boldSystemFontOfSize:11];
}
+ (UIFont *)dyBoldT1Font
{
    return [UIFont boldSystemFontOfSize:12];
}
+ (UIFont *)dyBoldT2Font
{
    return [UIFont boldSystemFontOfSize:13];
}
+ (UIFont *)dyBoldT3Font
{
    return [UIFont boldSystemFontOfSize:14];
}
+ (UIFont *)dyBoldT4Font
{
    return [UIFont boldSystemFontOfSize:15];
}
+ (UIFont *)dyBoldT5Font
{
    return [UIFont boldSystemFontOfSize:16];
}
+ (UIFont *)dyBoldT6Font
{
    return [UIFont boldSystemFontOfSize:17];
}
+ (UIFont *)dyBoldT7Font
{
    return [UIFont boldSystemFontOfSize:18];
}
+ (UIFont *)dyBoldT8Font
{
    return [UIFont boldSystemFontOfSize:19];
}
+ (UIFont *)dyBoldT9Font
{
    return [UIFont boldSystemFontOfSize:20];
}
+ (UIFont *)dyBoldT10Font
{
    return [UIFont boldSystemFontOfSize:21];
}
+ (UIFont *)dyBoldT11Font
{
    return [UIFont boldSystemFontOfSize:22];
}
+ (UIFont *)dyBoldT12Font
{
    return [UIFont boldSystemFontOfSize:45];
}
+ (UIFont *)dyBoldT13Font
{
    return [UIFont boldSystemFontOfSize:9];
}
+ (UIFont *)dyBoldT14Font
{
    return [UIFont boldSystemFontOfSize:8];
}
+ (UIFont *)dyBoldT15Font
{
    return [UIFont boldSystemFontOfSize:10];
}
+ (UIFont *)dyBoldT16Font
{
    return [UIFont boldSystemFontOfSize:35];
}

@end




