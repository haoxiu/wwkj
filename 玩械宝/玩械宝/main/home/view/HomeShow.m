//
//  HomeShow.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/11.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "HomeShow.h"
#import "UIImageView+WebCache.h"
@implementation HomeShow


- (void)setImgs:(NSArray *)imgs {
    _imgs = imgs;
    [self _loadViews];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
//  [self _loadViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _loadViews];
    }
    return self;
}

- (void)_loadViews {
    
    for (int i = 0; i< _imgs.count; i++) {
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.width, 0, self.width, self.height)];
#warning contentMode
        //保证图片比例不变的缩放，填充整个imgview，会有显示不全
        image.contentMode = UIViewContentModeScaleAspectFill;
        [image sd_setImageWithURL:[NSURL URLWithString:_imgs[i]]];
        
        //如果没有网络加载本地图片
        image.image = [UIImage imageNamed:_imgs[i]];
        image.tag = 100+i;
        [self addSubview:image];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (int i = 0; i < _imgs.count; i++) {
        UIImageView *image = (UIImageView *)[self viewWithTag:i+100];
    }
}
@end
