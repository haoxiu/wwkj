//
//  TableHeadView.h
//  玩械宝
//
//  Created by Stone袁 on 16/3/12.
//  Copyright (c) 2016年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *nickImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
- (IBAction)shareAction:(id)sender;

@end
