//
//  machineCell.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/26.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MachineModel.h"
@interface machineCell : UITableViewCell
@property(nonatomic,strong)MachineModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *brandLable;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *inputtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property(nonatomic,assign)BOOL hideSth;
@end
