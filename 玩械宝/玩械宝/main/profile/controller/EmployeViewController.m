//
//  EmployeViewController.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/18.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "EmployeViewController.h"
#import "DetailInfoModel.h"

#import "UserInfoViewController.h"

#import "MBProgressHUD+NJ.h"
#import "CYNetworkTool.h"
#import "Header.h"

@interface EmployeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
- (IBAction)showAction:(id)sender;

@end

@implementation EmployeViewController

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
    
    self.title = @"求职详情";
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self loadDatas];
}

// 收藏

- (void)loadCollectData
{
    [CYNetworkTool post:URL_JugeQZCollect params:@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"id":_mode.ID,@"catid":@"10"} success:^(id json) {
        if ([json[@"state"] isEqualToString:@"1"]) { //收藏了的
                _collectBtn.enabled = NO;
        }
        else {
        }
        
    } failure:^(NSError *error) {
        //        [MBProgressHUD showError:@"网络异常"];
    }];
}

- (IBAction)collectBtnClick:(id)sender {
    if (_collectBtn.selected) {//已经选中的,删除
        [self deleteCollect];
    }else { //未选中的,收藏
        [self collect];
    }
//    if (_isFromCollect) {
//    }else {
//        [self collect];
//    }
}

- (void)collect
{
    
    if (_type == nil) {
        
        [MBProgressHUD showSuccess:@"请重新收藏"];
        return;
    }else{
    
        [CYNetworkTool post:URL_AddCollect params:@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"id":_mode.ID,@"type":_type} success:^(id json) {
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
    
    [CYNetworkTool post:URL_DeleteCollect params:@{@"colid":_mode.colid} success:^(id json) {
        
        NSLog(@"%@",json);
        
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
    if (_mode.userName != nil) {
        
        NSDictionary *params = @{@"username":_mode.userName};
        
        MBProgressHUD *hd = [MBProgressHUD showMessage:@"正在加载"];
        hd.dimBackground = NO;
        
        sender.enabled = NO;
        
        [CYNetworkTool post:URL_UserInfo params:params success:^(id json) {
            [MBProgressHUD hideHUD];
            if (![json[@"state"] isEqualToNumber:@1]) {
                [MBProgressHUD showError:json[@"msg"]];
                return ;
            }
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
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_mode.phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (void) loadDatas{
    _name.text =_mode.name;
    _briday.text =_mode.brithday;
    _sex.text =_mode.sex;
    _jobback.text =_mode.year;
    _education.text =_mode.educational;
    _salary.text =_mode.salary;
    _workplace.text =_mode.address;
    _jobtype.text =_mode.jobtype;
    _miaoshu.text =_mode.content;
}

- (IBAction)showAction:(id)sender {
    
    NSLog(@"EmployeViewController求职分享");
}
@end
