//
//  HeadView.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/26.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//
typedef void(^Block)(NSInteger index);
#import <UIKit/UIKit.h>

@interface HeadView : UIView
@property(nonatomic,copy)Block block;
- (void)setBlock:(Block)block;
@end
