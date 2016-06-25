//
//  CircleFriendsViewControllerCell.h
//  玩械宝
//
//  Created by wawa on 16/6/13.
//  Copyright © 2016年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CircleFriendsModel;
@interface CircleFriendsViewControllerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowTime;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic,strong) CircleFriendsModel * model;
@end
