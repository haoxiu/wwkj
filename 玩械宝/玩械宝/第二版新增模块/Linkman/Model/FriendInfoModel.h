//
//  FriendInfoModel.h
//  玩械宝
//
//  Created by zhangyaping on 16/5/21.
//  Copyright © 2016年 zgcainiao. All rights reserved.
//

#import "BaseModel.h"

@interface FriendInfoModel : BaseModel<NSCoding>

@property (nonatomic, copy) NSString * Id;

@property (nonatomic, copy) NSString * userid;

@property (nonatomic, copy) NSString * Friend;

@property (nonatomic, copy) NSString * Noread;

@property (nonatomic, copy) NSString * remark;

@property (nonatomic, copy) NSString * zm;

@property (nonatomic, copy) NSString * nickname;

@property (nonatomic, copy) NSString * sex;

@property (nonatomic, copy) NSString * hdimg;

@property (nonatomic, copy) NSString * sign;

@property (nonatomic, copy) NSString * username;

@end
