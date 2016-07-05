//
//  HeadView.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/26.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadViews];
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    }
    return self;
}
- (void)loadViews {
    
    CGFloat width = self.width/4;
    NSArray *titles = @[@"品牌",@"价格",@"省市",@"排序"];
    for (int i = 0; i < 4; i++) {
        
        UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(i*width, 0, width, self.height)];
        [control addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        control.tag = 100+i;
        control.highlighted = YES;
        [self addSubview:control];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, control.width-40, control.height)];
        title.text = titles[i];

        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(title.right, 10, 40, control.height)];
        imgView.image = [UIImage imageNamed:@"xiala"];
        imgView.tag = 1;
        [control addSubview:imgView];
        [control addSubview:title];
        
    }
}

- (void)buttonAction:(UIControl *)ctrl{


}

@end
