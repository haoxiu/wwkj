//
//  Message.h
//  玩械宝
//
//  Created by Stone袁 on 15/12/17.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <Foundation/Foundation.h>

//Message 类就是用来存储聊天信息的
@interface Message : NSObject


@property (nonatomic,copy)NSString *content; //用来存储聊天信息
@property (nonatomic,copy)NSString *icon; //用户头像
@property (nonatomic,copy)NSString *time; //时间
@property (nonatomic,assign)BOOL isSelf;

@end
