//
//  FindViewController.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/13.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "BaseViewController.h"

@interface FindViewController : BaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *findBtn;
- (IBAction)getCode:(UIButton *)sender;
- (IBAction)findAction:(UIButton *)sender;

@end
