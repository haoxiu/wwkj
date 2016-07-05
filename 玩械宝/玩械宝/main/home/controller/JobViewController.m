//
//  JobViewController.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/27.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "JobViewController.h"
#import "ZhaoPinViewController.h"
#import "QiuZhiViewController.h"
#import "DataService.h"
#import "ZhaoPinModel.h"
#import "EmployeModel.h"
#import "ApplyJobViewController.h"
#import "EmployeViewController.h"
#import "SVProgressHUD.h"
#import "RecruitmentTableViewCell.h"
#import "RecruitmentTableViewCellMode.h"
#import "RecruitmentTableViewCellModeZP.h"
#import "mapModel.h"
#import "runNewView.h"

#import "CYNetworkTool.h"
#import "MBProgressHUD+NJ.h"
#import "FMDB.h" 

@interface JobViewController ()
@property (nonatomic,strong) NSMutableArray *selectedButton;
@property (nonatomic,strong) UIView *searchView;
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) NSMutableArray *models;
@property (nonatomic,strong) UITableView *tableView_1;
@property (nonatomic,strong) UITableView *tableView_2;
@property (nonatomic,strong) UIButton *selectedBtn;
@property (nonatomic,strong) mapModel *address;
@property (nonatomic,strong) runNewView *TabHead;
@property (nonatomic,assign) NSInteger indexPathRow;
@property (nonatomic,strong) UIView * tabHeaderView;
@property (nonatomic,strong) NSArray * yearArr;
@property (nonatomic) BOOL isSelected;
@end

@implementation JobViewController

-(void)viewDidAppear:(BOOL)animated
{
    NSInteger selectedIndex = 0;
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [_tableView_1 selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self loadViews];
    [self loadData];
    
    _selectedButton =[NSMutableArray array];
    _isSelected =YES;
    _indexPathRow =0;
    _models = [NSMutableArray array];
}

- (void)loadViews {
    
    _yearArr =@[@"低于1年",@"1年",@"2年",@"3年",@"4年",@"5年",@"5年以上"];
   
    // 头视图
    _tabHeaderView =[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.width, 35)];
    _tabHeaderView.tag =1000;
    _tabHeaderView.backgroundColor =[UIColor grayColor];

    for (int i =0; i <3; i++) {
        float a =1/3.0;
        UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(i *a*_tabHeaderView.width,0,a*_tabHeaderView.width,_tabHeaderView.height-1)];
        btn.backgroundColor =[UIColor whiteColor];
        btn.tag =10 +i;
        if (i ==0) {
            [btn setTitle:@"地区" forState:UIControlStateNormal];
            
        }else if (i ==1){
            [btn setTitle:@"职位" forState:UIControlStateNormal];
            btn.enabled =NO;
            
        }else{
            [btn setTitle:@"工作经验" forState:UIControlStateNormal];
        }
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font =[UIFont systemFontOfSize:13];
        btn.enabled =NO;
        [btn addTarget:self action:@selector(cilckMapButton:) forControlEvents:UIControlEventTouchUpInside];
        [_tabHeaderView addSubview:btn];
    }
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(search:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    // 搜索框
    _searchView = [[UIView alloc]initWithFrame:CGRectMake(10,_tabHeaderView.bottom -35, self.view.width-20, 35)];
    _searchView.tag =100;
    _searchView.layer.borderWidth = 1;
    _searchView.layer.cornerRadius = 10;
    _searchView.layer.borderColor = [UIColor whiteColor].CGColor;
    _searchView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    UITextField *searchTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, _searchView.width-60, _searchView.height)];
    searchTF.borderStyle = UITextBorderStyleNone;
    searchTF.placeholder = @"搜索";
    searchTF.tag = 5;
    searchTF.delegate = self;
    searchTF.returnKeyType = UIReturnKeySearch;
    searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_searchView addSubview:searchTF];
    
    searchTF.delegate = self;
    
    UIImageView *searchImg = [[UIImageView alloc]initWithFrame:CGRectMake(searchTF.right+5, (_searchView.height-30)/2, 30, 30)];
    searchImg.image = [UIImage imageNamed:@"serch"];
    searchImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(search)];
    [searchImg addGestureRecognizer:tap];
    [_searchView addSubview:searchImg];
    [self.view addSubview:_searchView];
    //信息列表
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _searchView.bottom, self.view.width, self.view.height-36-64)];
    [self.view addSubview:_mainTableView];
//    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"infoCell"];
    _mainTableView.delegate =self;
    _mainTableView.dataSource = self;
    [self setTabHeader];
    
    UIView *foot = [[UIView alloc]init];
    foot.backgroundColor = [UIColor clearColor];
    _mainTableView.tableFooterView = foot;
    [self.view addSubview:_tabHeaderView];
    _tableView_1 =[[UITableView alloc]initWithFrame:CGRectMake(0, _tabHeaderView.bottom -self.view.height *0.5, self.view.width, 0.5 *self.view.height) style:UITableViewStylePlain];
    _tableView_1.tableFooterView =foot;
    _tableView_1.backgroundColor =[UIColor clearColor];
    _tableView_2 =[[UITableView alloc]initWithFrame:CGRectMake(0.5*self.view.width, _tabHeaderView.bottom -0.5*(self.view.height -64), 0.5*_tabHeaderView.width, 0.5 *(self.view.height -64)) style:UITableViewStylePlain];
    _tableView_2.tableFooterView =foot;
    _tableView_1.delegate =self;
    _tableView_1.dataSource =self;
    _tableView_2.delegate =self;
    _tableView_2.dataSource =self;
    _tableView_2.backgroundColor =[UIColor grayColor];
    [self setLeft:_tableView_1];
    [self setLeft:_tableView_2];
    
    [self.view insertSubview:_tableView_1 belowSubview:_tabHeaderView];
    [self.view insertSubview:_tableView_2 aboveSubview:_tableView_1];
    
    UIButton *publicButton =[[UIButton alloc]initWithFrame:CGRectMake(self.view.width -50 -30, self.view.height -50 -90, 50, 50)];
    publicButton.backgroundColor =[UIColor colorWithRed:89/255.0 green:195/255.0 blue:135/255.0 alpha:1];
    publicButton.layer.cornerRadius =publicButton.width/2.0;
    [self.view addSubview:publicButton];
    [publicButton addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
    _address =[[mapModel alloc]init];
}

- (void)search {
    
    UITextField *tf = (UITextField *)[_searchView viewWithTag:5];
    NSString *keyword = tf.text;
    if (keyword.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入关键字"];
        return;
    }
    _models = [NSMutableArray array];
    [_mainTableView reloadData];
    [SVProgressHUD showWithStatus:@"搜索中。。。"];
    if (_isZhaoPin) {
        [DataService requestURL:@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_yp" httpMethod:@"POST" params:@{@"catid":@13,@"keyword":keyword} completion:^(id result) {
           
            if ([result isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in result) {
                    RecruitmentTableViewCellModeZP *model = [[RecruitmentTableViewCellModeZP alloc]initWithDict:dic];
                    [_models addObject:model];
                }
                [SVProgressHUD showSuccessWithStatus:nil];
            }
            else {
                [SVProgressHUD showErrorWithStatus:result[@"msg"]];
            }
            [_mainTableView reloadData];
        }];
    }
    else {
        
        //////////// 原来是 11,现在改 为 13
        [DataService requestURL:@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_zparc" httpMethod:@"POST" params:@{@"catid":@11,@"keyword":keyword} completion:^(id result) {
            if ([result isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in result) {
                    RecruitmentTableViewCellMode *model = [[RecruitmentTableViewCellMode alloc]initWithDict:dic];
                    [_models addObject:model];
                }
                                [SVProgressHUD showSuccessWithStatus:nil];
            }
            else {
                [SVProgressHUD showErrorWithStatus:result[@"msg"]];
            }
            [_mainTableView reloadData];
        }];
    }
}

/*
- (void)loadData {
    
    MBProgressHUD *hd = [MBProgressHUD showMessage:@"正在加载"];
    hd.dimBackground = NO;
    
    if (_isZhaoPin) {//我要招聘 ，显示的是求职的人的信息
        [DataService requestURL:@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_yp" httpMethod:@"POST" params:@{@"catid":@11} completion:^(id result) {
            if ([result isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in result) {
                    RecruitmentTableViewCellModeZP * model = [[RecruitmentTableViewCellModeZP alloc]initWithDict:dic];
                    [_models addObject:model];
                    
                }
                [_mainTableView reloadData];
                [SVProgressHUD showSuccessWithStatus:@"加载完成"];
                [self runIsOK];
            }
            else {
                [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                [self runIsOK];
            }
        }];
    }
    else {//我要求职
        NSDictionary *params = @{@"m":@"mmapi",@"c":@"sale",@"a":@"get_zparc"};
        [DataService requestURL:@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_zparc" httpMethod:@"POST" params:params completion:^(id result) {
            if ([result isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in result) {
                    RecruitmentTableViewCellMode *model = [[RecruitmentTableViewCellMode alloc]initWithDict:dic];
                    [_models addObject:model];
                    [_mainTableView reloadData];
                }
                [SVProgressHUD showSuccessWithStatus:@"加载完成"];
                [self runIsOK];
            }
            else {
                [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                [self runIsOK];
            }
        }];
    }
    
}
*/

- (void)loadData {
    
//    MBProgressHUD *hd = [MBProgressHUD showMessage:@"正在加载"];
//    hd.dimBackground = NO;
    
    
    
    
    
    
    if (_isZhaoPin) {//我要招聘 ，显示的是求职的人的信息
        [DataService requestURL:@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_yp" httpMethod:@"POST" params:@{@"catid":@11} completion:^(id result) {
            if ([result isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in result) {
                    RecruitmentTableViewCellModeZP * model = [[RecruitmentTableViewCellModeZP alloc]initWithDict:dic];
                    [_models addObject:model];
                    
                }
                [_mainTableView reloadData];
                [SVProgressHUD showSuccessWithStatus:@"加载完成"];
                [self runIsOK];
            }
            else {
                [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                [self runIsOK];
            }
        }];
    }
    else {//我要求职
        NSDictionary *params = @{@"m":@"mmapi",@"c":@"sale",@"a":@"get_zparc"};
        [DataService requestURL:@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_zparc" httpMethod:@"POST" params:params completion:^(id result) {
            if ([result isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in result) {
                    RecruitmentTableViewCellMode *model = [[RecruitmentTableViewCellMode alloc]initWithDict:dic];
                    [_models addObject:model];
                    [_mainTableView reloadData];
                }
                [SVProgressHUD showSuccessWithStatus:@"加载完成"];
                [self runIsOK];
            }
            else {
                [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                [self runIsOK];
            }
        }];
    }
    
}

// 发布
- (void)publish {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"public" bundle:nil];
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    if (username.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        self.tabBarController.selectedIndex = selectedIndexNum;
        return;
    }
    if (_isZhaoPin) {
        
        ZhaoPinViewController *zhaopinVC = [sb instantiateViewControllerWithIdentifier:@"ZhaoPinViewController"];
        [self.navigationController pushViewController:zhaopinVC animated:YES];
    }
    else {
        QiuZhiViewController *qiuzhiVC = [sb instantiateViewControllerWithIdentifier:@"QiuZhiViewController"];
        [self.navigationController pushViewController:qiuzhiVC animated:YES];
    }
}

#pragma mark - UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView ==_mainTableView) {
        return 40;
    }else{
        return 30;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count;
    if (tableView ==_mainTableView) {
        count =_models.count;
    }else if(tableView ==_tableView_1) {
        if (_selectedBtn.tag ==12) {
            count =_yearArr.count;
        }else{
            count =_address.provinceArray.count;
        }
    }else{
        NSArray *city =_address.provinceArray[_indexPathRow][@"sub"];
        count =city.count;
    }
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView ==_mainTableView) {
        static NSString * ID =@"recruitment";
        RecruitmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell =[[NSBundle mainBundle] loadNibNamed:@"RecruitmentTableViewCell" owner:nil options:nil][0];
        }
        if (_isZhaoPin) {
            RecruitmentTableViewCellModeZP *model =_models[indexPath.row];
            cell.address.text =model.address;
            cell.kind.text =model.kind;
            cell.year.text =model.year;
        }else{
            RecruitmentTableViewCellMode *model = _models[indexPath.row];
            cell.address.text = model.address;
            cell.kind.text = model.kind;
            cell.year.text = model.year;
        }
        return cell;
    }else if (tableView ==_tableView_1){
        
        static NSString *ID =@"tab1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        if (_selectedBtn.tag ==12) {
            cell.textLabel.text =_yearArr[indexPath.row];
        }else{
            cell.textLabel.text =_address.provinceArray[indexPath.row][@"name"];
        }
        [self setLeftCell:cell];
        return cell;
    }else{
        static NSString *ID =@"tab2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.textLabel.text =_address.provinceArray[_indexPathRow][@"sub"][indexPath.row][@"name"];
        [self setLeftCell:cell];
        cell.backgroundColor =[UIColor grayColor];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView ==_mainTableView) {
        if (_isZhaoPin) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"profile" bundle:nil];
            EmployeViewController *employeVC = [sb instantiateViewControllerWithIdentifier:@"EmployeViewController"];
            employeVC.mode = _models[indexPath.row];
            employeVC.type = @"10";
            [self.navigationController pushViewController:employeVC animated:YES];
        }
        else {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"profile" bundle:nil];
            ApplyJobViewController *applyVC = [sb instantiateViewControllerWithIdentifier:@"ApplyJobViewController"];
            applyVC.model = _models[indexPath.row];
            applyVC.type = @"11";
            [self.navigationController pushViewController:applyVC animated:YES];
        }
    }else if (tableView ==_tableView_1){
        //年
        [self setTabHeader];
        if (_selectedBtn.tag ==12) {
            [_selectedBtn setTitle:_yearArr[indexPath.row] forState:UIControlStateNormal];
            [UIView animateWithDuration:.5 animations:^{
                [self.view viewWithTag:2].alpha =0;
                _tableView_1.transform =CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [[self.view viewWithTag:2] removeFromSuperview];
                _selectedBtn =nil;
                [_models removeAllObjects];
                [_mainTableView reloadData];
            }];
#warning  执行筛选
            if (_isZhaoPin) {
                NSDictionary *dict =@{@"jobback":_yearArr[indexPath.row]};
                [DataService requestURL:@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_yp" httpMethod:@"POST" params:dict completion:^(id result){
                    for (id modes in result) {
                        if ([modes isKindOfClass:[NSDictionary class]]) {
                            RecruitmentTableViewCellModeZP *mode =[[RecruitmentTableViewCellModeZP alloc]initWithDict:modes];
                            [_models addObject:mode];
                        }
                    }
                }];
            }else{
                NSDictionary *dict =@{@"jobtype":_yearArr[indexPath.row]};
                [DataService requestURL:@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_zparc" httpMethod:@"POST" params:dict completion:^(id result){
                    for (id modes in result) {
                        if ([modes isKindOfClass:[NSDictionary class]]) {
                            RecruitmentTableViewCellMode *mode =[[RecruitmentTableViewCellMode alloc]initWithDict:modes];
                            [_models addObject:mode];
                        }
                    }
                }];
                [_mainTableView reloadData];
                [self runIsOK];
            }
        }
        else{
            _indexPathRow =indexPath.row;
            [_tableView_2 reloadData];
            _tableView_2.transform =CGAffineTransformMakeTranslation(0, self.view.height/2.0);
        }
        
    }else{
        [self setTabHeader];
        [_selectedBtn setTitle:_address.provinceArray[_indexPathRow][@"sub"][indexPath.row][@"name"] forState:UIControlStateNormal];
        [UIView animateWithDuration:.5 animations:^{
            [self.view viewWithTag:2].alpha =0;
            _tableView_1.transform =CGAffineTransformIdentity;
            _tableView_2.transform =CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [[self.view viewWithTag:2] removeFromSuperview];
            _selectedBtn =nil;
            [_models removeAllObjects];
            [_mainTableView reloadData];
        }];
        if (_isZhaoPin) {
            NSDictionary *dict =@{@"workplace":_address.provinceArray[_indexPathRow][@"sub"][indexPath.row][@"name"]};
            [DataService requestURL:@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_yp" httpMethod:@"POST" params:dict completion:^(id result){
                for (id modes in result){
                    if ([modes isKindOfClass:[NSDictionary class]]) {
                        RecruitmentTableViewCellModeZP *mode =[[RecruitmentTableViewCellModeZP alloc]initWithDict:modes];
                        [_models addObject:mode];
                    }
                }
                [_mainTableView reloadData];
                [self runIsOK];
            }];
        }else{
            NSDictionary *dict =@{@"place":_address.provinceArray[_indexPathRow][@"sub"][indexPath.row][@"name"]};
            [DataService requestURL:@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_zparc" httpMethod:@"POST" params:dict completion:^(id result){
                [_models removeAllObjects];
                for (id modes in result){
                    if ([modes isKindOfClass:[NSDictionary class]]) {
                        RecruitmentTableViewCellMode *mode =[[RecruitmentTableViewCellMode alloc]initWithDict:modes];
                        [_models addObject:mode];
                    }
                }
                [_mainTableView reloadData];
                [self runIsOK];
            }];
        }
    }
}

//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSArray *subViews = cell.contentView.subviews;
//    [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self search];
    return YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)cilckMapButton:(UIButton *)button{
    if (_selectedBtn ==nil) {
        UIView *shadeView =[[UIView alloc]initWithFrame:CGRectMake(0,_tabHeaderView.bottom, self.view.width, self.view.height -_tabHeaderView.bottom)];
        shadeView.backgroundColor =[UIColor colorWithWhite:0.5 alpha:0.8];
        shadeView.tag =2;
        [self.view insertSubview:shadeView belowSubview:_tableView_1];
        if (button.tag ==11 || button.tag ==12) {
            _tableView_1.frame =CGRectMake(0, _tabHeaderView.bottom -self.view.height *0.5, self.view.width, 0.5 *self.view.height);
        }else{
            _tableView_1.frame =CGRectMake(0, _tabHeaderView.bottom -0.5*self.view.height, 0.5*_tabHeaderView.width, 0.5 *self.view.height);
        }
        [UIView animateWithDuration:.5 animations:^{
            _tableView_1.transform =CGAffineTransformMakeTranslation(0,0.5 *self.view.height);
            
        } completion:^(BOOL finished) {
            button.selected =NO;
        }];
        
        _selectedBtn =button;
        [_tableView_1 reloadData];
    }else if (button != _selectedBtn){
        if (button.tag ==11 || button.tag ==12) {
            _tableView_1.frame =CGRectMake(0, _tabHeaderView.bottom, self.view.width, 0.5 *self.view.height);
        }else{
            _tableView_1.frame =CGRectMake(0, _tabHeaderView.bottom, 0.5*_tabHeaderView.width, 0.5 *self.view.height);
        }
        _tableView_2.transform =CGAffineTransformIdentity;
        _selectedBtn =button;
        [_tableView_1 reloadData];
    }else{
        [UIView animateWithDuration:.5 animations:^{
            [self.view viewWithTag:2].alpha =0;
            _tableView_1.transform =CGAffineTransformIdentity;
            _tableView_2.transform =_tableView_1.transform;
        } completion:^(BOOL finished) {
            [[self.view viewWithTag:2] removeFromSuperview];
            _selectedBtn =nil;
            button.selected =YES;
        }];
    }
    
}

- (void)search:(UIBarButtonItem *)sender{
    if (_isSelected) {
        _searchView.transform =CGAffineTransformMakeTranslation(0, _searchView.height);
        _mainTableView.transform =_searchView.transform;
    }else{
        _searchView.transform =CGAffineTransformIdentity;
        _mainTableView.transform =_searchView.transform;
    }
    _isSelected =!_isSelected;
}
//按地址筛选
- (void)addressSerchData{
    NSDictionary * params;
    if (_selectedBtn ==nil || _selectedBtn.tag ==10){
        params =@{@"place":_selectedBtn.titleLabel.text};
    }else{
        params =@{@"workback":_selectedBtn.titleLabel.text};
    }
    
    [DataService requestURL:@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_zparc" httpMethod:@"POST" params:params completion:^(id result) {
        if ([result isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in result) {
                RecruitmentTableViewCellMode *model = [[RecruitmentTableViewCellMode alloc]initWithDict:dic];
                [_models addObject:model];
                [_mainTableView reloadData];
            }
            [SVProgressHUD showSuccessWithStatus:@"加载完成"];
            [self runIsOK];
        }
        else {
            [SVProgressHUD showErrorWithStatus:result[@"msg"]];
            [self runIsOK];
        }
    }];
}

- (void)setLeft:(UITableView *)tab{
    if ([tab respondsToSelector:@selector(setSeparatorInset:)]) {
        [tab setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([tab respondsToSelector:@selector(setLayoutMargins:)]) {
        [tab setLayoutMargins: UIEdgeInsetsZero];
    }
}

- (void)setLeftCell:(UITableViewCell *)cell{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins: UIEdgeInsetsZero];
    }
}

- (void) setTabHeader{
    if (!_TabHead) {
        _TabHead =[[runNewView alloc]initWithFrame:CGRectMake(0, 0, _mainTableView.width, 40)];
    }else{
        [_TabHead staterActivity];
    }
    _mainTableView.tableHeaderView =_TabHead;
    // [self loadData];
}

- (void) runIsOK{
    if (_TabHead) {
        [_TabHead stopActivity:@"加载完成"];
        [UIView animateWithDuration:2.0 animations:^{
            _mainTableView.tableFooterView.transform =CGAffineTransformMakeScale(1, 0.1);
        } completion:^(BOOL finished) {
            _mainTableView.tableHeaderView =nil;
        }];
    }
}
@end
