//
//  MessageCell.h
//  玩械宝
//
//  Created by Stone袁 on 15/12/17.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Message;
//自定义的视图 1.显示聊天信息
// 2.创建子视图

@interface MessageCell : UITableViewCell{

    
    UIImageView *_bgImage; //背景视图
    UIImageView *userimage; //用户头像
    UILabel *_lable; //聊天信息
    
    
}

@property (nonatomic,retain)Message *message;

@end
