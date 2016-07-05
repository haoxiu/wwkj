//
//  HomeViewController.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/11.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeViewController : BaseViewController<UIScrollViewDelegate>

@property(nonatomic,strong)NSArray *titles;
- (void)merhod;
@end
