//
//  CircleFriendsModel.m
//  玩械宝
//
//  Created by wawa on 16/6/16.
//  Copyright © 2016年 zgcainiao. All rights reserved.
//

#import "CircleFriendsModel.h"

@implementation CircleFriendsModel
- (void)encodeWithCoder:(NSCoder *)aCoder{
       //获取朋友圈
    if([self.Id length]>0)
        [aCoder encodeObject:self.Id forKey:@"id"];
    if([self.user_id length]>0)
        [aCoder encodeObject:self.user_id forKey:@"user_id"];
    if([self.price length]>0)
        [aCoder encodeObject:self.price forKey:@"price"];
    if([self.title length]>0)
        [aCoder encodeObject:self.title forKey:@"title"];
    if([self.content length]>0)
        [aCoder encodeObject:self.content forKey:@"content"];
    if([self.fbtime length]>0)
        [aCoder encodeObject:self.fbtime forKey:@"fbtime"];
    if(self.images.count>0)
        [aCoder encodeObject:self.images forKey:@"images"];
    if([self.address length]>0)
        [aCoder encodeObject:self.address forKey:@"address"];
    if([self.catid length]>0)
        [aCoder encodeObject:self.catid forKey:@"catid"];
    if([self.usertime length]>0)
        [aCoder encodeObject:self.usertime forKey:@"usertime"];
    if([self.conid length]>0)
        [aCoder encodeObject:self.conid forKey:@"conid"];
    if([self.hdimg length]>0)
        [aCoder encodeObject:self.hdimg forKey:@"hdimg"];
    if([self.nickname length]>0)
        [aCoder encodeObject:self.nickname forKey:@"nickname"];
    if([self.remark length]>0)
        [aCoder encodeObject:self.remark forKey:@"remark"];
    if ([self.sign length]>0)
        [aCoder encodeObject:self.sign forKey:@"sign"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[self init];
    if(self){
        //获取朋友圈
        self.Id=[aDecoder decodeObjectForKey:@"id"];
        self.user_id=[aDecoder decodeObjectForKey:@"user_id"];
        self.price=[aDecoder decodeObjectForKey:@"price"];
        self.title=[aDecoder decodeObjectForKey:@"title"];
        self.content=[aDecoder decodeObjectForKey:@"content"];
        self.fbtime=[aDecoder decodeObjectForKey:@"fbtime"];
        self.images=[aDecoder decodeObjectForKey:@"images"];
        self.address=[aDecoder decodeObjectForKey:@"address"];
        self.catid=[aDecoder decodeObjectForKey:@"catid"];
        self.usertime=[aDecoder decodeObjectForKey:@"usertime"];
        self.conid=[aDecoder decodeObjectForKey:@"conid"];
        self.hdimg=[aDecoder decodeObjectForKey:@"hdimg"];
        self.remark=[aDecoder decodeObjectForKey:@"remark"];
        self.nickname=[aDecoder decodeObjectForKey:@"nickname"];
        self.sign=[aDecoder decodeObjectForKey:@"sign"];
    }
    return self;
}

@end
