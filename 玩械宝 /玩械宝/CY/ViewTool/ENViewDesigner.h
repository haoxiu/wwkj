//
//  WGViewDesigner.h
//  WeiGuan
//
//  Created by zhao jun on 13-12-19.
//  Copyright (c) 2013年 zhao jun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ENViewDesigner : NSObject
+ (UIActivityIndicatorView *)addActivityIndicatorToView:(UIView *)aView;
+ (UITableViewCell *)fetchNextCell:(NSString *)title withIndicator:(BOOL)withIndicator;
//+ (UIView *)loadViewToView;
+ (UITableViewCell *)addAppTableViewFooter;
@end
