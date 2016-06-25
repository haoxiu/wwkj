//
//  AppDelegate.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/11.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleInfoModel.h"

//融云即时通讯
#import<RongIMKit/RongIMKit.h>
#import<RongIMLib/RongIMLib.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,RCIMConnectionStatusDelegate,RCIMUserInfoDataSource>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)SimpleInfoModel *model;
@property (nonatomic, copy) NSString * token;

@end

