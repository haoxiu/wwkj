//
//  LaunchViewController.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/29.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "LaunchViewController.h"
#import "MainController.h"
//#import "DataService.h"
#import "CycleScrollView.h"


@interface LaunchViewController ()<CycleScrollViewDelegate,CycleScrollViewDatasource>{
    
    UIButton *_lastBtn;
    NSString *newContent;
}
@property (nonatomic, strong) CycleScrollView *scrollView;
@property (nonatomic, strong) NSArray *imageArray;

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor blackColor];
//    [self loadViews];
    _imageArray = @[@"玩(1).jpg",@"械(1).jpg",@"宝(1).jpg",@"1(1).jpg"];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    _scrollView = [[CycleScrollView alloc]initWithFrame:self.view.frame];
    _scrollView.delegate = self;
    _scrollView.datasource = self;
    _scrollView.animationDuration = 4;
    [self.view addSubview:_scrollView];
    UIButton *showHome = [UIButton buttonWithType:UIButtonTypeCustom];
    showHome.frame = CGRectMake(self.view.width * 0.1, self.view.height *0.85, self.view.width * 0.25, 30);
    [showHome setTitle:@"首页" forState:UIControlStateNormal];
    [showHome setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [showHome addTarget:self action:@selector(showHome) forControlEvents:UIControlEventTouchUpInside];
    [showHome setBackgroundImage:[UIImage imageNamed:@"welcome_btn"] forState:UIControlStateNormal];
    [self.view addSubview:showHome];
    
    UIButton *showRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    showRegister.frame = CGRectMake(self.view.width * 0.62, self.view.height *0.85, self.view.width * 0.25, 30);
    [showRegister setTitle:@"注册" forState:UIControlStateNormal];
    [showRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [showRegister addTarget:self action:@selector(showRegister) forControlEvents:UIControlEventTouchUpInside];
    [showRegister setBackgroundImage:[UIImage imageNamed:@"welcome_btn"] forState:UIControlStateNormal];
    [self.view addSubview:showRegister];

}

- (NSInteger)numberOfPages
{
    return _imageArray.count;
}

- (UIView *)pageAtIndex:(NSInteger)index size:(CGSize)size
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width , _scrollView.frame.size.height)];
    imageView.image = [UIImage imageNamed:_imageArray[index]];
    return imageView;
}

//- (void)scrollView:(CycleScrollView *)scrollView didClickPage:(UIView *)view atIndex:(NSInteger)index
//{
//    NSLog(@"你点的是第%d个",(int)index + 1);
//}

//- (void)loadViews {
//    
//    
//
//   
//}
//// 跳转到首页
- (void)showHome {
    
    [self performSelector:@selector(showHome1) withObject:self afterDelay:2];
    
//    _scrollView.animationDuration = NO;
}

//延时2秒
- (void)showHome1 {

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MainController *mainVC = [[MainController alloc]init];
    window.rootViewController = mainVC;
}

// 跳转到注册
- (void)showRegister {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MainController *mainVC = [[MainController alloc]init];
    mainVC.selectedIndex =1;
    window.rootViewController = mainVC;
//    _scrollView.animationDuration = NO;
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    
//    if (buttonIndex == 1) {
//        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/cn/app/wan-xie-bao/id1013789429?l=en&mt=8"]];
//        
//    }
//}


@end
