//
//  CYNavigationController.m
//  玩械宝
//
//  Created by echo on 11/7/15.
//  Copyright (c) 2015 zgcainiao. All rights reserved.
//

#import "CYNavigationController.h"

#import "Header.h"
#import <ShareSDK/ShareSDK.h>
#import "MBProgressHUD+NJ.h"

@interface CYNavigationController ()

@end

@implementation CYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 导航栏背景颜色
    self.navigationBar.barTintColor = CYNavColor;
    // 导航栏标题属性
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:nil size:18.0]};
    
    // 导航栏按钮标题颜色
//    self.navigationBar.tintColor = [UIColor whiteColor];
 
    //  Item－模型，Bar－view
    
    /*
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:@"share_icon.png"] forState:UIControlStateNormal];
    
    // 设置尺寸
    btn.width = btn.currentBackgroundImage.size.width;
    btn.height = btn.currentBackgroundImage.size.height;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    */
    
    //设置控制器 navigationItem的backBarButtonItem 显示文字为""
//    self.navigationItem.backBarButtonItem.title = @"";
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -100) forBarMetrics:UIBarMetricsDefault];
    
    /*************  导航栏 返回按钮 的图片设置    **********
     backIndicatorImage;
     backIndicatorTransitionMaskImage;
     必须要两个都设置，并且图片要设置成不渲染
     */

    UIImage *img = [UIImage imageNamed:@"return_button"];
    
    /*
    - (UIImage *)imageWithRenderingMode:(UIImageRenderingMode)renderingMode
    //这个方法就是用来设置图片的渲染模式的

    UIImageRenderingModeAlwaysOriginal 
     //这个枚举值是声明这张图片要按照原来的样子显示，不需要渲染成其他颜色
     
     */

    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationBar.backIndicatorImage = img;
    self.navigationBar.backIndicatorTransitionMaskImage = img;

}

/*
- (void)share
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"玩械宝最专业的机械设备资源整合平台。https://itunes.apple.com/cn/app/wan-xie-bao/id1013789429?l=en&mt=8"
                                       defaultContent:@"玩械宝"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"玩械宝"
                                                  url:@"https://itunes.apple.com/cn/app/wan-xie-bao/id1013789429?l=en&mt=8"
                                          description:@"玩械宝"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    [MBProgressHUD showSuccess:@"分享成功"];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    // NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    [MBProgressHUD showError:[error errorDescription]];
                                }
                            }];
    
}
*/

- (UIStatusBarStyle)preferredStatusBarStyle {
    //白色的
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
