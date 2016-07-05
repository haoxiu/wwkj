//
//  MyBuyDetailViewController.m
//  玩械宝
//
//  Created by echo on 11/18/15.
//  Copyright (c) 2015 zgcainiao. All rights reserved.
//

#import "MyBuyDetailViewController.h"

#import "CollectWithMeTableViewCellMode.h"
#import "PersonInfoViewController.h"
#import "Header.h"
#import "MBProgressHUD+NJ.h"
#import "CYNetworkTool.h"

#import "UserInfoViewController.h"
#import "DetailInfoModel.h"

@interface MyBuyDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *requireLabel;


@end

@implementation MyBuyDetailViewController{

    MBProgressHUD *hub;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden =NO;
    self.edgesForExtendedLayout =UIRectEdgeNone;
    
    if (_shouldHide) {
        _collectBtn.hidden =YES;
    } else {
        if (_isFromCollect) {
            _collectBtn.selected = YES;
        } else {
            [self loadCollectData];
        }
    }
    
    self.title = @"详细信息";
    
    [self loadViews];
    
}


- (void)loadViews{
    
    _typeLabel.text = _mode.cartype;
    
    _timeLabel.text =_mode.time;
    _timeLabel2.text =_mode.time;
    
    _brandLabel.text =_mode.esayPresent;

    _addressLabel.text =_mode.mapText;

    _requireLabel.text =_mode.detailPresent;
    
}

- (void)loadCollectData
{
    [CYNetworkTool post:URL_JugeAllCollect params:@{@"id":_mode.ID,@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]} success:^(id json) {
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

- (void)deleteCollect
{
    [CYNetworkTool post:URL_DeleteCollect params:@{@"colid":_mode.colid} success:^(id json) {
        if ([[json[@"state"] stringValue] isEqualToString:@"1"]) {
            _collectBtn.selected = NO;
            [MBProgressHUD showSuccess:@"已取消收藏"];
            [self.navigationController popViewControllerAnimated:YES];

        }
        else if ([[json[@"state"] stringValue] isEqualToString:@"101"]){
            //是否要判断
            
            [MBProgressHUD showError:@"取消收藏失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络异常"];
    }];
}

- (IBAction)infoBtnClick:(id)sender {
    hub = [MBProgressHUD showMessage:@"正在加载"];
    hub.dimBackground = NO;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"profile" bundle:nil];
    UserInfoViewController *userVC = [sb instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
    
    
    if (_mode.phoneName != nil) {
        
        [CYNetworkTool post:URL_UserInfo params:@{@"username":_mode.phoneName} success:^(id json) {
            
            DetailInfoModel *userModel = [[DetailInfoModel alloc] initContentWithDic:json];
            userVC.model = userModel;
            userVC.fromOtherController = YES;
            
            [MBProgressHUD hideHUD];
            
            [self.navigationController pushViewController:userVC animated:YES];
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"网络异常"];
        }];
        
    }
}

- (IBAction)callBtnClick:(id)sender {
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if (username.length == 0) {
        
        [MBProgressHUD showError:@"请先登录"];
        self.tabBarController.selectedIndex = selectedIndexNum;
        return;
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_mode.phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [hub removeFromSuperview];
    
}

@end
