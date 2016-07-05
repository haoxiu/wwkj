//
//  PhotoViewController.m
//  WXMovie
//
//  Created by seven on 15/2/11.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoCollectionView.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"图片浏览";

    
    //获取导航栏
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    //设置导航栏样式 黑色
    navigationBar.barStyle = UIBarStyleBlack;
    //设置半透明
    navigationBar.translucent = YES;
    
    //设置滚动视图是否自动偏移
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main"]];
    
    //1.设置返回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    //2.创建collectionView
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    //设置滑动方向
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    //设置单元格大小
//    flowLayout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight);
//    
//    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:flowLayout];
//    
//    collectionView.dataSource = self;
//    collectionView.delegate = self;
    
    collectionView = [[PhotoCollectionView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:collectionView];
    
    
    //3.给指定的collectionView传数据
    collectionView.urls = self.urls;
    collectionView.indexPath = self.indexPath;
    
    collectionView.img = _img;
    
    //4.滚动到指定单元格
    [collectionView scrollToItemAtIndexPath:_indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    
    //5.监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imgClickAction:) name:kImgClikNotification object:nil];

}


#pragma mark - 监听图片单击事件
- (void)imgClickAction:(NSNotification *)notification {
    
//    [UIView animateWithDuration:1 animations:^{
//        
//        self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.hidden;
//    }];
    
    isHidden = !isHidden;
    
    [self.navigationController setNavigationBarHidden:isHidden animated:YES];
    
    
    //ios7隐藏状态栏
    /*
     setNeedsStatusBarAppearanceUpdate ： 刷新状态栏的显示
     此方法会触发调用，当前控制器的
     - (BOOL)prefersStatusBarHidden
     - (UIStatusBarStyle)preferredStatusBarStyle
     */
    [self setNeedsStatusBarAppearanceUpdate];
    
}

//返回事件
- (void)backAction {
    
//    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.navigationController popViewControllerAnimated:NO];
}


//设置状态栏是否隐藏
- (BOOL)prefersStatusBarHidden {
    return isHidden;
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//
//    return UIStatusBarStyleLightContent;
//}



@end
