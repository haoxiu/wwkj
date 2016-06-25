//
//  RegisterViewController.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/12.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "RegisterViewController.h"
#import <ShareSDK/ShareSDK.h>

#import "Header.h"
#import "CYNetworkTool.h"
#import "MBProgressHUD+NJ.h"

@interface RegisterViewController (){
    
    NSTimer *_timer;
    int n;
}

@end

@implementation RegisterViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBarHidden =NO;
    self.title = @"注册";
    [self _loadViews];
}

- (void)_loadViews {
    _pwdTF.delegate = self;
    _mobileTF.delegate = self;
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(50, 0, 40, 30);
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = item;
    // 勾选按钮
    [_checkBtn setImage:[UIImage imageNamed:@"choose_button02.png"] forState:UIControlStateSelected];
//    [_checkBtn setImage:[UIImage imageNamed:@"checkbox_true"] forState:UIControlStateNormal];
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
 - (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)reviewAction:(UIButton *)sender {
    
    UIViewController *protocolVC = [[UIViewController alloc]init];
    protocolVC.hidesBottomBarWhenPushed = YES;
    protocolVC.title = @"协议条款";
    UITextView *tv = [[UITextView alloc]initWithFrame:protocolVC.view.bounds];
    tv.font = [UIFont systemFontOfSize:15];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"挖机注册协议.txt" ofType:nil];
    NSString *text = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    tv.text = text;
    tv.editable = NO;
    [protocolVC.view addSubview:tv];
    [self.navigationController pushViewController:protocolVC animated:YES];
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
            
            if ([json[@"state"] isEqualToNumber:@1]) {
                [MBProgressHUD showSuccess:@"发送成功"];
            }
            else {
                [MBProgressHUD showError:@"发送失败"];
            }
        } failure:^(NSError *error) {
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"网络异常"];
        }];
    }
    else if(_mobileTF.text.length == 0){
        [MBProgressHUD showError:@"请输入手机号码"];
    }
    else {
        [MBProgressHUD showError:@"请输入手机号码"];
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
// 判断手机号是否合法
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

// 注册事件
- (IBAction)registerAction:(UIButton *)sender {
    //_userNameTF为用户名
    if (/*_userNameTF.text.length == 0 ||*/_pwdTF.text.length == 0 || _codeTF.text.length == 0 || _mobileTF.text.length == 0) {
        [MBProgressHUD showError:@"请将信息填充完整"];
    }
    else if (_checkBtn.selected) {
        [MBProgressHUD showError:@"请同意协议条款"];
    }
    else {
        NSDictionary *params = @{@"username":_mobileTF.text,@"password":_pwdTF.text,@"nickname":_mobileTF.text,@"code":_codeTF.text};
        
        [CYNetworkTool post:URL_Regin params:params success:^(id json) {
            NSString *msg = json[@"msg"];
            NSNumber *state = json[@"state"];
            if ([state isEqualToNumber:@101]) {
                if (msg == nil) {
                    [MBProgressHUD showError:@"注册失败"];
                }
                else
                {
                    [MBProgressHUD showError:msg];
                }
            }
            else {
                [MBProgressHUD showSuccess:msg];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"网络异常"];
        }];
    }
}

#pragma mark - UITextField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _mobileTF) {
        if (![self isValidateMobile:textField.text] && textField.text.length != 0) {
            [MBProgressHUD showError:@"手机号码无效，请重新填写"];
            [textField becomeFirstResponder];
        }
    }
    else if(textField == _pwdTF && textField.text.length != 0) {
        if (textField.text.length <6) {
            [MBProgressHUD showError:@"密码太短了哦"];
        }
    }
}

@end
