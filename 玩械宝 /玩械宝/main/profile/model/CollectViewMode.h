//
//  CollectViewMode.h
//  玩械宝
//
//  Created by huangyangqing on 15/10/12.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectViewMode : NSObject

@property (nonatomic) float userName;
@property (nonatomic) float aboutClassLableText;
@property (nonatomic) float esayPresent;
@property (nonatomic) float imgViewF;
@property (nonatomic) float detailPresent;
@property (nonatomic) float useTime;

@property (nonatomic) float cellHeight;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
