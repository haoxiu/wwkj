//
//  MyHomeMachineViewController.h
//  玩械宝
//
//  Created by echo on 11/11/15.
//  Copyright (c) 2015 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDB.h"
@interface MyHomeMachineViewController : UIViewController

/**12求租  14出租  13卖车  9买车*/
@property(nonatomic,copy)NSString *type;

/**12求租  14出租  13卖车  9买车*/
@property(nonatomic,copy)NSString *catid;

@property(nonatomic,strong)NSArray *titles;

@property(nonatomic,strong)NSMutableArray *datas;
@property(nonatomic,copy)NSString *name;        // 选项名
@property(nonatomic,assign)NSInteger index;     // 头部视图按钮索引
@property (nonatomic, strong) NSString *mainClass;
@property (nonatomic,strong) NSString *ID;
@property (nonatomic, strong) FMDatabase *db;


@end
