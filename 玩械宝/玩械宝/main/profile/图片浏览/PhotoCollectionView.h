//
//  PhotoCollectionView.h
//  WXMovie
//
//  Created by seven on 15/2/11.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UIImage *img; //图片


@property(nonatomic,strong)NSArray *urls;   //所有图片的字符串链接
@property(nonatomic,strong)NSIndexPath *indexPath;  //单元格索引

@end
