//
//  SegmentViewController.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/16.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, type) {
    MyPublic = 0,
    MyCollection = 1,
    WaitCheck = 2,
    };

@interface SegmentViewController : BaseViewController<UIScrollViewDelegate>
@property(nonatomic,strong)NSMutableArray *rentModels;
@property(nonatomic,assign)type type;
@end
