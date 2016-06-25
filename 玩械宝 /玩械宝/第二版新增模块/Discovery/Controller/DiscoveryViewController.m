//
//  DiscoveryViewController.m
//  玩械宝
//
//  Created by Stone袁 on 15/12/17.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "DiscoveryViewController.h"

#import "UINavigationController+CY.h"
#import "MBProgressHUD+NJ.h"
#import <ShareSDK/ShareSDK.h>

#import "DiscoveryViewCell.h"
#import "CircleFriendsViewController.h"

#import "AroundViewController.h"

@interface DiscoveryViewController (){
    NSArray *_titles;
    NSArray *_imgs;
}
@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发现";
    [self _loadViews];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:@"share_icon.png"] forState:UIControlStateNormal];
    
    // 设置尺寸
    btn.width = btn.currentBackgroundImage.size.width;
    btn.height = btn.currentBackgroundImage.size.height;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}
- (void)_loadViews {
    
    _titles = @[@"附近出租", @"附近求租",@"附近卖车", @"附近买车", @"附近求职", @"附近招聘"];
    _imgs = @[@"新版发现1_16.jpg",@"新版发现1_18.jpg",@"新版发现1_14.jpg",@"新版发现1_12.jpg",@"新版发现1_22.png",@"新版发现1_20.jpg"];

    _tableView.bounces = NO;
    UIView *footView = [[UIView alloc]init];
    _tableView.tableFooterView = footView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
        
    } else
        
        return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DiscoveryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoveryViewCell"];
    
    if (cell == nil) {
        
        cell = [[NSBundle mainBundle]loadNibNamed:@"DiscoveryViewCell" owner:nil options:nil] [0];
    }
    
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublishCell" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) {
        cell.Lable.text = @"朋友圈";
        cell.Lable.font = [UIFont systemFontOfSize:16];
        [cell.imagView setContentMode:UIViewContentModeScaleAspectFit];
        cell.imagView.image =[UIImage imageNamed:@"新版发现1_03.jpg"];
        
    }else if (indexPath.section == 1){
        
        cell.Lable.text = _titles[indexPath.row];
        cell.Lable.font = [UIFont systemFontOfSize:16];
        [cell.imagView setContentMode:UIViewContentModeScaleAspectFit];
        cell.imagView.image =[UIImage imageNamed:_imgs[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 0.01;
    }
    
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    //取消tableView选中效果
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (username.length == 0) {
        
        [MBProgressHUD showError:@"请先登录"];
        self.tabBarController.selectedIndex = 4;
        return;
    }
    
    UIViewController *controller;
    
    if (indexPath.section == 0) {
        
        CircleFriendsViewController *machineVC = [[CircleFriendsViewController alloc] init];
        
        /* 12求租  14出租  13卖车  9买车 */
        
//        machineVC.type =@"12";
        
//        machineVC.catid =machineVC.type;
        //类型的哪一行
//        machineVC.title = @"大型挖掘机";
        controller = machineVC;
    }
    [self.navigationController pushViewController:controller andHideTabbar:YES animated:YES];
    
    if (indexPath.section == 1) {
        AroundViewController*aroundVC=[[AroundViewController alloc]init];
        [self.navigationController pushViewController:aroundVC andHideTabbar:YES animated:YES];
        aroundVC.isVc = YES;
        
    }
}

#pragma mark - Scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat sectionHeaderHeight = 40;
    //固定section 随着cell滚动而滚动
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        
    }
    
}


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





@end
