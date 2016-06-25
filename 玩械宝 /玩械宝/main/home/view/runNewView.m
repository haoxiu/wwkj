//
//  runNewView.m
//  玩械宝
//
//  Created by huangyangqing on 15/10/26.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "runNewView.h"

#import "Header.h"
@interface runNewView ()
@property (nonatomic, strong) NSString *lableText;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UILabel *lable;
@end

@implementation runNewView

- (instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        [self loadViews];
    }
    return self;
}

- (void)setLableText:(NSString *)runLableText{
    
    _lable.text = runLableText;
}

- (void)stopActivity:(NSString *) stopLableText{
    [_activityView stopAnimating];
    _activityView.hidden =YES;
    _lable.text = stopLableText;
}

- (void)stopActivityDirect{
    [_activityView stopAnimating];
    _activityView.hidden =YES;
}

- (void) staterActivity{
    _activityView.hidden =NO;
    [_activityView startAnimating];
    _lable.text =@"正在加载更多的数据...";
}

- (void)loadViews{
    _lable =[[UILabel alloc]init];
    _lable.text =@"正在加载更多的数据...";
    _lable.textColor = CYNavColor;
    
    _lable.textAlignment =NSTextAlignmentCenter;
    _lable.font =[UIFont systemFontOfSize:14];
    CGSize contentS = [_lable.text boundingRectWithSize:
                       CGSizeMake(300,300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size ;
    _lable.frame =CGRectMake(self.width/2.0 -(contentS.width)/2.0,(self.height -contentS.height)/2.0,contentS.width, contentS.height);
    [self addSubview:_lable];
    _activityView =[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.frame =CGRectMake(0,0, 20, 20);
    [_activityView setCenter:CGPointMake(_lable.left - 0.5 *self.height -10, 0.5 *self.height)];
    [_activityView startAnimating];
    if (_activityView.hidden) {
        _activityView.hidden =NO;
    }
    [self addSubview:_activityView];
    
    UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(0, self.bottom -0.5, self.width, 0.5)];
    backView.backgroundColor =[UIColor grayColor];
    [self addSubview:backView];
}


@end
