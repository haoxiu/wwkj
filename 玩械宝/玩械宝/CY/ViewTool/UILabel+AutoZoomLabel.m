//
//  UILabel+AutoZoomLabel.m
//  haodf
//
//  Created by kiki on 12-8-28.
//  Copyright (c) 2012年 haodf.com. All rights reserved.
//

#import "UILabel+AutoZoomLabel.h"

@implementation UILabel (AutoZoomLabel)

- (float)heightWhenFillWithText:(NSString *)aText
            constrainedToHeight:(float)aHeight
{
    CGSize cSize = CGSizeMake(self.frame.size.width, aHeight);
    CGSize resSize = [self sizeWhenFillWithText:aText constrainedToSize:cSize];
    return resSize.height;
}

- (float)widthWhenFillWithText:(NSString *)aText
            constrainedToWidth:(float)aWidth
{
    CGSize cSize = CGSizeMake(aWidth, self.frame.size.height);
    CGSize resSize = [self sizeWhenFillWithText:aText constrainedToSize:cSize];
    return resSize.width;
}

- (CGSize)sizeWhenFillWithText:(NSString *)aText constrainedToSize:(CGSize)aSize
{
    CGSize aftSize = [aText sizeWithFont:self.font constrainedToSize:aSize lineBreakMode:NSLineBreakByCharWrapping];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        aftSize.height += 1;
    }
    return aftSize;
}

- (void)fillAndAutoZoomWithText:(NSString*)aText
              constrainedToHeight:(float)aHeight
{
    float oldWidth = self.frame.size.width;
    [self fillAndAutoZoomWithText:aText constrainedToSize:CGSizeMake(self.frame.size.width, aHeight)];
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            oldWidth,
                            self.frame.size.height);
}

- (void)fillAndAutoZoomWithText:(NSString*)aText
              constrainedToWidth:(float)aWidth
{
    float oldHeight = self.frame.size.height;
    [self fillAndAutoZoomWithText:aText constrainedToSize:CGSizeMake(aWidth, self.frame.size.height)];
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width,
                            oldHeight);
}

- (void)fillAndAutoZoomWithText:(NSString*)aText
              constrainedToSize:(CGSize)aSize
{
    self.numberOfLines = 0;
    CGSize nowSize = [self sizeWhenFillWithText:aText constrainedToSize:aSize];
    
    CGRect frame = self.frame;
    frame.size = nowSize;
    self.frame = frame;
    self.text = aText;
}

- (float)incHeightWithText:(NSString*)aText constrainedToHeight:(float)aHeight;
{
    float oldHeight = self.frame.size.height;
    [self fillAndAutoZoomWithText:aText constrainedToHeight:aHeight];
    return self.frame.size.height - oldHeight;
}

- (float)incWidthWithText:(NSString*)aText
       constrainedToWidth:(float)aWidth
{
    float oldWidth = self.frame.size.width;
    [self fillAndAutoZoomWithText:aText constrainedToWidth:aWidth];
    return self.frame.size.width - oldWidth;
}

- (BOOL)isTruncatedText
{
    float allTextH = [self heightWhenFillWithText:self.text constrainedToHeight:9000];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        return (int)(allTextH) > (int)self.frame.size.height;
    }
    else
    {
        return (allTextH > self.frame.size.height);
    }
}

@end
