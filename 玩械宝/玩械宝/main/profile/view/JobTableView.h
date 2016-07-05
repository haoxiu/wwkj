//
//  JobTableView.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/17.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeModel.h"
@interface JobTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *models;
@property(nonatomic,copy)NSString *type;
@end
