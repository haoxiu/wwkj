//
//  MachineModel.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/16.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "BaseModel.h"

@interface MachineModel : BaseModel
@property(nonatomic,copy)NSString *conditions;// 车况
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *brand;// 品牌
@property(nonatomic,copy)NSString *cartype;
@property(nonatomic,copy)NSString *contacts;
@property(nonatomic,copy)NSString *application;// 用途
@property(nonatomic,copy)NSString *desc;
@property(nonatomic,copy)NSString *version;
@property(nonatomic,copy)NSString *place;
@property(nonatomic,copy)NSString *inputtime;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *worktime;
@property(nonatomic,copy)NSString *madetime;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,strong)NSArray *picture;
@property(nonatomic,copy)NSString *colid;
@end
