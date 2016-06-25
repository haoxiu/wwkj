//
//  MainController.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/11.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "MainController.h"

#import "BarItem.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "LoginViewController.h"

#import "CYNavigationController.h"

#import "HomeViewController.h"
#import "PublicViewController.h"

#include "ProsonViewController.h"

#define kWidth self.view.frame.size.width
#define kHeight self.view.frame.size.height
@interface MainController (){
    
    BarItem *_lastItem;
    AppDelegate *_delegate;
}

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    _delegate = [UIApplication sharedApplication].delegate;
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    [self _createChildControllers];
    [self _createTabbarView];
   
}

// 创建tabbar
- (void)_createTabbarView {
    
    NSArray *titles = @[@"首页",@"联系人",@"发布",@"发现",@"个人"];


    NSArray *images = @[@"新版信息_3.jpg",@"新版信息_05.jpg",@"新版信息0_07.jpg",@"新版信息_09.jpg",@"新版信息_11.png"];

    NSArray *selectedImgs = @[@"新版信息0_03.jpg",@"新版信息0_05.jpg",@"新版信息0_07.jpg",@"新版信息0_09.jpg",@"新版信息0_11.png"];
    float itemWidth = kWidth/titles.count;
    for (int i = 0; i< titles.count; i++) {
        if (i == 2) {
            
            BarItem *item = [[BarItem alloc]initWithFrame:CGRectMake(i*itemWidth, 0, itemWidth, 49) title:titles[i] image:images[i] Twodecker:NO];
            item.tag = i+100;
            [item setSelectedColor:CYNavColor];
            [item setSelectedImg:selectedImgs[i]];
            [item addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
            [self.tabBar addSubview:item];
            
        }else{
            
            BarItem *item = [[BarItem alloc]initWithFrame:CGRectMake(i*itemWidth, 0, itemWidth, 49) title:titles[i] image:images[i] Twodecker:YES];
            item.tag = i+100;
            [item setSelectedColor:CYNavColor];
            [item setSelectedImg:selectedImgs[i]];
            [item addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
            [self.tabBar addSubview:item];
            
            if (i == 0) {
                _lastItem = item;
                item.isSelected = YES;
            }
        }
        
    }
}
// 创建子控制器
- (void)_createChildControllers {
    
    NSArray *sbNames = @[@"home",@"LinkMan",@"public",@"Discovery",@"profile"];
    
    for (int i = 0; i < sbNames.count; i++) {
        
        CYNavigationController *cyNav;
        UIViewController *rootVC;
        
        NSString *name = sbNames[i];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:name bundle:nil];
        UIStoryboard *profileSB = [UIStoryboard storyboardWithName:@"profile" bundle:nil];
        switch (i) {
            case 0:
            {
                rootVC = [[HomeViewController alloc] init];
                cyNav = [[CYNavigationController alloc] initWithRootViewController:rootVC];
            }
                break;
            case 1:
            {
                NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
                if (name.length != 0) {
                    rootVC = [sb instantiateViewControllerWithIdentifier:@"LinkManViewController"];
                    cyNav = [[CYNavigationController alloc] initWithRootViewController:rootVC];                }
                else {
                    
                    LoginViewController *rootVC = [profileSB instantiateViewControllerWithIdentifier:@"LoginViewController"];
                    cyNav = [[CYNavigationController alloc] initWithRootViewController:rootVC];
                }

            }
                break;
            case 2:
            {
                rootVC = [sb instantiateViewControllerWithIdentifier:@"PublicViewController"];
                cyNav = [[CYNavigationController alloc] initWithRootViewController:rootVC];
            }
                break;
            case 3:
            {
                rootVC = [sb instantiateViewControllerWithIdentifier:@"DiscoveryViewController"];
                cyNav = [[CYNavigationController alloc] initWithRootViewController:rootVC];
            }
                break;
                
            case 4:
            {
                NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
                if (name.length != 0) {
                    rootVC = [[ProsonViewController alloc]init];
                    cyNav = [[CYNavigationController alloc] initWithRootViewController:rootVC];
                }
                else {
                    LoginViewController *rootVC = [profileSB instantiateViewControllerWithIdentifier:@"LoginViewController"];
                    cyNav = [[CYNavigationController alloc] initWithRootViewController:rootVC];
                }
                
            }
                break;
                
            default:
                break;
        }
        [self addChildViewController:cyNav];
    }
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    //移除tabbar上的按钮
    NSArray *subViews = self.tabBar.subviews;
    for (UIView *view in subViews) {
        Class cla = NSClassFromString(@"UITabBarButton");
        //判断view对象是否是UITabBarButton类型
        if ([view isKindOfClass:cla]) {
            [view removeFromSuperview];
        }
    }
}
// tabBar按钮点击事件
- (void)selectTab:(UIControl *)control {
    
    _lastItem.isSelected = NO;
    self.selectedIndex = control.tag-100;
    BarItem *item = (BarItem *)control;
    item.isSelected = YES;
    _lastItem = item;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
    _lastItem.isSelected = NO;
    BarItem *item = (BarItem *)[self.tabBar viewWithTag:selectedIndex+100];
    item.isSelected = YES;
    _lastItem = item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
