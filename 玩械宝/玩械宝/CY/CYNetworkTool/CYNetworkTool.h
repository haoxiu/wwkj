//
//  CYNetworkTool.h
//  玩械宝
//
//  Created by echo on 11/8/15.
//  Copyright (c) 2015 zgcainiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYNetworkTool : NSObject

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
@end

