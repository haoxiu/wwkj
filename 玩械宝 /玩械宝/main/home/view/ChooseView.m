//
//  ChooseView.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/11.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "ChooseView.h"

@implementation ChooseView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _titles = @[@"大型挖掘机",@"小型挖掘机",@"装载机",@"推土机",@"起重机",@"混凝土设备",@"其他"];
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
        
    }
    return self;
}

#pragma mark UICollectionView delegate
// 返回组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 返回单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    // 设置选中时的背景图片
    UIView *selectedView = [[UIView alloc]initWithFrame:cell.bounds];
    selectedView.backgroundColor = [UIColor orangeColor];
    cell.selectedBackgroundView = selectedView;
    
    // 设置显示问题标题
    UILabel *title = [[UILabel alloc]initWithFrame:cell.contentView.frame];
    title.userInteractionEnabled = YES;
    title.font = [UIFont systemFontOfSize:14];
    title.layer.cornerRadius = 10;
    title.clipsToBounds = YES;
    title.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = _titles[indexPath.item];
    [cell.contentView addSubview:title];
    return cell;
    
}

// 返回组内单元格数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 7;
}

// 选中单元格
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    

    if (_block) {
        
        _block(indexPath.item);
    }
}

- (void)setBlock:(selected)block {
    if (_block != block) {
        
        _block = block;
    }
}

// 单元格消失时调用
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *subViews = [cell.contentView subviews];
    [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

@end
