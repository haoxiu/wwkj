//
//  ProfileTableView.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/16.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "ProfileTableView.h"
#import "MachineDetailViewController.h"
#import "MachineModel.h"
#import "DataService.h"
#import "SVProgressHUD.h"
@implementation ProfileTableView{
    NSInteger delIndex;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _loadViews];
    }
    return self;
}

- (void)_loadViews {
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"segmentId"];
    self.bounces = NO;
    // 空尾视图，解决多余单元格线问题
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor clearColor];
    self.tableFooterView = footView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // 创建标题栏
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 25)];
        headView.backgroundColor = [UIColor whiteColor];
//    self.tableHeaderView = headView;
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width*0.05, 0, self.width*0.25, headView.height)];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.text = @"车型";
    typeLabel.font = [UIFont systemFontOfSize:14];
    [headView addSubview:typeLabel];
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(typeLabel.right, 0, self.width*0.25, headView.height)];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.text = @"价格";
    priceLabel.font = [UIFont systemFontOfSize:14];
    [headView addSubview:priceLabel];
    if ([_type isEqualToString:@"13"] || [_type isEqualToString:@"14"] ) {
        priceLabel.text = @"";
    }
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(priceLabel.right, 0, self.width*0.4, headView.height)];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.text = @"发布日期";
    dateLabel.font = [UIFont systemFontOfSize:14];
    [headView addSubview:dateLabel];
    return headView;
    
}


- (void)setModels:(NSArray *)models {
    if (_models != models) {
        
        _models = [NSMutableArray arrayWithArray:models];
        
        [self reloadData];
    }
}

#pragma mark UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _models.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MachineModel *model = _models[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"segmentId" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.tag = indexPath.row;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleteCode:)];
    longPress.minimumPressDuration = 1;
    [cell addGestureRecognizer:longPress];
    
    // 类型
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width*0.05, 0, self.width*0.25, cell.contentView.height)];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.text = model.cartype;
    typeLabel.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:typeLabel];
    
    // 价格
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(typeLabel.right, 0, self.width*0.25, cell.contentView.height)];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.text = [NSString stringWithFormat:@"%@万",model.price];
    priceLabel.font = [UIFont systemFontOfSize:14];
    priceLabel.adjustsFontSizeToFitWidth = YES;
    [cell.contentView addSubview:priceLabel];
    if ([_type isEqualToString:@"13"] || [_type isEqualToString:@"14"]) {
        priceLabel.text = @"";
    }
    
    // 发布日期
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(priceLabel.right, 0, self.width*0.4, cell.contentView.height)];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.text = model.inputtime;
    dateLabel.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:dateLabel];

    return cell;
}

// 点击单元格，查看详细信息
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"profile" bundle:nil];
    MachineDetailViewController *detailVC = [sb instantiateViewControllerWithIdentifier:@"MachineDetailViewController"];
    if ([_type isEqualToString:@"13"] || [_type isEqualToString:@"14"]) {
        detailVC.hideSth = YES;
    }

    detailVC.model = _models[indexPath.row];
    detailVC.type = _type;
    [tableView.viewController.navigationController pushViewController:detailVC animated:YES];
}

// 解决复用问题
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *subViews = [cell.contentView subviews];
    [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

// 长按删除
- (void)deleteCode:(UILongPressGestureRecognizer *)press {
    
    if (press.state == UIGestureRecognizerStateBegan) {
        
        [[[UIAlertView alloc]initWithTitle:@"警告" message:@"确定删除此条记录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
    }
    UITableViewCell *cell = (UITableViewCell *)press.view;
    delIndex = cell.tag;
   
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    MachineModel *model = _models[delIndex];
    if (buttonIndex == 1) {
        [SVProgressHUD show];
        NSString *url = @"http://eswjdg.com/index.php?m=mmapi&c=sale&a=del_pub";
        NSDictionary *params = @{@"id":model.ID};
        if ([_type1 isEqualToString:@"check"]) {
            
            url = @"http://eswjdg.com/index.php?m=mmapi&c=member&a=del_sol";  //删除我的收藏
            params = @{@"colid":model.colid};
        }
        [DataService requestURL:url httpMethod:@"POST" params:params completion:^(id result) {
            
            NSLog(@"%@",result);
            if ([result[@"state"] isEqualToNumber:@1]) {
                
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                [_models removeObjectAtIndex:delIndex];
                [self reloadData];
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"删除失败"];
            }
        }];

    }
}

@end
