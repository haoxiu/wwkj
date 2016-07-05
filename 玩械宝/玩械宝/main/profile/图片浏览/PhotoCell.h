//
//  PhotoCell.h
//  WXMovie
//
//  Created by seven on 15/2/11.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoScrollView;
@interface PhotoCell : UICollectionViewCell {
    
//    PhotoScrollView *_scrollView;
}

@property (nonatomic, strong) UIImage *img; //图片


@property(nonatomic,strong)NSString *urlstring; //图片的链接

@property(nonatomic,strong)PhotoScrollView *scrollView;

@end
