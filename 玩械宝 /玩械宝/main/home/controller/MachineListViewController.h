//
//  MachineListViewController.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/26.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "BaseViewController.h"
#import "MachineModel.h"
#import "machineCell.h"

@interface MachineListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,copy)NSString *type;        // 机器类型
@property(nonatomic,copy)NSString *catid;
@property(nonatomic,strong)NSArray *titles;
@property(nonatomic,strong)NSMutableArray *datas;
@property(nonatomic,copy)NSString *name;        // 选项名
@property(nonatomic,assign)NSInteger index;     // 头部视图按钮索引
@property (nonatomic, strong) NSString *mainClass;
@property (nonatomic,strong) NSString *ID;
@end
