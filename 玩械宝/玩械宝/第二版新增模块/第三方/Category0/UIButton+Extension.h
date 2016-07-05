//
//  UIButton+SL.h
//  Sushi
//
//  Created by toocmstoocms on 15/5/8.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)
/** 文字*/
@property (nonatomic, copy) NSString * title;
/** 图片*/
@property (nonatomic, copy) NSString * image;
/** 高亮图片*/
@property (nonatomic, copy) NSString * highlightImage;
/** 选中*/
@property (nonatomic, copy) NSString * selectImage;
/** 文字颜色*/
@property (nonatomic, strong) UIColor * titleColor;

/**
 *  添加监听
 */
- (void)addTarget:(id)target action:(SEL)action;
@end
