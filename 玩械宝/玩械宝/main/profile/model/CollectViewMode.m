//
//  CollectViewMode.m
//  玩械宝
//
//  Created by huangyangqing on 15/10/12.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "CollectViewMode.h"
#import "CollectWithMeTableViewCellMode.h"
#import "DataService.h"

@interface MachineDetailViewController :CollectViewMode

@end
@implementation CollectViewMode


- (instancetype)initWithDict:(NSDictionary *)dict{
    self =[super init];
    if (self) {
        [self setCellH:dict];
    }
    return self;
}

- (void)setCellH:(NSDictionary *)mode{
    
    self.userName =[self setWH:mode[@"nickname"] font:16 contentW:2000.0 contentH:25] +8;
    self.aboutClassLableText =[self setWH:mode[@"version"] font:17 contentW:2000.0 contentH:25] +12;
    self.esayPresent =[self setWH:mode[@"brand"] font:16 contentW:20000 contentH:25] +0;
    if ([mode[@"picture"] isKindOfClass:[NSArray class]]) {
        NSArray *imgArr =mode[@"picture"];
        if ([imgArr[0][@"image"] isEqualToString:@"0"]) {
            self.imgViewF =0;
        }else{
            self.imgViewF =([UIScreen mainScreen].bounds.size.width -(44+8 *3 +6*3))/4.0 +7;
        }
    }
    
    if (![mode[@"description"] isEqualToString:@""]) {
        self.detailPresent =[self setWH:mode[@"description"] font:14 contentW:[UIScreen mainScreen].bounds.size.width -(44 +8 +8) contentH:25] +6;
    }else{
        self.detailPresent =0;
    }
    self.useTime =[self setWH:mode[@"worktime"] font:14 contentW:20000 contentH:25]+4;
  
    float H =self.userName +self.aboutClassLableText +self.esayPresent +self.imgViewF +self.detailPresent +7 +self.useTime+1;
   
    _cellHeight = H;
}

- (float)setWH:(NSString *)string font:(int)font contentW:(float)width contentH:(float)heigth{
    CGSize contentS = [string boundingRectWithSize:
                       CGSizeMake(width,heigth) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size ;
    return contentS.height;
}
@end
