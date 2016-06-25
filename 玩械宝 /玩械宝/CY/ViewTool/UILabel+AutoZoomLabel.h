//
//  UILabel+AutoZoomLabel.h
//  weiguan
//
//  Created by zhaojun on 13-2-18.
//  Copyright (c) 2013年 weiguan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (AutoZoomLabel)

//获得自动扩大后的全量值
- (float)heightWhenFillWithText:(NSString*)aText 
            constrainedToHeight:(float)aHeight;
- (float)widthWhenFillWithText:(NSString*)aText 
            constrainedToWidth:(float)aWidth;
- (CGSize)sizeWhenFillWithText:(NSString*)aText 
             constrainedToSize:(CGSize)aSize;

//赋值并自动扩大
- (void)fillAndAutoZoomWithText:(NSString*)aText
            constrainedToHeight:(float)aHeight;
- (void)fillAndAutoZoomWithText:(NSString*)aText
             constrainedToWidth:(float)aWidth;
- (void)fillAndAutoZoomWithText:(NSString*)aText
              constrainedToSize:(CGSize)aSize;

//获得自动扩大后的增量值
- (float)incHeightWithText:(NSString*)aText
       constrainedToHeight:(float)aHeight;
- (float)incWidthWithText:(NSString*)aText
       constrainedToWidth:(float)aWidth;

- (BOOL)isTruncatedText;

@end
