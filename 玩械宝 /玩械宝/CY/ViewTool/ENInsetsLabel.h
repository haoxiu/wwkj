//
//  ENInsetsLabel.h
//  WeiGuan
//
//  Created by zhao jun on 14-1-23.
//  Copyright (c) 2014年 zhao jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ENInsetsLabel : UILabel
@property(nonatomic) UIEdgeInsets insets;

- (id)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets) insets;
- (id)initWithInsets:(UIEdgeInsets) insets;
@end
