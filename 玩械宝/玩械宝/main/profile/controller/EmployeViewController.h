//
//  EmployeViewController.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/18.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "BaseViewController.h"
#import "EmployeModel.h"
#import "RecruitmentTableViewCellModeZP.h"

@interface EmployeViewController : BaseViewController

@property(nonatomic, copy) NSString *type;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *briday;
@property (weak, nonatomic) IBOutlet UILabel *jobback;
@property (weak, nonatomic) IBOutlet UILabel *education;
@property (weak, nonatomic) IBOutlet UILabel *salary;
@property (weak, nonatomic) IBOutlet UILabel *workplace;
@property (weak, nonatomic) IBOutlet UILabel *jobtype;
- (IBAction)showUserAction:(UIButton *)sender;
- (IBAction)callAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *miaoshu;
@property(nonatomic,strong)RecruitmentTableViewCellModeZP *mode;

@property (assign,nonatomic) BOOL shouldHide;

@property (assign,nonatomic) BOOL isFromCollect;

@property (assign,nonatomic) int colid;
@end
