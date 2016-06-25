//
//  JXJobViewController.m
//  玩械宝
//
//  Created by huangyangqing on 15/10/14.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//
#define tableview0F CGRectMake(0, _headView.bottom -self.view.height/2.0, self.view.width/2.0, self.view.height/2.0)
#define tableview2F CGRectMake(0, _headView.bottom -self.view.height/2.0, self.view.width, self.view.height/2.0)

#import "JXJobViewController.h"
#import "mapModel.h"
#import "SVProgressHUD.h"
#import "DataService.h"
#import "ZhaoPinViewController.h"
#import "QiuZhiViewController.h"
#import "ZhaoPinModel.h"
#import "EmployeModel.h"
#import "ApplyJobViewController.h"
#import "EmployeViewController.h"
#import "RecruitmentTableViewCell.h"
#import "runNewView.h"

@interface JXJobViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) UITableView *tableView_1;
@property (nonatomic,strong) UITableView *tableView_2;
@property (nonatomic,strong) mapModel *address;
@property (nonatomic,assign) NSInteger selectedRow;
@property (nonatomic,strong) NSMutableArray *selectedButton;

@end

@implementation JXJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout =UIRectEdgeNone;
    UIBarButtonItem *rightItem =[[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self action:@selector(serch)];
    self.navigationItem.rightBarButtonItem =rightItem;
    _address =[[mapModel alloc]init];
    _selectedButton =[NSMutableArray array];
}

- (void)loadViews{
    _headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 35)];
    for (int i=0; i <3; i++) {
        UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(i *(1/3.0 *self.view.width -0.5), 0, 1/3.0 *self.view.width -0.5, 34)];
        btn.tag =i;
        [btn addTarget:self action:@selector(clickHeaderBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:btn];
        if (i ==0) {
            btn.titleLabel.text =@"地区";
        }else if (i ==1){
            btn.titleLabel.text =@"职业";
            btn.enabled =NO;
        }else{
            btn.titleLabel.text =@"经验";
        }
    }
#pragma mark_tableView
    _mainTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, _headView.bottom, self.view.width, self.view.height -_headView.bottom) style:UITableViewStylePlain];
    _tableView_1 =[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView_2 =[[UITableView alloc]initWithFrame:CGRectMake(0.5*self.view.width, 0, 0.5 *self.view.width, 0.5*self.view.height) style:UITableViewStylePlain];
    _mainTableView.delegate =self;
    _mainTableView.dataSource =self;
    _tableView_1.delegate =self;
    _tableView_1.dataSource =self;
    _tableView_2.delegate =self;
    _tableView_2.dataSource =self;
    [self.view insertSubview:_tableView_1 belowSubview:_headView];
    [self.view insertSubview:_tableView_2 aboveSubview:_tableView_1];
}
#pragma mark_tableviewdelegate and data
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView ==_mainTableView) {
        return 40;
    }else{
        return 33;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView ==_mainTableView) {
        return 10;
    }else if (tableView ==_tableView_1){
        return _address.provinceArray.count;
    }else{
        NSDictionary *dict =_address.provinceArray[_selectedRow];
        return dict.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView ==_mainTableView) {
        static NSString *ID =@"recruitment";
        RecruitmentTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell =[[NSBundle mainBundle] loadNibNamed:@"RecruitmentTableViewCell" owner:nil options:nil][0];
        }
        cell.address.text =@"湖南";
        cell.kind.text =@"挖机";
        cell.year.text =@"1年";
        return cell;
    }else if (tableView ==_tableView_1){
        static NSString *ID =@"tab1";
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.textLabel.text =_address.provinceArray[indexPath.row][@"name"];
        return cell;
    }else{
        static NSString *ID =@"tab2";
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.textLabel.text =_address.provinceArray[_selectedRow][@"sub"][indexPath.row][@"name"];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView ==_mainTableView) {
        
    }else if (tableView ==_tableView_1){
        
    }else{
        
    }
}




- (void)serch{
    
}

- (void)cilckHeaderBtn:(UIButton *)button{
    if (!_selectedButton) {
        [_selectedButton addObject:button];
        UIView *shadeView =[[UIView alloc]initWithFrame:CGRectMake(0, _headView.bottom, self.view.width, self.view.height -_headView.bottom)];
        shadeView.backgroundColor =[UIColor colorWithWhite:0.5 alpha:0.5];
        shadeView.alpha =0;
        shadeView.tag =100;
        [self.view insertSubview:shadeView belowSubview:_tableView_1];
        if (button.tag ==0) {
            _tableView_1.frame =tableview0F;
        }else{
            _tableView_1.frame =tableview2F;
        }
        [UIView animateWithDuration:.5 animations:^{
            shadeView.alpha =1;
            _tableView_1.transform =CGAffineTransformMakeTranslation(0, self.view.height/2.0);
        } completion:^(BOOL finished) {
            
        }];
    }
    else{
        for (id buttons in _selectedButton) {
            if ([buttons isKindOfClass:[UIButton class]]) {
                if (buttons ==button) {
                    [_selectedButton removeObject:button];
                    UIView *shadeView =[self.view viewWithTag:100];
                    [UIView animateWithDuration:.5 animations:^{
                        shadeView.alpha =0;
                        _tableView_1.transform =CGAffineTransformIdentity;
                    } completion:^(BOOL finished) {
                        [shadeView removeFromSuperview];
                    }];
                }else{
                    [_selectedButton addObject:button];
                    if (_tableView_1.width ==0.5 *self.view.width) {
                        _tableView_1.frame =tableview2F;
                    }else{
                        _tableView_1.frame =tableview0F;
                    }
                }
            }
        }
    }
}
@end
