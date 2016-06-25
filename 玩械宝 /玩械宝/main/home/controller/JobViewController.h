//
//  JobViewController.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/27.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "BaseViewController.h"

@interface JobViewController : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign)BOOL isZhaoPin;
@end
