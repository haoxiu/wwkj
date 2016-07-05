//
//  IsolatedStorageFile.m
//  netWork
//
//  Created by Alice on 15/8/30.
//  Copyright (c) 2015年 inroids. All rights reserved.
//

#import "IsolatedStorageFile.h"
//#import "DataCenter.h"
//#import "AccountModel.h"

@implementation IsolatedStorageFile

+(NSString *)mainPath{
    NSString* root=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    root=[root stringByAppendingPathComponent:@"WWKJ"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:root]){
        [[NSFileManager defaultManager] createDirectoryAtPath:root withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return root;
}

+(NSString *)currentAccountDirectory{
    return [self getAccountDirectory:@""];
}

+ (NSString *)getAccountDirectory:(NSString*)accountName {
    NSString* root=[self mainPath];
    if([accountName length]>0){
        root=[root stringByAppendingPathComponent:accountName];
        if(![[NSFileManager defaultManager] fileExistsAtPath:root]){
            [[NSFileManager defaultManager] createDirectoryAtPath:root withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return root;
}

+(NSString *)friendInfo
{
    return [[self mainPath] stringByAppendingPathComponent:@"friendInfo.dat"];
}


@end
