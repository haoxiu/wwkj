//
//  ZhaoPinTableView.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/18.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhaoPinModel.h"
@interface ZhaoPinTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy)NSString *type;
@property(nonatomic,strong)NSMutableArray *models;
@end
