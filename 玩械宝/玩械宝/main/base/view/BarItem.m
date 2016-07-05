//
//  BarItem.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/11.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "BarItem.h"

@implementation BarItem
{
    UIImageView *imageView;
    UILabel *titleLabel;
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

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title image:(NSString *)image Twodecker:(BOOL)two{
    self = [super initWithFrame:frame];
    if (self) {
        
        _title = title;
        _image = image;
        
        if (two) {
            
            [self _loadSubViews:YES];
        }else{
            
            [self _loadSubViews:NO];
            
        }
        
    }
    return self;
}

- (void)_loadSubViews:(BOOL)two {
    
    
    if (two) {
        // 图标
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, self.width, self.height/2-5)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:_image];
        [self addSubview:imageView];
        
        // 标题
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height/2, self.width, self.height/2-3)];
        titleLabel.text = _title;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
    }else{
        
        // 图标
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -15, self.width, self.height + 10)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:_image];
        [self addSubview:imageView];
        
        
    }
    
}
@end
