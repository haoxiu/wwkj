//
//  EmployeModel.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/17.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "BaseModel.h"

@interface EmployeModel : BaseModel
@property(nonatomic,copy)NSString *jobtype; // 职位类别
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *workplace;
@property(nonatomic,copy)NSString *inputtime;   // 发布日期
@property(nonatomic,copy)NSString *household;
@property(nonatomic,copy)NSString *salary;
@property(nonatomic,copy)NSString *title;   // 职务
@property(nonatomic,copy)NSString *birthday;
@property(nonatomic,copy)NSString *educational;
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *hytype;  //行业类别
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,copy)NSString *jobback;// 工作经验
@property(nonatomic,copy)NSString *Id;
@end
