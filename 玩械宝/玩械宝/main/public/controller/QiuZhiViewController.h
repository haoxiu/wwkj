//
//  QiuZhiViewController.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/19.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "BaseViewController.h"
#import "RecruitmentTableViewCellModeZP.h"

@interface QiuZhiViewController : BaseViewController<UITextFieldDelegate>

//@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
- (IBAction)birthdayAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *publishBtn;
- (IBAction)publishAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UILabel *sexL;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UILabel *yearL;
@property (weak, nonatomic) IBOutlet UIButton *yearBtn;   //年龄选择器
@property (weak, nonatomic) IBOutlet UILabel *workbackL;
@property (weak, nonatomic) IBOutlet UIButton *workbackBtn;
@property (weak, nonatomic) IBOutlet UILabel *xueliL;
@property (weak, nonatomic) IBOutlet UIButton *xueliBtn;
@property (weak, nonatomic) IBOutlet UITextField *qiwang;
@property (weak, nonatomic) IBOutlet UILabel *placeL;
@property (weak, nonatomic) IBOutlet UIButton *placeBtn;  //地点的选择器
@property (weak, nonatomic) IBOutlet UITextField *classT;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) RecruitmentTableViewCellModeZP *mode;
@property (nonatomic) BOOL isPush;

@end
