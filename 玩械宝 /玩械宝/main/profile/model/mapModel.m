//
//  mapModel.m
//  玩械宝
//
//  Created by huangyangqing on 15/10/8.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "mapModel.h"

@implementation mapModel

- (instancetype)init{
    self =[super init];
    if (self) {
        [self loadDates];
    }
    return self;
}

- (void)loadDates{
    NSString *plistPath =[[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
    NSDictionary *dict =[NSDictionary dictionaryWithContentsOfFile:plistPath];
    _provinceArray =[NSArray arrayWithArray:dict[@"address"]];
    
}
@end
