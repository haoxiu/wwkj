//
//  UIButton+SL.m
//  Sushi
//
//  Created by toocmstoocms on 15/5/8.
//  Copyright (c) 2015年 Seven. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "UIButton+Extension.h"

@implementation UIButton (Extension)
- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}
- (NSString *)title
{
    return nil;
}
- (void)setImage:(NSString *)image
{
    [self setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}
- (NSString *)image
{
    return nil;
}
-(void)addTarget:(id)target action:(SEL)action {
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
- (void)setTitleColor:(UIColor *)titleColor
{
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}
- (UIColor *)titleColor
{
    return nil;
}
- (NSString *)highlightImage
{
    return nil;
}
- (void)setHighlightImage:(NSString *)highlightImage
{
    [self setImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
}
- (NSString *)selectImage
{
    return nil;
}
- (void)setSelectImage:(NSString *)selectImage
{
    [self setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
}
@end
