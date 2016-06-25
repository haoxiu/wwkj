//
//  CircleFriendsModel.h
//  玩械宝
//
//  Created by wawa on 16/6/16.
//  Copyright © 2016年 zgcainiao. All rights reserved.
//

#import "BaseModel.h"

@interface CircleFriendsModel : BaseModel<NSCoding>


//获取朋友圈
@property (nonatomic, copy) NSString * Id;

@property (nonatomic, copy) NSString * user_id;

@property (nonatomic, copy) NSString * price;

@property (nonatomic, copy) NSString * title;

@property (nonatomic, copy) NSString * content;

@property (nonatomic, copy) NSString * fbtime;

@property (nonatomic, retain) NSMutableArray * images;

@property (nonatomic, copy) NSString * address;

@property (nonatomic, copy) NSString * catid;

@property (nonatomic, copy) NSString * usertime;

@property (nonatomic, copy) NSString * conid;

@property (nonatomic, copy) NSString * remark;

@property (nonatomic, copy) NSString * nickname;

@property (nonatomic, copy) NSString * hdimg;

@property (nonatomic, copy) NSString * sign;
@end
