//
//  ZhaoPinModel.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/18.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "ZhaoPinModel.h"

@implementation ZhaoPinModel
- (void)setAttributes:(NSDictionary *)jsonDic {
    [super setAttributes:jsonDic];
    _Id = jsonDic[@"id"];
}
@end
