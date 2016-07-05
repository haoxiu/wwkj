//
//  MachineModel.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/16.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "MachineModel.h"

@implementation MachineModel

- (void)setAttributes:(NSDictionary *)jsonDic {
    [super setAttributes:jsonDic];
    _desc = jsonDic[@"description"];
    _ID = jsonDic[@"id"];

}
@end
