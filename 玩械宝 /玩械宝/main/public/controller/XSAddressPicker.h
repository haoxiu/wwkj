//
//  XSAddressPicker.h
//  玩械宝
//
//  Created by CaiNiao on 15/7/6.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//
typedef void(^choose)(NSString *province,NSString *city,NSString *area);
#import <UIKit/UIKit.h>
@interface XSAddressPicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,copy)choose chooseAction;
- (void)setChooseAction:(choose)chooseAction;
- (instancetype)initWithFrame:(CGRect)frame chooseAction:(choose)actoin;
@end
