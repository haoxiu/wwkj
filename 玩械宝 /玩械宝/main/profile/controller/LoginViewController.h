//
//  ProfileViewController.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/11.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "BaseViewController.h"
#import<RongIMKit/RongIMKit.h>

@interface LoginViewController : BaseViewController<RCIMUserInfoDataSource>
@property (strong, nonatomic) IBOutlet UIView *numView;
@property (strong, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITextField *numTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginAction:(UIButton *)sender;
- (void)loginWithUserName:(NSString *)userName pwd:(NSString *)pwd;
- (IBAction)forgetAction:(UIButton *)sender;

@end
