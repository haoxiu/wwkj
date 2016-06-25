//
//  ProfileViewController.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/11.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <ShareSDK/ShareSDK.h>
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "FindViewController.h"
#import "SimpleInfoModel.h"
#import "ProfileViewController.h"

#import "XSNavigationController.h"
#import "HomeViewController.h"
#import "MainController.h"

#import "CYNetworkTool.h"
#import "UINavigationController+CY.h"
#import "MBProgressHUD+NJ.h"
#import "DataPersistenceManager.h"



//融云即时通讯
#import<UIKit/UIKit.h>
#import<RongIMKit/RCConversationViewController.h>
#import "YourTestChatViewControlle.h"
#import "ProsonViewController.h"
#import "AppDelegate.h"
#import "FriendInfoModel.h"

@interface LoginViewController () 

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setHidesBackButton:NO];
    self.title = @"登录";
    [self _loadViews];
    
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    _pwdTF.text = nil;
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    
}

// 创建子视图
- (void)_loadViews {
    _registerBtn.backgroundColor =[UIColor clearColor];
    _registerBtn.titleLabel.textColor =[UIColor colorWithRed:87/255.0 green:196/255.0 blue:135/255.0 alpha:1];
    _registerBtn.layer.borderWidth =1.0;
    _registerBtn.layer.borderColor =[UIColor colorWithRed:87/255.0 green:196/255.0 blue:135/255.0 alpha:1].CGColor;
    
    _numTF.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    _pwdTF.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    // 导航栏分享按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(50, 0, 40, 30);
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem =right2;

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
                                    [MBProgressHUD showSuccess:@"分享成功"];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                     NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    [MBProgressHUD showError:[error errorDescription]];
                                }
                            }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 登录
- (void)loginWithUserName:(NSString *)userName pwd:(NSString *)pwd {
    
     NSDictionary *params = @{@"username":userName,@"password":pwd};

    MBProgressHUD *hub = [MBProgressHUD showMessage:@"正在登录"];
    hub.dimBackground = NO;
    
    [CYNetworkTool post:URL_Login params:params success:^(id json) {
      
        [MBProgressHUD hideHUD];
        NSNumber *state = json[@"state"];
        
        //登陆成功
        if ([state isEqualToNumber:@1])
        {
            SimpleInfoModel *model = [[SimpleInfoModel alloc]initContentWithDic:json[@"data"]];
            [[NSUserDefaults standardUserDefaults]setObject:_numTF.text forKey:@"username"];
            [[NSUserDefaults standardUserDefaults]setObject:_pwdTF.text forKey:@"PassWord"];
            //存储个人信息
            [[NSUserDefaults standardUserDefaults]setObject:model.nickname forKey:@"nickname"];
            [[NSUserDefaults standardUserDefaults]setObject:model.hdimg forKey:@"hdimg"];

            //获取token
            [CYNetworkTool post:URL_Token params:@{@"userid":userName,@"name":model.nickname,@"toux":model.hdimg} success:^(id json) {
                
                if ([json[@"state"] isEqualToString:@"1"])
                {
                    NSString *token = json[@"data"] ;
                    [[NSUserDefaults standardUserDefaults]setObject:token forKey:@"token"];

                    //链接融云服务器
                    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
                         [[RCIM sharedRCIM] setUserInfoDataSource:self];
                                 NSLog(@"Login successfully with userId: %@.", userId);
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self gotoProfile];
                                                });
                    } error:^(RCConnectErrorCode status) {
                        NSLog(@"登陆的错误码为:－－-%ld", (long)status);
                    } tokenIncorrect:^{
                        NSLog(@"token 无效 ，请确保生成token 使用的appkey 和初始化时的appkey 一致");
                    }];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD showError:@"获取token失败"];
            }];
        }
        else {
            [MBProgressHUD showError:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常"];
        
    }];
}
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
{
    NSMutableArray * array=[DataPersistenceManager readFriendInfo];
    NSString *userID =[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    NSString *nick =[[NSUserDefaults standardUserDefaults]objectForKey:@"nickname"];
    NSString *imag =[[NSUserDefaults standardUserDefaults]objectForKey:@"hdimg"];
    if ([userID isEqual:userId])
    {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = userID;
        user.name = nick;
        user.portraitUri = [NSString stringWithFormat:@"%@%@",URL_Key,imag];;
        return completion(user);
    }
    else
    {
        
        for (FriendInfoModel * friendModel in array)
        {
            RCUserInfo *user = [[RCUserInfo alloc]init];
            
            if ([friendModel.Friend isEqualToString:userId])
            {
                user.userId = friendModel.Friend;
                user.name = friendModel.nickname;
                user.portraitUri = [NSString stringWithFormat:@"%@%@",URL_Key,friendModel.hdimg];
                return completion(user);
            }
            
        }
        return completion(nil);
    }
    return completion(nil);
}

// 登录按钮事件
- (IBAction)loginAction:(UIButton *)sender {
    
    if (_numTF.text.length < 1) {
        
        [MBProgressHUD showError:@"请输入用户名"];
    }
    else if (_pwdTF.text.length < 1) {
        
        [MBProgressHUD showError:@"请输入密码"];
    }
    else{

        [self loginWithUserName:_numTF.text pwd:_pwdTF.text];
    }
}
// 跳转到找回密码页面
- (IBAction)forgetAction:(UIButton *)sender {

    FindViewController *findVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FindViewController"];
    [self.navigationController pushViewController:findVC animated:YES];
}

// 跳转到个人中心
- (void)gotoProfile {
   
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MainController *mainVC = [[MainController alloc]init];
    window.rootViewController = mainVC;
}




@end
