//
//  SimpleInfoModel.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/13.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "BaseModel.h"

@interface SimpleInfoModel : BaseModel
///头像
@property(nonatomic,copy)NSString *hdimg;
///昵称
@property(nonatomic,copy)NSString *nickname;
///性别
@property(nonatomic,copy)NSString *sex;
///个性签名
@property(nonatomic,copy)NSString *sign;
///用户名
@property(nonatomic,copy)NSString *username;

@end
