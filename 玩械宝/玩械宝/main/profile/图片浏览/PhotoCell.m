//
//  PhotoCell.m
//  WXMovie
//
//  Created by seven on 15/2/11.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "PhotoCell.h"
#import "PhotoScrollView.h"
#import "UIImageView+WebCache.h"

@implementation PhotoCell


//使用代码创建的时候调用
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //1.创建子视图
        [self createView];
        
    }
    return self;
}

//加载xib时会调用
- (void)awakeFromNib {
    
    [self createView];
}

- (void)createView {
    
    _scrollView = [[PhotoScrollView alloc] initWithFrame:self.bounds];
    
    [self.contentView addSubview:_scrollView];
}


- (void)setImg:(UIImage *)img{

    if (_img != img) {
        
        _scrollView.imgView.image = img;
        
    }

}

- (void)setUrlstring:(NSString *)urlstring {
    
    if (_urlstring != urlstring) {
        
        NSURL *url = [NSURL URLWithString:urlstring];
        
        [_scrollView.imgView sd_setImageWithURL:url];
    }
}


@end
