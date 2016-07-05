//
//  MyButtonView.h
//  玩械宝
//
//  Created by echo on 11/11/15.
//  Copyright (c) 2015 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyButtonView;

@protocol MyButtonViewDelegate <NSObject>

- (void) myButtonViewdidBtnClick:(MyButtonView *) myButtonView;

@end


@interface MyButtonView : UIView

//- (NotLoginView *)initWithContrainer:(UIView *)contrainer withFrame:(CGRect)frame withNavigationController:(UINavigationController *)navigation;

@property (assign, nonatomic) int tag;

@property (weak, nonatomic) IBOutlet UILabel *optionLabel;

/**是否被选中*/
@property (assign, nonatomic) BOOL isSelected;

- (void)btnIsSelected;

/**init 设置button的frame、text*/
- (MyButtonView *)initWithContrainer:(UIView *)contrainer withFrame:(CGRect)frame andText:(NSString *)text;

@property (weak, nonatomic) IBOutlet UIButton *myBtn;

#pragma mark - MyButtonViewDelegate

@property (nonatomic, weak) id <MyButtonViewDelegate> delegate;

@end
