//
//  ProfileViewController.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/13.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "ProfileViewController.h"
#import "AboutViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "SVProgressHUD.h"
#import "UserInfoViewController.h"
#import "changePwdViewController.h"
#import "SegmentViewController.h"
#import "DataService.h"
#import "MachineModel.h"
#import "CollectViewController.h"
#import "MainController.h"

#import "UINavigationController+CY.h"
#import "MyPCWViewController.h"
#import "MyWaitCheckViewController.h"
#import "CYNetworkTool.h"
#import "UIImageView+WebCache.h"

@interface ProfileViewController ()
{
    
    AppDelegate *_delegate;
    NSArray *_cellTitles;
}

@property (weak, nonatomic) IBOutlet UIButton *loginOutBtn;

//我的二维码
- (IBAction)identifier:(id)sender;



- (IBAction)clean_Up:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _delegate = [UIApplication sharedApplication].delegate;
//    [self.navigationItem setHidesBackButton:YES];
    
    NSArray *imgArrs = @[@"新版信息0_11.png",@"publi_shing_icon",@"1collection_03",@"1hourglass_button",@"build",@"clean_up_cache",@"1password_button",@"1about_button"];
    
    NSArray *titllArrs = @[@"个人信息",@"我的发布",@"我的收藏",@"等待审核",@"我的二维码",@"清理缓存",@"修改密码",@"关于我们"];
    
    [self preferredStatusBarStyle];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    //白色的
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden =YES;
    [self loadViews];
}

- (void)loadViews {

    _phoneNum.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    _nickName.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"nickname"];
#warning 图片加载
    
    
    [CYNetworkTool post:URL_UserInfo params:@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]} success:^(id json) {
        
        DetailInfoModel *_model = [[DetailInfoModel alloc]initContentWithDic:json];
        NSString *hdimg = json[@"hdimg"];

        NSData *imgData = [[NSData alloc]initWithBase64EncodedString:hdimg options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *headImg = [UIImage imageWithData:imgData];
        //把 性别、个人签名 添加到偏好设置中持久化
        [[NSUserDefaults standardUserDefaults]setObject:_model.sex forKey:@"sex"];
        [[NSUserDefaults standardUserDefaults]setObject:_model.sign forKey:@"sign"];
        [[NSUserDefaults standardUserDefaults]setObject:_model.hdimg forKey:@"hdImg"];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"isSaved"];
        _headImg.layer.cornerRadius = _headImg.width/2;
        _headImg.clipsToBounds = YES;
        _headImg.translatesAutoresizingMaskIntoConstraints = NO;
    
        if (headImg != nil) {
            _headImg.image = headImg;
        }
        
    } failure:^(NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
        });
    }];
//    // 字符串转图片
//    NSData *imgData = [[NSData alloc]initWithBase64EncodedString:[[NSUserDefaults standardUserDefaults] objectForKey:@"hdimg"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    UIImage *headImg = [UIImage imageWithData:imgData];
//    _headImg.layer.cornerRadius = _headImg.width/2;
//    _headImg.clipsToBounds = YES;
//    _headImg.translatesAutoresizingMaskIntoConstraints = NO;
//    if (headImg != nil) {
//        _headImg.image = headImg;
//    }
    
    //判断view是否超出屏幕
    CGFloat factH = _loginOutBtn.bottom ;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    if (factH > screenH) {
        _scrollView.contentSize = CGSizeMake( self.view.bounds.size.width, factH);
    }else {
        _scrollView.scrollEnabled = NO;
    }
    
    
//分享按钮
    [_shard addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
}

// 分享
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

// 退出登录
- (IBAction)logoutAction {
    
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"username"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"nickname"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"pwd"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"hdimg"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"sex"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"sign"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"isSaved"];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MainController *mainVC = [[MainController alloc]init];
    window.rootViewController = mainVC;
}
- (void)pushWithIndex:(NSInteger)index
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//修改密码
- (IBAction)pushPwd:(id)sender {
    
    changePwdViewController *changePwd =[[changePwdViewController alloc]init];

    [self.navigationController pushViewController:changePwd andHideTabbar:YES animated:YES];
}

//个人信息
- (IBAction)infoBtnClick:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"profile" bundle:nil];
    UserInfoViewController *userInfo = [sb instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
    [self.navigationController pushViewController:userInfo andHideTabbar:YES animated:YES];
}

//关于我们
- (IBAction)aboutMe:(id)sender {
    AboutViewController *aboutMe =[[AboutViewController alloc]init];

    [self.navigationController pushViewController:aboutMe andHideTabbar:YES animated:YES];
}

//等待审核
- (IBAction)collectNow:(id)sender {
    MyPCWViewController *wc =[[MyPCWViewController alloc]init];
    wc.title = @"等待审核";
    wc.flag = 3;
    [self.navigationController pushViewController:wc andHideTabbar:YES animated:YES];

}

//我的收藏
- (IBAction)myCollectBtnClick:(id)sender {
  
    MyPCWViewController *wc =[[MyPCWViewController alloc]init];
    wc.title = @"我的收藏";
    wc.flag = 2;
    [self.navigationController pushViewController:wc andHideTabbar:YES animated:YES];
}

//我的发布
- (IBAction)myPublishBtnClick:(id)sender {
    
    MyPCWViewController *wc =[[MyPCWViewController alloc]init];
    wc.title = @"我的发布";
    wc.flag = 1;
    [self.navigationController pushViewController:wc andHideTabbar:YES animated:YES];
}

- (IBAction)identifier:(id)sender {
}

- (IBAction)clean_Up:(id)sender {
}
@end
