//
//  RecruitmentTableViewCellModeZP.m
//  玩械宝
//
//  Created by huangyangqing on 15/10/22.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "RecruitmentTableViewCellModeZP.h"

@implementation RecruitmentTableViewCellModeZP

- (instancetype)initWithDict:(NSDictionary *)dict{
    self =[super init];
    if (self) {
        self.address =dict[@"workplace"];
        self.year =dict[@"jobback"];
        self.kind =dict[@"jobtype"];
        
        self.name =dict[@"name"];
        self.sex =dict[@"sex"];
        self.brithday =dict[@"brithday"];
        self.catid =dict[@"catid"];
        self.userName =dict[@"username"];
        self.icon =dict[@"hdimg"];
        self.nickName =dict[@"nickname"];
        self.companyName =dict[@"companyname"];
        self.workBack = dict[@"workBack"];
        self.educational =dict[@"educational"];
        
        self.salary =dict[@"salary"];
        NSLog(@"%@=======",self.salary);
        self.workPlace =dict[@"place"];
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
