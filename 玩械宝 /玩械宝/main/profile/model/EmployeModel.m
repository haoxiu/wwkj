//
//  EmployeModel.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/17.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "EmployeModel.h"

@implementation EmployeModel

- (void)setAttributes:(NSDictionary *)jsonDic {
    [super setAttributes:jsonDic];
    
    _birthday= jsonDic[@"brithday"];
    _Id = jsonDic[@"id"];
}
@end
