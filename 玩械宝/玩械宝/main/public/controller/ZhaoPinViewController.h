//
//  ZhaoPinViewController.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/19.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "BaseViewController.h"
#import "RecruitmentTableViewCellMode.h"

@interface ZhaoPinViewController : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (weak, nonatomic) IBOutlet UIView *mianView;

@property (weak, nonatomic) IBOutlet UITextField *companyName;
@property (weak, nonatomic) IBOutlet UILabel *expL;
@property (weak, nonatomic) IBOutlet UIButton *expBtn;
@property (weak, nonatomic) IBOutlet UILabel *educationL;
@property (weak, nonatomic) IBOutlet UIButton *educationBtn;
@property (weak, nonatomic) IBOutlet UITextField *development;
@property (weak, nonatomic) IBOutlet UILabel *workplaceL;
@property (weak, nonatomic) IBOutlet UIButton *workplaceBtn;
@property (weak, nonatomic) IBOutlet UITextField *position;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *publicBtn;
@property (strong, nonatomic) RecruitmentTableViewCellMode *mode;
@property (nonatomic) BOOL isPush;
- (IBAction)publishAction:(UIButton *)sender;


@end
