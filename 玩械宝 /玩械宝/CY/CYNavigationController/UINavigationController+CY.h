//
//  UINavigationController+CY.h
//  玩械宝
//
//  Created by echo on 11/7/15.
//  Copyright (c) 2015 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (CY)

/**
 push 控制器的适合，是否 hide 下面的 Tabbar
 */
- (void)pushViewController:(UIViewController *)viewController andHideTabbar:(BOOL)hidded  animated:(BOOL)animated;

@end
