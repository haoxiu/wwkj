//
//  KindBtn.h
//  玩械宝
//
//  Created by huangyangqing on 15/9/11.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KindBtn : UIButton

@property(nonatomic,strong) NSString *title;
@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSString *selectedImg;
@property(nonatomic,strong)UIColor *selectedColor;
@property(nonatomic,strong)UIColor *btnTitleColor;
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,assign)BOOL isSelected;
@property(nonatomic,strong)UILabel *titleLabel_New;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)name image:(NSString *)img;
- (void)setBtnTitleColor:(UIColor *)btnTitleColor;
@end

#warning 选择切换不同的tabbar