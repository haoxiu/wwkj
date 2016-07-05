//
//  RecruitmentTableViewCellModeZP.h
//  玩械宝
//
//  Created by huangyangqing on 15/10/22.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecruitmentTableViewCellModeZP : NSObject
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *kind;
@property (strong, nonatomic) NSString *year;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSString *brithday;
@property (strong, nonatomic) NSString *jobback;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *companyName;
@property (strong, nonatomic) NSString *workBack;
@property (strong, nonatomic) NSString *educational;
@property (strong, nonatomic) NSString *salary;
@property (strong, nonatomic) NSString *workPlace;
@property (strong, nonatomic) NSString *jobtype;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *inputtime;
@property (strong, nonatomic) NSString *catid;
@property (strong, nonatomic) NSString *ID;

@property (strong, nonatomic) NSString *colid;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
