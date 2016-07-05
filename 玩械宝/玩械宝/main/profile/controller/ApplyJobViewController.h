//
//  ApplyJobViewController.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/18.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "BaseViewController.h"
#import "ZhaoPinModel.h"
#import "RecruitmentTableViewCellMode.h"

@interface ApplyJobViewController : BaseViewController

- (IBAction)showUserAction:(UIButton *)sender;
- (IBAction)callAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *miaoshu;
@property (weak, nonatomic) IBOutlet UILabel *companyname;
@property (weak, nonatomic) IBOutlet UILabel *workback;
@property (weak, nonatomic) IBOutlet UILabel *educational;
@property (weak, nonatomic) IBOutlet UILabel *salary;
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UILabel *jobtype;

@property(nonatomic,copy)NSString *type;
@property(nonatomic,strong)RecruitmentTableViewCellMode *model;

@property (assign,nonatomic) BOOL shouldHide;

@property (assign,nonatomic) BOOL isFromCollect;


@end
