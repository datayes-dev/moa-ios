//
//  PromptView.m
//  HowbuyFund
//
//  Created by tiannu on 14-6-3.
//  Copyright (c) 2014年 howbuy.com. All rights reserved.
//

#import "PromptView.h"
#import "DYAppearance.h"

#define Prompt_View_Tag 1999

#define Prompt_String_Font 18.0
#define Prompt_String_Max_W 280.0

@implementation PromptView

+ (void)showOnView:(UIView *)superview withPrompt:(NSString *)promt
{
    [[[self alloc] init] showPromptView:superview detailStr:promt];
}

+ (void)showWithPrompt:(NSString *)promt
{
    [self showWithPrompt:promt complection:nil];
}

+ (void)showWithPrompt:(NSString *)promt
           complection:(void (^)(void))block
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    if ([window viewWithTag:Prompt_View_Tag] != nil) {
        return;
    }
    // Magic...
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[[self alloc] init] showPromptView:window detailStr:promt complection:block];
    });
}

- (id)init
{
    self = [super init];
    if (self) {
        self.tag = Prompt_View_Tag;
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/* 展示提示 */
- (void)showPromptView:(UIView *)superView
             detailStr:(NSString *)tempDetailStr
{
    [self showPromptView:superView detailStr:tempDetailStr complection:nil];
}

- (void)showPromptView:(UIView *)superView
             detailStr:(NSString *)tempDetailStr
           complection:(void (^)(void))block
{
    if (tempDetailStr == nil || [tempDetailStr isEqualToString:@""])
    {
        return;
    }
    
    for (UIView *tempV in superView.subviews)
    {
        if (tempV.tag == Prompt_View_Tag)
        {
            [tempV removeFromSuperview];
        }
    }
    
    [superView addSubview:self];

    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:Prompt_String_Font]};
    CGSize size = [tempDetailStr sizeWithAttributes:attributes];
    float temp_W = size.width;//[tempDetailStr sizeWithFont:[UIFont systemFontOfSize:Prompt_String_Font]].width;
    float temp_H = size.height;//[tempDetailStr sizeWithFont:[UIFont systemFontOfSize:Prompt_String_Font]].height;
    if (temp_W > Prompt_String_Max_W - 80.0)
    {
        temp_W = Prompt_String_Max_W - 80.0;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:Prompt_String_Font]};
        temp_H = [tempDetailStr boundingRectWithSize:CGSizeMake(temp_W, 999.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;//[tempDetailStr sizeWithFont:[UIFont systemFontOfSize:Prompt_String_Font] constrainedToSize:CGSizeMake(temp_W, 999.0) lineBreakMode:NSLineBreakByCharWrapping].height;
    }
    self.frame = CGRectMake((superView.bounds.size.width - (temp_W + 80.0)) / 2, (superView.bounds.size.height - (temp_H + 40.0)) / 2, temp_W + 80.0, temp_H + 40.0);
    
    UIView *blackView = [[UIView alloc] initWithFrame:self.bounds];
    blackView.backgroundColor = [DYAppearance colorWithRGB:0x000000];
    blackView.alpha = 0.6;
    blackView.layer.cornerRadius = 9.0;
    [self addSubview:blackView];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, temp_W + 2, temp_H)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:Prompt_String_Font];
    label.text = tempDetailStr;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.center = blackView.center;
    [self addSubview:label];

    self.alpha = 0.2;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5
                              delay:Prompt_Delay_Time - 0.5
                            options:0
                         animations:^{
                             self.alpha = 0;
                         } completion:^(BOOL finished) {
                             [self removeAll];
                             if (block) {
                                 block();
                             }
                         }];
    }];
}

- (void)removeAll
{
    for (UIView *tempV in self.subviews)
    {
        [tempV removeFromSuperview];
    }
    
    [self removeFromSuperview];
}

@end
