//
//  DataCenter.m
//  GangGangHao
//
//  Created by Alice on 15/9/3.
//  Copyright (c) 2015年 inroids. All rights reserved.
//

#import "DataCenter.h"

@implementation DataCenter

+ (instancetype)defaultCenter
{
    static DataCenter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataCenter alloc] init];
    });
    return sharedInstance;
}


@end
