//
//  PhotoCollectionView.m
//  WXMovie
//
//  Created by seven on 15/2/11.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "PhotoCollectionView.h"
#import "UIImageView+WebCache.h"
#import "PhotoCell.h"
#import "PhotoScrollView.h"

static  NSString *myidentify = @"photoCell";

@implementation PhotoCollectionView {
    
    
}

- (id)initWithFrame:(CGRect)frame {
    
   
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //设置滑动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //设置单元格大小
    flowLayout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight-64);
    //设置单元格的间隙(在collectionView的宽度上只显示一个单元格，所以编译器认为没有并列的单元格)
//    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    
    if (self) {
        
        self.dataSource = self;
        self.delegate = self;
        
        //设置分页
        self.pagingEnabled = YES;
        
        self.backgroundColor = [UIColor whiteColor];
        
        //注册单元格
        [self registerClass:[PhotoCell class] forCellWithReuseIdentifier:myidentify];
    }
    
    return self;
}

- (void)setImg:(UIImage *)img{

    if (_img != img) {
        
        _img = img;
    }

}


- (void)setUrls:(NSArray *)urls {
    
    if (_urls != urls) {
        _urls = urls;
        
        //刷新单元格
        [self reloadData];
    }
}

#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (_img) {
        
        return 1;
    }else
    
    return _urls.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:myidentify forIndexPath:indexPath];
    
    //不符合要求，一个单元格上可能会产生多个UIImageView
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    NSString *urlstring = self.urls[indexPath.row];
//    NSURL *url = [NSURL URLWithString:urlstring];
//    [imageView setImageWithURL:url];
//    [cell.contentView addSubview:imageView];
//
//    cell.backgroundColor = [UIColor orangeColor];
    
    
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:myidentify forIndexPath:indexPath];
    
    if (_img) {
        
        cell.img = _img;
    }else {
    
        //传值
        cell.urlstring = self.urls[indexPath.item];
    
    }
    
    
    return cell;
}


#pragma mark - UICollectionViewDelegate
//单元格从collectionView上移除的时候调用
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //获取消失了得单元格
    PhotoCell *myCell = (PhotoCell *)cell;
    
    //将消失的单元格的图片大小还原
    if (myCell.scrollView.zoomScale > 1) {
        
        [myCell.scrollView setZoomScale:1 animated:NO];
    }
    
}

//@protocol UICollectionViewDelegate <UIScrollViewDelegate>
#pragma mark - UIScrollView delegate
//结束减速
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    
//    //scrollView 就是collectionView
////    NSLog(@"%f",scrollView.contentOffset.x);
//    
////    curretnIndex  cell.scrollView.setzoomValue 1
////    currentIndex前一个   index现在
////    currentIndex = index
//    
//    NSInteger index = scrollView.contentOffset.x/scrollView.width;
//    
//    if (self.indexPath.item != index) {
//        
////        NSLog(@"翻页了");
//        
//        //根据索引获取单元格(上一个单元格)
//        PhotoCell *cell = (PhotoCell *)[self cellForItemAtIndexPath:self.indexPath];
//        
//        //获取的单元格可能从collectionView上移除了，无法将原有的单元格图片还原
//        NSLog(@"%@",cell);
//        
//        //将原来放大的单元格缩小
//        [cell.scrollView setZoomScale:1 animated:NO];
//    }
//    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
//    
//    //更新当前索引（当前索引为显示的单元格的索引）
//    self.indexPath = indexPath;
//}


@end
