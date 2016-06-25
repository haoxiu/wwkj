//
//  JobTableView.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/17.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "JobTableView.h"
#import "EmployeModel.h"
#import "EmployeViewController.h"
#import "SVProgressHUD.h"
#import "DataService.h"
@implementation JobTableView{
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
    
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor clearColor];
    self.tableFooterView = footView;
    
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

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 25)];
//    headView.backgroundColor = [UIColor whiteColor];
//    
////    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width*0.05, 0, self.width*0.25, headView.height)];
////    typeLabel.textAlignment = NSTextAlignmentCenter;
////    typeLabel.text = @"职位";
////    typeLabel.font = [UIFont systemFontOfSize:14];
////    [headView addSubview:typeLabel];
////    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(typeLabel.right, 0, self.width*0.25, headView.height)];
////    priceLabel.textAlignment = NSTextAlignmentCenter;
////    priceLabel.text = @"姓名";
////    priceLabel.font = [UIFont systemFontOfSize:14];
////    [headView addSubview:priceLabel];
////    
////    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(priceLabel.right, 0, self.width*0.4, headView.height)];
////    dateLabel.textAlignment = NSTextAlignmentCenter;
////    dateLabel.text = @"发布日期";
////    dateLabel.font = [UIFont systemFontOfSize:14];
////    [headView addSubview:dateLabel];
//    return headView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EmployeModel *model = _models[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"segmentId" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleteCode:)];
    longPress.minimumPressDuration = 1;
    [cell addGestureRecognizer:longPress];
    // 职位
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width*0.05, 0, self.width*0.25, cell.contentView.height)];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.text = model.title;
    typeLabel.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:typeLabel];
    
    //姓名
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(typeLabel.right, 0, self.width*0.25, cell.contentView.height)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = model.name;
    nameLabel.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:nameLabel];
    
    // 发布日期
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.right, 0, self.width*0.4, cell.contentView.height)];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.text = model.inputtime;
    dateLabel.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:dateLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *subViews = [cell.contentView subviews];
    [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%@",self.viewController);
    NSLog(@"%@",self.viewController.storyboard);
    EmployeViewController *employeVC = [[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"EmployeViewController"];
    employeVC.mode = _models[indexPath.row];
    employeVC.type = _type;
    [self.viewController.navigationController pushViewController:employeVC animated:YES];
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
    
    
    EmployeModel *model = _models[delIndex];
    if (buttonIndex == 1) {
        [SVProgressHUD showWithStatus:@"删除中"];
        [DataService requestURL:@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=del_yp" httpMethod:@"POST" params:@{@"id":model.Id} completion:^(id result) {
            
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
