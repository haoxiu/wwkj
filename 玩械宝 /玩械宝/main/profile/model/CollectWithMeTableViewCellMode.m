//
//  CollectWithMeTableViewCellMode.m
//  玩械宝
//
//  Created by huangyangqing on 15/10/17.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "CollectWithMeTableViewCellMode.h"


@implementation CollectWithMeTableViewCellMode

- (instancetype)initWithDict:(NSDictionary *)mode{
    self =[super init];
    if (self) {
        [self loadDada:mode];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.cartype forKey:@"cartype"];
    [encoder encodeObject:self.ID forKey:@"id"];
    
}


- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.cartype = [decoder decodeObjectForKey:@"cartype"];
        self.ID = [decoder decodeObjectForKey:@"id"];
    }
    return self;
}

- (void)loadDada:(NSDictionary *)mode{
    self.icon =mode[@"hdimg"];
    self.userName =mode[@"nickname"];
    self.aboutClassLableText =mode[@"version"];
    self.esayPresent =mode[@"brand"];
    self.cartype =mode[@"cartype"];
    self.useTime =mode[@"worktime"];
    self.mapText =mode[@"place"];
    self.madetime =mode[@"madetime"];
    self.price =mode[@"price"];
    self.conditions =mode[@"conditions"];
    self.application =mode[@"application"];
    self.conditions =mode[@"contacts"];
    self.phone =mode[@"phone"];
    self.ID =mode[@"id"];
    self.colid =mode[@"colid"];
    self.time =mode[@"inputtime"];
    self.images =mode[@"picture"];
    self.detailPresent =mode[@"description"];
    self.type =mode[@"type"];
    self.parentid = mode[@"parentid"];
    self.phoneName =mode[@"username"];
    
}












@end
