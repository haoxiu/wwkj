//
//  XSNavigationController.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/11.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "XSNavigationController.h"

@interface XSNavigationController ()

@end


@implementation XSNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 导航栏背景颜色
//    self.navigationBar.barTintColor = [UIColor colorWithRed:18/255.0 green:184/255.0 blue:246/255.0 alpha:1];//colorWithRed:0.239f green:0.506f blue:0.867f alpha:1.00f];
//    // 导航栏标题属性
//    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:nil size:18.0]};
//    
//    // 导航栏按钮标题颜色
//    self.navigationBar.tintColor = [UIColor whiteColor];
    
    
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
