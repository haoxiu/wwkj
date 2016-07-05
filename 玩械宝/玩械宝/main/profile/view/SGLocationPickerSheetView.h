//
//  SGLocationPickerSheetView.h
//  LocationPicker(地区选择)
//
//  Created by Hanymore on 16/6/28.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGLocationPickerSheetView : UIView 
/** 取消按钮 */
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
/** 确定按钮 */
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
/** pickerView */
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

// 取消按钮的点击事件
- (void)addCancelTarget:(id)target action:(SEL)action;
// 确定按钮的点击事件
- (void)addSureTarget:(id)target action:(SEL)action;
@end
