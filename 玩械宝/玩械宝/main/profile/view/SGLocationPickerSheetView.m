//
//  SGLocationPickerSheetView.m
//  LocationPicker(地区选择)
//
//  Created by Hanymore on 16/6/28.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "SGLocationPickerSheetView.h"

@implementation SGLocationPickerSheetView

#pragma mark - - - 按钮的点击事件
- (void)addCancelTarget:(id)target action:(SEL)action{
    [self.cancelBtn addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
}
- (void)addSureTarget:(id)target action:(SEL)action{
    [self.sureBtn addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
}

@end
