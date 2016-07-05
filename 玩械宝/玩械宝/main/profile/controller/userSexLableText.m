//
//  userSexLableText.m
//  玩械宝
//
//  Created by huangyangqing on 15/10/12.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "userSexLableText.h"

@implementation userSexLableText

- (void)awakeFromNib{
    self.backgroundColor =[UIColor colorWithWhite:0.7 alpha:0.7];
}

- (IBAction)selectedSex:(UIButton *)sender {
    [self.delegate selectedSexText:sender.titleLabel.text];
    self.hidden =YES;
}
@end
