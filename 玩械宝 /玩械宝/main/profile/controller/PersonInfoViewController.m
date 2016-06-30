//
//  PersonInfoViewController.m
//  玩械宝
//
//  Created by 刘昊 on 16/6/29.
//  Copyright © 2016年 zgcainiao. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "AppDelegate.h"

#import "userSexLableText.h"

#import "Header.h"
#import "MBProgressHUD+NJ.h"
#import "CYNetworkTool.h"

#import "UIImage+KIAdditions.h"
#import "PhotoViewController.h"
@interface PersonInfoViewController (){
    UITableViewCell *cell;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;
@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _titles = @[@"头像",@"昵称",@"账号",@"性别",@"地区"];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PublishCell"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _titles.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cell = [tableView dequeueReusableCellWithIdentifier:@"PublishCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width*0.8, 0, 50, 44)];
        imgV.image = [UIImage imageNamed:@"新版发现1_016"];
//        cell.textLabel.text = @"头像";
        [cell addSubview:imgV];
    }else if (indexPath.row >= 1){
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width*0.47, 0, 150, 44)];
    label.text = _titles[indexPath.row];
    label.textAlignment = NSTextAlignmentRight;
    [cell addSubview:label];
    }
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    return CGFLOAT_MIN;
    return tableView.sectionHeaderHeight;
}
#pragma mark 单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}
#pragma mark 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //取消单元格选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
       
    }if (indexPath.row == 1) {
        
    }if (indexPath.row == 2) {
        
    }if (indexPath.row == 3) {
        
    }if (indexPath.row == 4) {
        
    }
    
    
}



@end
