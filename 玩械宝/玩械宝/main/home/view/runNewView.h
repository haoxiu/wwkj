//
//  runNewView.h
//  玩械宝
//
//  Created by huangyangqing on 15/10/26.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface runNewView : UIView

- (void)setLableText:(NSString *) lableText;
- (void)stopActivity:(NSString *) stopLableText;
- (void) staterActivity;
- (instancetype)initWithFrame:(CGRect)frame;

//echo添加
- (void)stopActivityDirect;
@end
