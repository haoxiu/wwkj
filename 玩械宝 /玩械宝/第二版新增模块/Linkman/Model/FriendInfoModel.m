//
//  FriendInfoModel.m
//  玩械宝
//
//  Created by zhangyaping on 16/5/21.
//  Copyright © 2016年 zgcainiao. All rights reserved.
//

#import "FriendInfoModel.h"

@implementation FriendInfoModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    if([self.Id length]>0)
        [aCoder encodeObject:self.Id forKey:@"id"];
    if([self.userid length]>0)
        [aCoder encodeObject:self.userid forKey:@"userid"];
    if([self.Friend length]>0)
        [aCoder encodeObject:self.Friend forKey:@"friend"];
    if([self.Noread length]>0)
        [aCoder encodeObject:self.Noread forKey:@"noread"];
    if([self.remark length]>0)
        [aCoder encodeObject:self.remark forKey:@"remark"];
    if([self.zm length]>0)
        [aCoder encodeObject:self.zm forKey:@"zm"];
    if([self.nickname length]>0)
        [aCoder encodeObject:self.nickname forKey:@"nickname"];
    if([self.sex length]>0)
        [aCoder encodeObject:self.sex forKey:@"sex"];
    if([self.hdimg length]>0)
        [aCoder encodeObject:self.hdimg forKey:@"hdimg"];
    if([self.sign length]>0)
        [aCoder encodeObject:self.sign forKey:@"sign"];
    if([self.username length]>0)
        [aCoder encodeObject:self.username forKey:@"username"];
 }

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[self init];
    if(self){
        self.Id=[aDecoder decodeObjectForKey:@"id"];
        self.hdimg=[aDecoder decodeObjectForKey:@"hdimg"];
        self.nickname=[aDecoder decodeObjectForKey:@"nickname"];
        self.sex=[aDecoder decodeObjectForKey:@"sex"];
        self.zm=[aDecoder decodeObjectForKey:@"zm"];
        self.userid=[aDecoder decodeObjectForKey:@"userid"];
        self.Friend=[aDecoder decodeObjectForKey:@"friend"];
        self.Noread=[aDecoder decodeObjectForKey:@"noread"];
        self.remark=[aDecoder decodeObjectForKey:@"remark"];
        self.sign=[aDecoder decodeObjectForKey:@"sign"];
        self.username=[aDecoder decodeObjectForKey:@"username"];
     }
    return self;
}


@end
