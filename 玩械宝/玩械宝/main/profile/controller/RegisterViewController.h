//
//  RegisterViewController.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/12.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
- (IBAction)checkAction:(UIButton *)sender;
- (IBAction)reviewAction:(UIButton *)sender;

- (IBAction)getCode:(UIButton *)sender;
- (IBAction)registerAction:(UIButton *)sender;

@end
