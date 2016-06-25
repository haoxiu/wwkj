//
//  WGViewDesigner.m
//  WeiGuan
//
//  Created by zhao jun on 13-12-19.
//  Copyright (c) 2013年 zhao jun. All rights reserved.
//

#import "ENViewDesigner.h"
#import "ENView.h"
#import "ENMiscFetchNextCell.h"
//#import "UIImage+GIF.h"

#import "UIImageView+WebCache.h"

#define FETCH_NEXT_IDENTIFIER @"FetchNextCell"

@implementation ENViewDesigner

+ (UIActivityIndicatorView *)addActivityIndicatorToView:(UIView *)aView
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.hidesWhenStopped = YES;
    spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [aView addSubview:spinner];
    [spinner setPositionToSuperview:UIViewPositionCenter];
    return spinner;
}

+ (UITableViewCell *)fetchNextCell:(NSString *)title withIndicator:(BOOL)withIndicator
{
    UITableViewCell *cell = [[ENMiscFetchNextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FETCH_NEXT_IDENTIFIER];
    cell.textLabel.text = title;
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = DefultLightFont(15);
    cell.detailTextLabel.text = nil;
    cell.imageView.image = nil;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];

    if (withIndicator) {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.hidesWhenStopped = YES;
        spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [spinner startAnimating];
        [cell addSubview:spinner];
        [spinner setPositionToSuperview:UIViewPositionCenter];
    }
    return cell;
}

//+ (UIView *)loadViewToView
//{
//    UIView *loadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    loadView.backgroundColor = [UIColor clearColor];
////    UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
////    [loadView addSubview:loadLabel];
////    loadLabel.center = CGPointMake(loadView.center.x, loadView.center.y + 20);
////    [loadLabel setText:@"加载中..."];
////    [loadLabel setBackgroundColor:[UIColor clearColor]];
////    [loadLabel setTextAlignment:NSTextAlignmentCenter];
////    [loadLabel setTextColor:UIColorWithRGB(210, 210, 210)];
//    UIImageView *loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//    loadingImageView.center = CGPointMake(loadView.center.x, loadView.center.y);
//    [loadingImageView setImage:[UIImage sd_animatedGIFNamed:@"load"]];
//    [loadView addSubview:loadingImageView];
//    
//    loadView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
//    return loadView;
//}

+ (UITableViewCell *)addAppTableViewFooter
{
    UITableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"AppTableViewFooter" owner:self options:nil] objectAtIndex:0];
    cell.width = ScreenWidth;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
