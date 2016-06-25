//
//  DiscoveryViewController.h
//  玩械宝
//
//  Created by Stone袁 on 15/12/17.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "BaseViewController.h"

@interface DiscoveryViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
