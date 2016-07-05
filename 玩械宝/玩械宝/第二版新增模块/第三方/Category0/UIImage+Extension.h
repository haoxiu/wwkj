//
//  UIImage+Extension.h
//
//
//  Created by apple on 14-4-2.
//  Copyright (c) 2014年 Seven Lv All rights reserved.
//  UIImage分类

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  拉伸图片:(传入一张图片,返回一张可随意拉伸的图片)
 *
 *  @param name 图片名
 */
+ (UIImage *)resizableImage:(NSString *)name;
/**
 *  为图片加相框
 */
+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
/**
 *  截图
 *
 *  @param view 需要截图的View
 */
+ (instancetype)captureWithView:(UIView *)view;

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;
@end