//
//  DataService.m
//
//  Created by  on 15-4-13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "DataService.h"
#import "AFNetworking.h"
#define BASE_URL @"https://api.weibo.com/2/"
@implementation DataService

+ (AFHTTPRequestOperation *)requestURL:(NSString *)urlString
                            httpMethod:(NSString *)method
                                params:(NSDictionary *)params
                            completion:(void(^)(id result))block {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation = nil;
    
    // GET请求
    if ([method isEqualToString:@"GET"]) {
        
        operation = [manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // 回调block
            if (block != nil) {
                block(responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // 错误提示
            NSLog(@"网络请求失败：%@",error);
        }];
    }
    // POST请求
    else if ([method isEqualToString:@"POST"]){
        
               // 无图片，音频、视频
            operation = [manager POST: urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                // 回调block
                if (block != nil) {
                    
                    block(responseObject);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"网络请求失败：%@",error);
            }];
        }
        
    return operation;
    

}

+ (AFHTTPRequestOperation *)requestURL:(NSString *)urlString
        httpMethod:(NSString *)method
            params:(NSDictionary *)params
          fileData:(NSData *)data
        completion:(void(^)(id result))block {
    
    
    //取出本地保存的认证信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    NSString *token = sinaweiboInfo[@"AccessTokenKey"];
    NSMutableDictionary *mutableParams = [params mutableCopy];
    [mutableParams setObject:token forKey:@"access_token"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *url = [BASE_URL stringByAppendingString:urlString];
    
    AFHTTPRequestOperation *operation = [manager POST:url parameters:mutableParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:data
                                            name:@"pic"
                                        fileName:@"rich.jpg"
                                        mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 回调block
        if (block != nil) {
            
            block(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"网络请求失败：%@",error);
    }];

    return operation;
}
@end
