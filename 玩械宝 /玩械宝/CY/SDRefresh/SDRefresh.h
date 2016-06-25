//
//  SDRefresh.h
//  SDRefreshView
//
//  Created by aier on 15-2-27.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

/**
 
 *******************************************************
 *                                                      *
 * 感谢您的支持， 如果下载的代码在使用过程中出现BUG或者其他问题    *
 * 您可以发邮件到gsdios@126.com 或者 到                       *
 * https://github.com/gsdios?tab=repositories 提交问题     *
 *                                                      *
 *******************************************************
 
 */

#import "SDRefreshHeaderView.h"
#import "SDRefreshFooterView.h"

/*（1）SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
 
 （2）[refreshHeader addToScrollView:目标tableview];  //加入到目标tableview，默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
 
 （3）[refreshHeader addTarget: refreshAction:加载内容的方法] 或者 refreshHeader.beginRefreshingOperation = ^{} 任选其中一种即可
 
 PS：
 
 加载数据完成后调用 [refreshHeader endRefreshing];
 如果需要一进入就自动加载一次数据，请调用[refreshHeader autoRefreshWhenViewDidAppear];
 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
 */