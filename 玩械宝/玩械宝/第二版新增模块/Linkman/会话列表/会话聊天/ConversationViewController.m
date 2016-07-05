//
//  ConversationViewController.m
//  玩械宝
//
//  Created by wawa on 16/5/27.
//  Copyright © 2016年 zgcainiao. All rights reserved.
//

#import "ConversationViewController.h"

@interface ConversationViewController ()

@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*!
     删除扩展功能板中的指定扩展项
     @param index 指定扩展项的索引值
     */
    [self.pluginBoardView removeItemAtIndex:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
