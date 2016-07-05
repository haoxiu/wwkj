//
//  LinkManCell.h
//  玩械宝
//
//  Created by wawa on 16/5/11.
//  Copyright © 2016年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendInfoModel;

@interface LinkManCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (nonatomic,strong) FriendInfoModel * model;

@end
