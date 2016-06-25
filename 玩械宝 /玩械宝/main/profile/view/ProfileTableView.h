//
//  ProfileTableView.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/16.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MachineModel.h"

@interface ProfileTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *models;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *type1;
@end
