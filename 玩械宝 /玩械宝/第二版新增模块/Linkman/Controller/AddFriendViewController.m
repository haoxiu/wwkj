//
//  AddFriendViewController.m
//  玩械宝
//
//  Created by Stone袁 on 16/1/16.
//  Copyright (c) 2016年 zgcainiao. All rights reserved.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *table;
@property (weak, nonatomic) IBOutlet UIImageView *nickImg;
@property (weak, nonatomic) IBOutlet UITextField *number;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.title = @"添加联系人";
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
