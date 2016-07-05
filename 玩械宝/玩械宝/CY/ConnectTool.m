//
//  ConnectTool.m
//  玩械宝
//
//  Created by echo on 11/5/15.
//  Copyright (c) 2015 zgcainiao. All rights reserved.
//

#import "ConnectTool.h"

@implementation ConnectTool

- (void)callPhone:(NSString *)phoneNumber{
    
    //number为号码字符串 如果使用这个方法 结束电话之后会进入联系人列表
    NSString *num = [[NSString alloc] initWithFormat:@"tel://%@", phoneNumber];
    //拨号
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
}

@end
