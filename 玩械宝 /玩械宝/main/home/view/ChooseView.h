//
//  ChooseView.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/11.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//
typedef void(^selected)(NSInteger row);
#import <UIKit/UIKit.h>

@interface ChooseView : UICollectionView<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property(nonatomic,copy)selected block;
@property(nonatomic,strong)NSArray *titles;
- (void)setBlock:(selected)block;

@end
