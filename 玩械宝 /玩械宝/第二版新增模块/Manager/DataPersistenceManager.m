//
//  DataPersistenceManager.m
//  netWork
//
//  Created by Alice on 15/8/30.
//  Copyright (c) 2015年 inroids. All rights reserved.
//

#import "DataPersistenceManager.h"
#import "IsolatedStorageFile.h"
#import "SimpleInfoModel.h"

#define kArchiverKey @"ChangeTheKeyCouldNotBeRead"

@implementation DataPersistenceManager

+(void)saveFriendInfo:(NSMutableArray *)friendInfo
{
    if (friendInfo) {
        NSString* filePath=[IsolatedStorageFile friendInfo];
        NSMutableData *data = [NSMutableData data];
        NSKeyedArchiver *keyedArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [keyedArchiver encodeObject:friendInfo forKey:kArchiverKey];
        [keyedArchiver finishEncoding];
        [data writeToFile:filePath atomically:YES];
    }
}

+(NSMutableArray *)readFriendInfo
{
    NSString* filePath=[IsolatedStorageFile friendInfo];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSKeyedUnarchiver *keyedUnArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSMutableArray *tempData = [keyedUnArchiver decodeObjectForKey:kArchiverKey];
    [keyedUnArchiver finishDecoding];
    return tempData;
}

+(void)removeFriendInfo{
    NSString* filePath=[IsolatedStorageFile friendInfo];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}


@end

