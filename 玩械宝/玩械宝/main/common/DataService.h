//
//  DataService.h
//
//  Created by  on 15-4-13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

@interface DataService : NSObject
+ (AFHTTPRequestOperation *)requestURL:(NSString *)urlString
        httpMethod:(NSString *)method
            params:(NSDictionary *)params
        completion:(void(^)(id result))block;

+ (AFHTTPRequestOperation *)requestURL:(NSString *)urlString
        httpMethod:(NSString *)method
            params:(NSDictionary *)params
          fileData:(NSData *)data
        completion:(void(^)(id result))block;
@end
