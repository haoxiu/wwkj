//
//  FlexBile.m
//  挖挖
//
//  Created by wawa on 16/5/20.
//  Copyright © 2016年 Wawa. All rights reserved.
//

#import "FlexBile.h"
#define IPONE5_SCREEN CGSizeMake(320,568)
@implementation FlexBile
+(CGFloat)ratio
{

    return [[UIScreen mainScreen] bounds].size.width/IPONE5_SCREEN.width;
}
+(CGFloat)flexibleFloat:(CGFloat)aFloat
{
    return aFloat * [self ratio];

}
+(CGRect)frameIPONE5Frame:(CGRect)ipone5Frame
{
    CGFloat x = [self flexibleFloat:ipone5Frame.origin.x];
    CGFloat y = [self flexibleFloat:ipone5Frame.origin.y];
    CGFloat width = [self flexibleFloat:ipone5Frame.size.width];
    CGFloat height = [self flexibleFloat:ipone5Frame.size.height];
    return CGRectMake(x, y, width, height);
}
@end
