//
//  KindBtn.m
//  玩械宝
//
//  Created by huangyangqing on 15/9/11.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "KindBtn.h"

@implementation KindBtn
{
    UIImageView *imageView;
    UILabel *titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)name image:(NSString *)img{
    self =[super initWithFrame:frame];
    if (self) {
        _title =name;
        _image =img;
        [self loadViews];
    }
    return self;
}

- (void)loadViews{
    
    UIImageView * imgView =[[UIImageView alloc]initWithFrame:CGRectMake(self.width *0.5 -self.width*0.1, 0.5*self.height-self.width*0.2, self.width*0.2, self.width*0.2)];
    imgView.image = [UIImage imageNamed:_image];
    _imgView =imgView;

    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(0, 0.5 *self.height +15, self.frame.size.width,0.2 *self.frame.size.height)];
    title.textAlignment =NSTextAlignmentCenter;
    title.textColor =[UIColor whiteColor];
    title.font =[UIFont systemFontOfSize:12];
    title.text =_title;
    _titleLabel_New = title;
    
    [self addSubview:imgView];
    [self addSubview:title];
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
}

- (void)setSelectedImg:(NSString *)selectedImg {
    _selectedImg = selectedImg;
}

- (void)setIsSelected:(BOOL)isSelected {
    
    if (isSelected) {
        
        titleLabel.textColor = _selectedColor;
        imageView.image = [UIImage imageNamed:_selectedImg];
    }
    else {
        
        titleLabel.textColor = [UIColor blackColor];
        imageView.image = [UIImage imageNamed:_image];
    }
}
- (void)setBtnTitleColor:(UIColor *)btnTitleColor{
   
}
@end
