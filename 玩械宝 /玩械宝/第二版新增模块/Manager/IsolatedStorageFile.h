//
//  IsolatedStorageFile.h
//  netWork
//
//  Created by Alice on 15/8/30.
//  Copyright (c) 2015年 inroids. All rights reserved.
//

#import <Foundation/Foundation.h>

//用户隔离目录操作类，
//管理整个应用程序文件生成，目录管理
@interface IsolatedStorageFile : NSObject

//主要路径
+(NSString *)mainPath;
//获取当前帐号的隔离目录
+(NSString*)currentAccountDirectory;

// 获取指定账号的隔离目录
+(NSString*)getAccountDirectory:(NSString*)accountName;

//登录信息路径
+(NSString *)friendInfo;

@end
