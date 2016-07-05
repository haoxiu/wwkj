//
//  userSexLableText.h
//  玩械宝
//
//  Created by huangyangqing on 15/10/12.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol userSexLableTextDelegate <NSObject>

- (void)selectedSexText:(NSString *)sex;
@end
@interface userSexLableText : UIView

@property (weak,nonatomic)id <userSexLableTextDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *man;
@property (weak, nonatomic) IBOutlet UIButton *woman;
- (IBAction)selectedSex:(UIButton *)sender;

@end
