//
//  PhotoScrollView.m
//  WXMovie
//
//  Created by seven on 15/2/11.
//  Copyright (c) 2015年  All rights reserved.
//

#import "PhotoScrollView.h"

@implementation PhotoScrollView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
      
        self.backgroundColor = [UIColor whiteColor];
        
        //1.创建图片
        _imgView = [[UIImageView alloc] initWithFrame:frame];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imgView];
        
        //2.设置放大缩小的倍数
        self.maximumZoomScale = 3.0;
        self.minimumZoomScale = 1.0;
        
        //3.设置协议方法
        self.delegate = self;
        
        //4.设置双击手势
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2:)];
        //设置点击的次数
        tap2.numberOfTapsRequired = 2;
        //设置触摸手指的个数
        tap2.numberOfTouchesRequired = 1;
        
        //将手势对象添加到需要作用的视图
        [self addGestureRecognizer:tap2];
        
        
        //5.创建单击手势
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1:)];
        
        [self addGestureRecognizer:tap1];
        
        //当双击手势被触发时，让单击手势无效
        [tap1 requireGestureRecognizerToFail:tap2];
    }
    
    return self;
}

- (void)tap2:(UITapGestureRecognizer *)tap {
    
//    NSLog(@"双击了");
//    NSLog(@"%@",tap.view);
    
    
//    self.zoomScale; //子视图放大的倍数
    
    if (self.zoomScale > 1) {  //放大状态
       
        //使用这个方法实现对子视图缩放
        [self setZoomScale:1 animated:YES];
        
    } else {   //缩小状态
        
        [self setZoomScale:3 animated:YES];
    }
    
}

//单击图片事件
- (void)tap1:(UITapGestureRecognizer *)tap {
    
//    NSLog(@"单击了");
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kImgClikNotification object:self];
    
}


#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return _imgView;
}




@end
