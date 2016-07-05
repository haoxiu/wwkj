//
//  ZhaoPinTableView.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/18.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "ZhaoPinTableView.h"
#import "ApplyJobViewController.h"
#import "SVProgressHUD.h"
#import "DataService.h"
@implementation ZhaoPinTableView
{
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 25)];
        headView.backgroundColor = [UIColor whiteColor];
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width*0.05, 0, self.width*0.25, headView.height)];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.text = @"职位";
    typeLabel.font = [UIFont systemFontOfSize:14];
    [headView addSubview:typeLabel];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(typeLabel.right, 0, self.width*0.25, headView.height)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
//    nameLabel.text = @"公司名称";
    nameLabel.font = [UIFont systemFontOfSize:14];
    [headView addSubview:nameLabel];
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.right, 0, self.width*0.4, headView.height)];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.text = @"发布日期";
    dateLabel.font = [UIFont systemFontOfSize:14];
    [headView addSubview:dateLabel];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZhaoPinModel *model = _models[indexPath.row];
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
//    nameLabel.text = model.companyname;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"profile" bundle:nil];
    ApplyJobViewController *applyVC = [sb instantiateViewControllerWithIdentifier:@"ApplyJobViewController"];
    applyVC.model = _models[indexPath.row];
    applyVC.type = _type;
    [self.viewController.navigationController pushViewController:applyVC animated:YES];
}

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
    
    
    ZhaoPinModel *model = _models[delIndex];
    if (buttonIndex == 1) {
        [SVProgressHUD show];
        [DataService requestURL:@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=del_zp" httpMethod:@"POST" params:@{@"id":model.Id} completion:^(id result) {
            
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
