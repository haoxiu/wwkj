//
//  FindViewController.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/13.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "FindViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "Header.h"
#import "CYNetworkTool.h"
#import "MBProgressHUD+NJ.h"

@interface FindViewController (){
    int n;
    NSTimer *_timer;
}

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    [self _loadViews];
}

// 加载子视图
- (void)_loadViews {
    _pwdTF.delegate = self;
    _codeTF.keyboardType = UIKeyboardTypeNumberPad;
    _mobileTF.delegate = self;
    _mobileTF.keyboardType = UIKeyboardTypeNumberPad;
    // 分享按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(50, 0, 40, 30);
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = item;
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
                                    // NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    [MBProgressHUD showError:[error errorDescription]];
                                }
                            }];
    
}

// 获取验证码
- (IBAction)getCode:(UIButton *)sender {
    
    
    if ([self isValidateMobile: _mobileTF.text]) {
        n = 60;
        sender.enabled = NO;
        
        MBProgressHUD *hd = [MBProgressHUD showMessage:@"正在发送"];
        hd.dimBackground = NO;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:sender repeats:YES];
        NSDictionary *params = @{@"mobile":_mobileTF.text};
        
        [CYNetworkTool post:URL_GetMsm params:params success:^(id json) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"验证码已发送"];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"网络异常"];
        }];

    }
    else if(_mobileTF.text.length == 0){
        
        [MBProgressHUD showError:@"请输入手机号码"];
    }
    else {
        [MBProgressHUD showError:@"手机号码无效"];
    }
}

// 定时器事件
- (void)timeAction:(NSTimer *)timer {
    UIButton *button =  (UIButton *)timer.userInfo;
    if (n != 0) {
        
        n--;
        
        [button setTitle:[NSString stringWithFormat:@"%ds后重新发送",n] forState:UIControlStateNormal];
    }
    else {
        [_timer invalidate];
        _timer = nil;
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        button.enabled = YES;
    }
}

// 找回密码
- (IBAction)findAction:(UIButton *)sender {

    if (_mobileTF.text.length == 0) {
        
        [MBProgressHUD showError:@"请填写手机号"];
        return;
        
    }
    else if (_codeTF.text.length == 0) {
        
        [MBProgressHUD showError:@"请填写验证码"];
        return;
    }
    else if(_pwdTF.text.length == 0) {
        
        [MBProgressHUD showError:@"请输入修改后的密码"];
        return;
    }
    NSDictionary *params = @{@"username":_mobileTF.text,@"code":_codeTF.text,@"password":_pwdTF.text};
    
    [CYNetworkTool post:URL_FindPw params:params success:^(id json) {
        if ([json[@"state"] isEqualToNumber:@101]) {
            
            [MBProgressHUD showError:@"找回失败"];
            
        }
        else {
            
            [MBProgressHUD showSuccess:@"找回成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:@"网络异常"];
    }];
}

#pragma mark - UITextField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == _mobileTF) {
        
        if (![self isValidateMobile:textField.text] && textField.text.length != 0) {
            
            [MBProgressHUD showError:@"手机号码无效，请重新填写"];
            textField.text = @"";
        }
    }
    else if(textField == _pwdTF && textField.text.length != 0) {
        
        if (textField.text.length <6) {
            
            [MBProgressHUD showError:@"密码过短"];
        }
        else if(textField.text.length >10) {
            [MBProgressHUD showError:@"密码过长"];
        }
    }
}

// 判断手机号是否合法
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

@end
