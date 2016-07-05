//
//  DataPersistenceManager.h
//  netWork
//
//  Created by Alice on 15/8/30.
//  Copyright (c) 2015年 inroids. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//数据模型的本地存储

@interface DataPersistenceManager : NSObject

//好友列表本地存储
+(void)saveFriendInfo:(NSMutableArray *)friendInfo;
+(NSMutableArray *)readFriendInfo;
+(void)removeFriendInfo;
@end
