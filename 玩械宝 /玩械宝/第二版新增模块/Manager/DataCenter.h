//
//  DataCenter.h
//  GangGangHao
//
//  Created by Alice on 15/9/3.
//  Copyright (c) 2015年 inroids. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleInfoModel.h"
#import "DetailInfoModel.h"


@interface DataCenter : NSObject

+ (instancetype)defaultCenter;

//登录的帐号信息
@property (nonatomic, strong) SimpleInfoModel * account;

@property (nonatomic, strong) DetailInfoModel * detailModel;

@end
