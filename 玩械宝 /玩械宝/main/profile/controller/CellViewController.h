//
//  CellViewController.h
//  玩械宝
//
//  Created by huangyangqing on 15/9/30.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectWithMeTableViewCellMode.h"

@interface CellViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (weak, nonatomic) IBOutlet UILabel *MachineName;
@property (weak, nonatomic) IBOutlet UIButton *share;
- (IBAction)show:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *inputtime;
@property (weak, nonatomic) IBOutlet UILabel *brand;
@property (weak, nonatomic) IBOutlet UILabel *conditions;
@property (weak, nonatomic) IBOutlet UILabel *madetime;
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UILabel *application;

@property (weak, nonatomic) IBOutlet UILabel *descriptionS;
@property (weak, nonatomic) IBOutlet UILabel *hours;

@property (weak, nonatomic) IBOutlet UILabel *publicTime;

@property (weak, nonatomic) IBOutlet UILabel *mongy;


@property (strong,nonatomic) NSIndexPath *indexPath;
@property (strong,nonatomic) CollectWithMeTableViewCellMode *mode;
@property (strong,nonatomic) NSString *type;
@property (assign,nonatomic) NSInteger cellRow;
@property (strong,nonatomic) NSMutableArray *SCarray;
@property (assign,nonatomic) BOOL shouldHide;

@property (assign,nonatomic) BOOL isFromCollect;

@property (nonatomic, assign) NSInteger *indexRow;


@end
