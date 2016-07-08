//
//  HeadTableViewCell.m
//  玩械宝
//
//  Created by 刘昊 on 16/6/28.
//  Copyright © 2016年 zgcainiao. All rights reserved.
//

#import "HeadTableViewCell.h"
#import "UIView+viewController.h"
#import "MBProgressHUD+NJ.h"
#import <ShareSDK/ShareSDK.h>
@implementation HeadTableViewCell

- (void)awakeFromNib{
    
    
    _userName.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    _nickName.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"nickname"];
//    _nickImg.image = [[NSUserDefaults standardUserDefaults]objectForKey:@"hdimg"];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
