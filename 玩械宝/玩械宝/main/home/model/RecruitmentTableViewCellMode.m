//
//  RecruitmentTableViewCellMode.m
//  玩械宝
//
//  Created by huangyangqing on 15/10/21.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "RecruitmentTableViewCellMode.h"

@implementation RecruitmentTableViewCellMode

- (instancetype)initWithDict:(NSDictionary *)dict{
    self =[super init];
    if (self) {
        self.address =dict[@"place"];
        self.year =dict[@"workback"];
        self.kind =dict[@"jobtype"];
        
        self.catid =dict[@"catid"];
        self.userName =dict[@"username"];
        self.icon =dict[@"hdimg"];
        self.nickName =dict[@"nickname"];
        self.companyName =dict[@"companyname"];
        self.workBack = dict[@"workback"];
        self.educational =dict[@"educational"];
        self.salary =dict[@"salary"];
        self.place =dict[@"place"];
        self.jobtype =dict[@"jobtype"];
        self.phone =dict[@"phone"];
        self.content =dict[@"content"];
        self.ID =dict[@"id"];
        self.inputtime =dict[@"inputtime"];
        self.colid =dict[@"colid"];
    }
    return self;
}
@end
