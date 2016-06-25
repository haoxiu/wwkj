//
//  UINavigationController+CY.m
//  玩械宝
//
//  Created by echo on 11/7/15.
//  Copyright (c) 2015 zgcainiao. All rights reserved.
//

#import "UINavigationController+CY.h"


@implementation UINavigationController (CY)

//[self.navigationController pushViewController:cellView animated:YES];

- (void)pushViewController:(UIViewController *)viewController andHideTabbar:(BOOL)hidded  animated:(BOOL)animated
{
    viewController.hidesBottomBarWhenPushed = hidded;
    [self pushViewController:viewController animated:animated];
}


@end
