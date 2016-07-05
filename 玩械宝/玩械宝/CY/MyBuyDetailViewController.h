//
//  MyBuyDetailViewController.h
//  玩械宝
//
//  Created by echo on 11/18/15.
//  Copyright (c) 2015 zgcainiao. All rights reserved.
//

//求租、买车

#import <UIKit/UIKit.h>
#import "CollectWithMeTableViewCellMode.h"

@interface MyBuyDetailViewController : UIViewController

@property (strong,nonatomic) CollectWithMeTableViewCellMode *mode;
@property (strong,nonatomic) NSString *type;
@property (assign,nonatomic) NSInteger cellRow;
@property (strong,nonatomic) NSMutableArray *SCarray;
@property (assign,nonatomic) BOOL shouldHide;

@property (assign,nonatomic) BOOL isFromCollect;

@end
