//
//  MyButtonView.m
//  玩械宝
//
//  Created by echo on 11/11/15.
//  Copyright (c) 2015 zgcainiao. All rights reserved.
//

#import "MyButtonView.h"
#import "Header.h"

@interface MyButtonView()

@property (weak, nonatomic) IBOutlet UIImageView *icon;


@end


@implementation MyButtonView

+ (instancetype)newWithOwner:(id)owner
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MyButtonView" owner:owner options:nil];
    return [nibs objectAtIndex:0];
}

- (MyButtonView *)initWithContrainer:(UIView *)contrainer withFrame:(CGRect)frame andText:(NSString *)text
{
    self = [MyButtonView newWithOwner:contrainer];
    if (self) {
        _isSelected = NO;
        [self setFrame:frame];
        
        [_optionLabel setText:text];

        [contrainer addSubview:self];
        [self bringSubviewToFront:contrainer];
    }
    return self;
}

- (void)btnIsSelected
{
    if (_isSelected) {
        // view 的背景色变为绿色
        [self setBackgroundColor:CYNavColor];
        
        // icon 图片换成 高亮的
        [_icon setHighlighted:YES];
        
        // label 字体变成 绿色
        [_optionLabel setHighlighted:YES];

        
    }else {
        // view 的背景色变为白色
        [self setBackgroundColor:[UIColor whiteColor]];
        
        // icon 图片换成 正常的
        [_icon setHighlighted:NO];
        
        // label 字体变成 黑色
        [_optionLabel setHighlighted:NO];
    }

}

- (IBAction)myBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(myButtonViewdidBtnClick:)]) {
        if (_isSelected) {
            _isSelected = NO;
        } else {
            _isSelected = YES;
        }

        [self btnIsSelected];
        
        [self.delegate myButtonViewdidBtnClick:self];
    }
}


@end
