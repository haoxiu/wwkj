//
//  changePwdViewController.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/16.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "changePwdViewController.h"

#import "changePwd.h"

#import "Header.h"
#import "MBProgressHUD+NJ.h"
#import "CYNetworkTool.h"

@interface changePwdViewController ()
{
    UITextField *oldPwd;
    UITextField *newPwd;
    UITextField *againPwd;
}
@end

@implementation changePwdViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改密码";
    [self _loadViews];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = CYBackgroundGrayColor;
    self.navigationController.navigationBarHidden =NO;
}

- (void)_loadViews {
    
    changePwd *cell_1 =[[[NSBundle mainBundle] loadNibNamed:@"changePwd" owner:nil options:nil] firstObject];
    cell_1.frame =CGRectMake(0, 80, self.view.width, 44);
    cell_1.lable.text =@"       原密码";
    cell_1.textField.placeholder =@"请输入原密码";
    cell_1.textField.secureTextEntry =YES;
    
    cell_1.textField.delegate =self;
    cell_1.textField.tag = 1;
    
    oldPwd =cell_1.textField;
    
    changePwd *cell_2 =[[[NSBundle mainBundle] loadNibNamed:@"changePwd" owner:nil options:nil] firstObject];
    cell_2.frame =CGRectMake(0, cell_1.bottom +10, self.view.width, 44);
    cell_2.lable.text =@"       新密码";
    cell_2.textField.placeholder =@"请输入新密码";
    cell_2.textField.secureTextEntry =YES;
    
    cell_2.textField.delegate =self;
    newPwd =cell_2.textField;
    
    changePwd *cell_3 =[[NSBundle mainBundle] loadNibNamed:@"changePwd" owner:nil options:nil][0];
    cell_3.frame =CGRectMake(0, cell_2.bottom +10, self.view.width, 44);
    cell_3.lable.text =@"确认新密码";
    cell_3.textField.placeholder =@"请再次输入新密码";
    cell_3.textField.secureTextEntry =YES;
    cell_3.textField.delegate =self;
    againPwd =cell_3.textField;
 
    UIButton *change = [UIButton buttonWithType:UIButtonTypeCustom];
    change.frame = CGRectMake(50,cell_3.bottom +150, self.view.width-100, 35);
    change.backgroundColor = CYNavColor;
    change.titleLabel.font = [UIFont systemFontOfSize:14];
    [change setTitle:@"确认保存" forState:UIControlStateNormal];
    [change addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:change];
    
    [self.view addSubview:cell_1];
    [self.view addSubview:cell_2];
    [self.view addSubview:cell_3];
    
//    [self.view addSubview:oldPwd];
//    [self.view addSubview:newPwd];
//    [self.view addSubview:againPwd];
}
- (void)changeAction {
    
    if (![againPwd.text isEqualToString:newPwd.text] && againPwd.text.length !=0) {
        
        [MBProgressHUD showError:@"新密码不一致"];
        againPwd.text = @"";
        return;
    }
    else if ([newPwd.text isEqualToString:oldPwd.text]){
        
        [MBProgressHUD showError:@"新密码不能与原密码相同"];
        return;
    }else if (oldPwd.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入原密码"];
        return;
    }
    
    [MBProgressHUD showMessage:@"正在修改"];
    
    NSDictionary *params = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"password":oldPwd.text,@"newpassword":newPwd.text};
    
    [CYNetworkTool post:URL_ChangePwd params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        
        if ([json[@"state"] isEqualToNumber:@101]) {
            
            [MBProgressHUD showError:@"修改失败"];
            newPwd.text = @"";
            againPwd.text = @"";
        }
        else {
            
            [MBProgressHUD showSuccess:@"修改成功"];
            newPwd.text = @"";
            againPwd.text = @"";
            oldPwd.text = @"";
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showError:@"网络异常"];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 1) {
        if (! [[[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"] isEqualToString:oldPwd.text])
        {
            [MBProgressHUD showError:@"原密码错误"];
            oldPwd.text = @"";
            [textField becomeFirstResponder];
            return;
        }
    }else if (![textField.text isEqualToString:newPwd.text] && textField.text.length !=0) {
        
        [MBProgressHUD showError:@"新密码输入不一致"];
        textField.text = @"";
        [textField becomeFirstResponder];
        
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUD];
}

@end
