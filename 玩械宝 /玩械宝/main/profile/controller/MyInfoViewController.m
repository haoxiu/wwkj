//
//  MyInfoViewController.m
//  玩械宝
//
//  Created by 刘昊 on 16/6/27.
//  Copyright © 2016年 zgcainiao. All rights reserved.
//

#import "MyInfoViewController.h"

#import "PresonViewCellTableViewCell.h"
#import "TableHeadView.h"
#import "Header.h"
#import "AboutViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "UserInfoViewController.h"
#import "changePwdViewController.h"
#import "SegmentViewController.h"
#import "DataService.h"
#import "MachineModel.h"
#import "CollectViewController.h"
#import "MainController.h"
#import "SetViewController.h"

#import "UINavigationController+CY.h"
#import "MyPCWViewController.h"
#import "MyWaitCheckViewController.h"
#import "CYNetworkTool.h"
#import "UIImageView+WebCache.h"
#import "QRCodeManager.h"

#import "MyHomeMachineViewController.h"

static NSString *identy = @"cellId";
@interface MyInfoViewController ()
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) TableHeadView *hv;
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation MyInfoViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    ;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _imgs = @[@"新版我的未登录状态_110",@"新版我的未登录状态_114"];
    _titles= @[@"我的收藏",@"设置"];
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    
    statusBarView.backgroundColor=[UIColor blackColor];
    
    [self.view addSubview:statusBarView];
    

    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,88)];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    _tableView.showsVerticalScrollIndicator = NO;//不显示右侧滑块
    _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;//分割线

    //注册单元格
    [_tableView registerNib:[UINib nibWithNibName:@"PresonViewCellTableViewCell" bundle:nil] forCellReuseIdentifier:identy];
    
    //头视图
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"TableHeadView" owner:nil options:nil];
    _hv =[nibView objectAtIndex:0];
    
    _hv.frame = CGRectMake(0, 0, kScreenWidth, 150);
    
    [_tableView setTableHeaderView:_hv];
    //加载数据
    [self loadDates];

    
}

- (void)loadDates
{
    [CYNetworkTool post:URL_UserInfo params:@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]} success:^(id json) {
        
        DetailInfoModel *_model = [[DetailInfoModel alloc]initContentWithDic:json];
        NSString *hdimg = json[@"hdimg"];
        
        NSData *imgData = [[NSData alloc]initWithBase64EncodedString:hdimg options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *headImg = [UIImage imageWithData:imgData];
        //把 性别、个人签名 添加到偏好设置中持久化
        [[NSUserDefaults standardUserDefaults]setObject:_model.sex forKey:@"sex"];
        [[NSUserDefaults standardUserDefaults]setObject:_model.sign forKey:@"sign"];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"isSaved"];
        _hv.nickImg.layer.cornerRadius = _hv.nickImg.width/2;
        _hv.nickImg.clipsToBounds = YES;
        _hv.nickImg.translatesAutoresizingMaskIntoConstraints = NO;
        
        if (headImg != nil) {
            _hv.nickImg.image = headImg;
        }
        
    } failure:^(NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
        });
    }];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 10;
    }else{
        return 0.1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _imgs.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PresonViewCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy forIndexPath:indexPath];
    
        cell.imageview.image = [UIImage imageNamed:_imgs[indexPath.row]];
        cell.lable.text = _titles[indexPath.row];
        cell.img.image = [UIImage imageNamed:@"right_icon"];
    
    return cell;
}
#pragma mark 单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

#pragma mark 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //点击颜色马上变回来
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"profile" bundle:nil];
//            
//        UserInfoViewController *userInfo = [sb instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
//        
//        [self.navigationController pushViewController:userInfo andHideTabbar:YES animated:YES];

            MyPCWViewController *wc =[[MyPCWViewController alloc]init];
            wc.title = @"我的收藏";
            wc.flag = 2;
            [self.navigationController pushViewController:wc andHideTabbar:YES animated:YES];
        }else if (indexPath.row == 1){
            SetViewController *sc = [[SetViewController alloc] init];
            sc.title = @"设置";
            [self.navigationController pushViewController:sc animated:YES];
        }
    }
}


@end
