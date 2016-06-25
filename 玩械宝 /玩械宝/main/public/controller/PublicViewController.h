//
//  PublicViewController.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/11.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "BaseViewController.h"

@interface PublicViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
