//
//  BuyCarViewController.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/23.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "BaseViewController.h"

@interface BuyCarViewController : BaseViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *brandBtn;
- (IBAction)brandAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *brandL;
@property (weak, nonatomic) IBOutlet UITextField *modelTF;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
- (IBAction)typeAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
//@property (weak, nonatomic) IBOutlet UITextField *hoursTF;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
- (IBAction)locationAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *locationL;

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel1;
@property (weak, nonatomic) IBOutlet UITextView *textView_1;


@property (weak, nonatomic) IBOutlet UITextField *contactTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;
- (IBAction)publishAction:(UIButton *)sender;
@property(nonatomic,assign)BOOL isBuyCar;


@end
