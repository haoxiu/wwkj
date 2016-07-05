//
//  PhotoViewController.h
//  WXMovie
//
//  Created by seven on 15/2/11.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoCollectionView;
@interface PhotoViewController : UIViewController {
    
    PhotoCollectionView *collectionView;
    
    //判断状态栏是否隐藏
    BOOL isHidden;
}

@property (nonatomic, strong) UIImage *img; //图片


@property(nonatomic,strong)NSArray *urls;   //所有图片的字符串链接
@property(nonatomic,strong)NSIndexPath *indexPath; //当前单元格索引

@end
