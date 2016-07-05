//
//  TableHeadView.m
//  玩械宝
//
//  Created by Stone袁 on 16/3/12.
//  Copyright (c) 2016年 zgcainiao. All rights reserved.
//

#import "TableHeadView.h"

#import "UIView+viewController.h"
#import "MBProgressHUD+NJ.h"
#import <ShareSDK/ShareSDK.h>

@implementation TableHeadView

- (void)awakeFromNib{

    _userName.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    _nickName.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"nickname"];

    
}

- (IBAction)shareAction:(id)sender {
    
    UIViewController *fistCtr = self.firstAvailableUIViewController;
    NSLog(@"有响应");
    
#pragma mark 分享
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
        [container setIPadContainerWithView:self.firstAvailableUIViewController.view arrowDirect:UIPopoverArrowDirectionUp];
        
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
