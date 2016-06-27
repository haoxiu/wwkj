//
//  SetViewController.m
//  玩械宝
//
//  Created by 刘昊 on 16/6/27.
//  Copyright © 2016年 zgcainiao. All rights reserved.
//

#import "SetViewController.h"

@interface SetViewController ()
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *titles;
@end

@implementation SetViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    ;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _titles = @[@"新消息提醒",@"勿扰模式",@"聊天",@"隐私",@"账号与安全",@"关于我们",@"版本更新",@"退出"];
  
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;//不显示右侧滑块
    _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;//分割线
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PublishCell"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _titles.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublishCell" forIndexPath:indexPath];
    cell.textLabel.text = _titles[indexPath.row];

    return cell;
}
#pragma mark 单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}
#pragma mark 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //点击颜色马上变回来
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

}

@end
