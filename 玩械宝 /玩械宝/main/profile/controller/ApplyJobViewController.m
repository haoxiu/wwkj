//
//  ApplyJobViewController.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/18.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "ApplyJobViewController.h"

#import "UserInfoViewController.h"

#import "MBProgressHUD+NJ.h"
#import "CYNetworkTool.h"
#import "Header.h"
@interface ApplyJobViewController ()

@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
- (IBAction)showAction:(id)sender;
@end

@implementation ApplyJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_shouldHide) {
        _collectBtn.hidden =YES;
    } else {
        if (_isFromCollect) {
            _collectBtn.selected = YES;
        } else {
            [self loadCollectData];
        }
    }
    
    [self loadDatas];
    self.title = @"招聘详情";
    self.edgesForExtendedLayout =UIRectEdgeNone;
}

// 收藏

- (void)loadCollectData
{
    [CYNetworkTool post:URL_JugeQZCollect params:@{@"id":_model.ID,@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"catid":@"11"} success:^(id json) {
        if ([json[@"state"] isEqualToString:@"1"]) { //收藏了的

                _collectBtn.enabled = NO;

        }
    } failure:^(NSError *error) {
        //        [MBProgressHUD showError:@"网络异常"];
    }];

}

- (IBAction)collectBtnClick:(id)sender {
    if (_isFromCollect) {
        if (_collectBtn.selected) {//已经选中的,删除
            [self deleteCollect];
        }else { //未选中的,收藏
            [self collect];
        }
    }else {
        [self collect];
    }
}

- (void)collect
{
    
    if (_type == nil) {
        [MBProgressHUD showSuccess:@"请重新收藏"];
        return ;
    }else{
    
        [CYNetworkTool post:URL_AddCollect params:@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"id":_model.ID,@"type":_type} success:^(id json) {
            
            NSLog(@"%@",json[@"state"]);
            
            if ([[json[@"state"] stringValue] isEqualToString:@"1"]) {
                if (_isFromCollect) {
                    _collectBtn.selected = YES;
                }else {
                    _collectBtn.enabled =NO;
                }
                [MBProgressHUD showSuccess:@"收藏成功"];
            }
            else {
                //是否要判断
                
                [MBProgressHUD showError:@"收藏失败"];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"网络异常"];
        }];
    
    }
    
}

- (void)deleteCollect
{
    [CYNetworkTool post:URL_DeleteCollect params:@{@"colid":_model.colid} success:^(id json) {
        if ([json[@"state"] isEqualToNumber:@1]) {
            _collectBtn.selected = NO;
            [MBProgressHUD showSuccess:@"已取消收藏"];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else {
            //是否要判断
            
            [MBProgressHUD showError:@"取消收藏失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络异常"];
    }];
}

// 分享
/*
- (void)share:(UIButton *)button {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"玩械宝最专业的机械设备资源整合平台。"
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
                                    [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    // NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    [SVProgressHUD showErrorWithStatus:[error errorDescription]];
                                }
                            }];
    
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showUserAction:(UIButton *)sender {
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if (username.length == 0) {
        
        sender.enabled = YES;
        [MBProgressHUD showError:@"请先登录"];
        self.tabBarController.selectedIndex = 2;
        return;
    }
    UserInfoViewController *userVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
    if (_model.userName != nil) {
        
        MBProgressHUD *hd = [MBProgressHUD showMessage:@"正在加载"];
        hd.dimBackground = NO;
        
        sender.enabled = NO;
        
        [CYNetworkTool post:URL_UserInfo params:@{@"username":_model.userName} success:^(id json) {
            [MBProgressHUD hideHUD];
            DetailInfoModel *userModel = [[DetailInfoModel alloc]initContentWithDic:json];
            userVC.model = userModel;
            userVC.fromOtherController = YES;
            sender.enabled = YES;
            [self.navigationController pushViewController:userVC animated:YES];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"网络异常"];
        }];
    }
}


- (IBAction)callAction:(UIButton *)sender {
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if (username.length == 0) {
        
        [MBProgressHUD showError:@"请先登录"];
        self.tabBarController.selectedIndex = 2;
        return;
    }

    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_model.phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (void)loadDatas{

    _miaoshu.text =_model.content;
    _companyname.text =_model.companyName;
    _workback.text =_model.workBack;
    _educational.text =_model.educational;
    _salary.text =_model.salary;
    _place.text =_model.address;
    _jobtype.text =_model.jobtype;
}
- (IBAction)showAction:(id)sender {
    
    NSLog(@"ApplyJobViewController分享");
}
@end
