//
//  CYNetworkTool.m
//  玩械宝
//
//  Created by echo on 11/8/15.
//  Copyright (c) 2015 zgcainiao. All rights reserved.
//

#import "CYNetworkTool.h"
#import "AFNetworking.h"

@implementation CYNetworkTool

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/*

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{

    //
    NSURL *baseURRL = [NSURL URLWithString:url];
    
    AFHTTPSessionManager *sessiomanger = [[AFHTTPSessionManager manager]initWithBaseURL:baseURRL];
    
    sessiomanger.requestSerializer = [AFJSONRequestSerializer serializer];
    sessiomanger.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [sessiomanger.requestSerializer setTimeoutInterval:10];
    
    //发送请求
    [sessiomanger POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (success) {
            
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            
            failure(error);
        }
        
    }];


}
*/


+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end

