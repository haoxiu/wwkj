//
//  RecruitmentTableViewCellMode.h
//  玩械宝
//
//  Created by huangyangqing on 15/10/21.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecruitmentTableViewCellMode : NSObject
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *kind;
@property (strong, nonatomic) NSString *year;

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *companyName;
@property (strong, nonatomic) NSString *workBack;
@property (strong, nonatomic) NSString *educational;
@property (strong, nonatomic) NSString *salary;
@property (strong, nonatomic) NSString *place;
@property (strong, nonatomic) NSString *jobtype;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *inputtime;
@property (strong, nonatomic) NSString *catid;
@property (strong, nonatomic) NSString * ID;
@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *colid;
//        Catid                          栏目编号（同时也是父级id）
//        Username                         账号
//        Hdimg                         头像
//        Nickname                      昵称
//        Companyname                 公司名称
//        Workback                      工作经验
//        Educational                    学历
//        Salary                        薪资待遇
//        Place                         工作地点
//        jobtype                          职位
//        Phone                         电话
//        Content                        职位描述
//        Id                             id号
//        Inputtime                      修改日期

- (instancetype)initWithDict: (NSDictionary *)dict;
@end
