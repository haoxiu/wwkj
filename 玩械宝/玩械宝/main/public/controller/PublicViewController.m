//
//  PublicViewController.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/11.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "PublicViewController.h"
#import "ZhaoPinViewController.h"
#import "QiuZhiViewController.h"
#import "BuyCarViewController.h"
#import "SellViewController.h"

#import "UINavigationController+CY.h"
#import "MBProgressHUD+NJ.h"
#import <ShareSDK/ShareSDK.h>

@interface PublicViewController (){
    NSArray *_titles;
    NSArray *_imgs;
}

@end

@implementation PublicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"发布";
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
    
    _titles = @[@"卖车信息",@"买车信息",@"出租信息",@"求租信息",@"求职信息",@"招聘信息"];
    _imgs = @[@"新版发布_018",@"新版发布_110",@"新版发布_031",@"新版发布_016",@"新版发布_112",@"新版发布_114"];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PublishCell"];
    _tableView.bounces = NO;
    UIView *footView = [[UIView alloc]init];
    _tableView.tableFooterView = footView;
}


#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublishCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _titles[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
    cell.imageView.image =[UIImage imageNamed:_imgs[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    if (username.length == 0) {
        
        [MBProgressHUD showError:@"请先登录"];
        self.tabBarController.selectedIndex = selectedIndexNum;
        return;
    }
    
    UIViewController *controller;
    switch (indexPath.row) {
        case 2: {
            SellViewController *sellVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SellViewController"];
            sellVC.isSell = NO;
            
            controller = sellVC;
        }
            break;
        case 3: {
            BuyCarViewController *buycarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BuyCarViewController"];
            buycarVC.isBuyCar = NO;
            
            controller = buycarVC;
            
        }
            break;
        case 0: {
            SellViewController *sellVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SellViewController"];
            sellVC.isSell = YES;
            
            controller = sellVC;
        }
            break;
        case 1: {
            BuyCarViewController *buycarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BuyCarViewController"];
            buycarVC.isBuyCar = YES;
            
            controller = buycarVC;
        }
            break;
        case 4: {
            QiuZhiViewController *qiuzhiVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QiuZhiViewController"];
            controller = qiuzhiVC;
        }
            break;
        case 5: {
            ZhaoPinViewController *zhaopinVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ZhaoPinViewController"];

            controller = zhaopinVC;
        }
            break;
            
        default:
            break;
    }
    //取消cell选中效果
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:controller andHideTabbar:YES animated:YES];
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
