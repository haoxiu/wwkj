//
//  MyHomeJobViewController.m
//  玩械宝
//
//  Created by echo on 11/11/15.
//  Copyright (c) 2015 zgcainiao. All rights reserved.
//

#import "MyHomeJobViewController.h"

#import "ZhaoPinViewController.h"
#import "QiuZhiViewController.h"

#import "ZhaoPinModel.h"
#import "EmployeModel.h"
#import "ApplyJobViewController.h"
#import "EmployeViewController.h"

#import "RecruitmentTableViewCell.h"
#import "RecruitmentTableViewCellMode.h"
#import "RecruitmentTableViewCellModeZP.h"

#import "CYNetworkTool.h"
#import "MBProgressHUD+NJ.h"
#import "FMDB.h"
#import "Header.h"

#import "SDRefresh.h"

@interface MyHomeJobViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIView *headView;

@property (nonatomic, strong) NSMutableArray *models;
@property (nonatomic, strong) NSMutableArray *dics;

@property (nonatomic, strong) FMDatabase *db;
@property (assign, nonatomic) int sqCount;

@property (assign, nonatomic) int page;

/**最上面（最新）的id*/
@property (copy, nonatomic) NSString *maxId;

//最下面的id
@property (copy, nonatomic) NSString *minId;

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;

@end

@implementation MyHomeJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViews];
    
    _models = [NSMutableArray array];
    _dics = [NSMutableArray array];
    
    //    _page = 1;
    
    [self loadData];
    
    [self setupHeader];
    [self setupFooter];
    
}


- (void)setViews {
    _headView.width = CYWindowWidth;
    
    UIView *footView = [[UIView alloc]init];
    
    _mainTableView.tableFooterView = footView;
}

#pragma mark - 上拉下拉刷新数据

- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:_mainTableView];
    
    [refreshHeader addTarget:self refreshAction:@selector(headerRefresh)];
    _refreshHeader = refreshHeader;
}


- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:_mainTableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

- (void)headerRefresh
{
    if (_isZhaoPin) {
        
        [self loadDataHearder:@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_ypmax" withParams:@{@"maxid":_maxId,@"pagenow":@1}];
    } else {
        
        [self loadDataHearder:@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_zparcmax" withParams:@{@"maxid":_maxId,@"pagenow":@1}];
    }
}

- (void)footerRefresh
{
    if (_isZhaoPin) {
        
        [self loadDataFooter:@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_ypmin" withParams:@{@"maxid":_minId,@"pagenow":@(_page)}];
    } else {
        
        [self loadDataFooter:@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_zparcmin" withParams:@{@"maxid":_minId,@"pagenow":@(_page)}];
    }
}

#pragma mark - load数据

- (void)loadData {
    [self setupDB];
    
    //查看数据库是否存有信息
    [self readJobs];
    
    if (_sqCount) {
        //存有信息
        if (_isZhaoPin) {
            RecruitmentTableViewCellModeZP *mode = [_models firstObject];
            
            _maxId = mode.ID;
            mode = [_models lastObject];
            _minId = mode.ID;
            
        } else {
            RecruitmentTableViewCellMode *mode = [_models firstObject];
            
            _maxId = mode.ID;
            mode = [_models lastObject];
            _minId = mode.ID;
        }
        
        [_mainTableView reloadData];
        
    }else {
        
        //数据库没有，发请求获取数据
        MBProgressHUD *hd = [MBProgressHUD showMessage:@"正在加载"];
        hd.dimBackground = NO;
        
        if (_isZhaoPin) {//我要招聘 ，显示的是求职的人的信息
            [CYNetworkTool post:URL_MainZp params:nil success:^(id json) {
                if ([json isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in json) {
                        RecruitmentTableViewCellModeZP * model = [[RecruitmentTableViewCellModeZP alloc]initWithDict:dic];
                        [_models addObject:model];
                        [_dics addObject:dic];
                        
                    }
                    [MBProgressHUD hideHUD];
                    [_mainTableView reloadData];
                    
                    [self addJobs];
                    
                    RecruitmentTableViewCellModeZP *mode = [_models firstObject];
                    
                    _maxId = mode.ID;
                    mode = [_models lastObject];
                    _minId = mode.ID;
                }
                else {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:json[@"msg"]];
                    
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"网络异常"];
            }];
        }
        else {//我要求职
            
            [CYNetworkTool post:URL_MainQz params:nil success:^(id json) {
                if ([json isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in json) {
                        RecruitmentTableViewCellMode * model = [[RecruitmentTableViewCellMode alloc]initWithDict:dic];
                        [_models addObject:model];
                        [_dics addObject:dic];
                        
                    }
                    [MBProgressHUD hideHUD];
                    [_mainTableView reloadData];
                    
                    [self addJobs];
                    
                    RecruitmentTableViewCellMode *mode = [_models firstObject];
                    
                    _maxId = mode.ID;
                    mode = [_models lastObject];
                    _minId = mode.ID;
                }
                else {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:json[@"msg"]];
                    
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"网络异常"];
            }];
        }
    }
}

//从上往下拉
- (void)loadDataHearder:(NSString *)url withParams:(NSDictionary *)params{
    
    [CYNetworkTool post:url params:params success:^(id json) {
        
        if ([json isKindOfClass:[NSDictionary class]]) {
            [self showStatusWith:@"暂无更多"];
            
            [self.refreshHeader endRefreshing];
            
            return ;
        }
        else if ([json isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *arrayRent = [NSMutableArray array];
            NSMutableArray *arrayModes = [NSMutableArray array];
            
            if (_isZhaoPin) {//我要招聘 ，显示的是求职的人的信息
                
                for (NSDictionary *dic in json) {
                    RecruitmentTableViewCellModeZP * model = [[RecruitmentTableViewCellModeZP alloc]initWithDict:dic];
                    
                    [arrayRent addObject:model];
                    [arrayModes addObject:dic];
                }
            } else {
                
                for (NSDictionary *dic in json) {
                    RecruitmentTableViewCellMode * model = [[RecruitmentTableViewCellMode alloc]initWithDict:dic];
                    
                    [arrayRent addObject:model];
                    [arrayModes addObject:dic];
                }
            }
            [arrayRent addObjectsFromArray:_models];
            [arrayModes addObjectsFromArray:_dics];
            
            _models = arrayRent;
            _dics = arrayModes;
            
            [self.refreshHeader endRefreshing];
            [_mainTableView reloadData];
            
            [self addJobs];
        }
        else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:json[@"msg"]];
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常"];
    }];
}

//从下往上拉
- (void)loadDataFooter:(NSString *)url withParams:(NSDictionary *)params{
    
    [CYNetworkTool post:url params:params success:^(id json) {
        
        if ([json isKindOfClass:[NSDictionary class]]) {
            [self showStatusWith:@"暂无更多"];
            [self.refreshFooter endRefreshing];
            
            return ;
        }
        else if ([json isKindOfClass:[NSArray class]]) {
            _page ++;
            
            if (_isZhaoPin) {//我要招聘 ，显示的是求职的人的信息
                
                for (NSDictionary *dic in json) {
                    RecruitmentTableViewCellModeZP * model = [[RecruitmentTableViewCellModeZP alloc]initWithDict:dic];
                    
                    [_models addObject:model];
                    [_dics addObject:dic];
                }
            } else {
                
                for (NSDictionary *dic in json) {
                    RecruitmentTableViewCellMode * model = [[RecruitmentTableViewCellMode alloc]initWithDict:dic];
                    
                    [_models addObject:model];
                    [_dics addObject:dic];
                }
            }
            
            [self.refreshFooter endRefreshing];
            [_mainTableView reloadData];
            
            
            [self showStatusWith:@"加载完毕"];
            
            [self addJobs];
        }
    } failure:^(NSError *error) {
        [self.refreshFooter endRefreshing];
        [MBProgressHUD showError:@"网络异常"];
    }];
}

#pragma mark - UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count;
    
    count =_models.count;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    }else{//招聘
        RecruitmentTableViewCellMode *model = _models[indexPath.row];
        cell.address.text = model.address;
        cell.kind.text = model.kind;
        cell.year.text = model.year;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if (username.length == 0) {
        [MBProgressHUD showError:@"请先登录"];
        self.tabBarController.selectedIndex = selectedIndexNum;
        return;
    }
    
    if (_isZhaoPin) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"profile" bundle:nil];
        //求职详情
        EmployeViewController *employeVC = [sb instantiateViewControllerWithIdentifier:@"EmployeViewController"];
        employeVC.mode = _models[indexPath.row];
        employeVC.type = @"10";
        employeVC.shouldHide = NO;
        employeVC.isFromCollect = NO;
        [self.navigationController pushViewController:employeVC animated:YES];
    }
    else {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"profile" bundle:nil];
        //招聘详情
        ApplyJobViewController *applyVC = [sb instantiateViewControllerWithIdentifier:@"ApplyJobViewController"];
        applyVC.model = _models[indexPath.row];
        applyVC.type = @"11";
        applyVC.shouldHide = NO;
        applyVC.isFromCollect = NO;
        [self.navigationController pushViewController:applyVC animated:YES];
    }
}

#pragma mark - 数据库相关

- (void)setupDB
{
    // 初始化
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"wanxiebao.sqlite"];
    
    self.db = [FMDatabase databaseWithPath:path];
    [self.db open];
    
    // 2.创表
    [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_job (id integer PRIMARY KEY, mode blob NOT NULL, jobid integer NOT NULL UNIQUE, catid text NOT NULL);"];
}

- (void)addJobs
{
    for (int i = 0; i < _models.count; i ++) {
        NSDictionary *dic = _dics[i];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
        if (_isZhaoPin) {
            RecruitmentTableViewCellModeZP *model = _models[i];
            [self.db executeUpdateWithFormat:@"INSERT INTO t_job(mode, jobid, catid) VALUES (%@, %@, %@);", data, model.ID, _catid];
        }else {
            RecruitmentTableViewCellMode *model = _models[i];
            [self.db executeUpdateWithFormat:@"INSERT INTO t_job(mode, jobid, catid) VALUES (%@, %@, %@);", data, model.ID, _catid];
        }
    }
}

- (void)readJobs
{
    FMResultSet *set = [self.db executeQueryWithFormat:@"SELECT * FROM t_job WHERE catid=%@ ORDER BY jobid DESC;", _catid];
    while (set.next) {
        NSData *data = [set objectForColumnName:@"mode"];
        NSDictionary *mode = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        [_dics addObject:mode];
        
        if (_isZhaoPin) {
            RecruitmentTableViewCellModeZP *model = [[RecruitmentTableViewCellModeZP alloc] initWithDict:mode];
            [_models addObject:model];
        }else {
            RecruitmentTableViewCellMode *model = [[RecruitmentTableViewCellMode alloc] initWithDict:mode];
            [_models addObject:model];
        }
        _sqCount ++;
    }
}

#pragma mark - 提示动画
- (void)showStatusWith:(NSString *)status
{
    // 1.创建label
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:0.9];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 30;
    
    
    // 2.设置其他属性
    label.text = status;
    label.textColor = [UIColor colorWithRed:20/255.0 green:204/255.0 blue:143/255.0 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    
    // 3.添加
    label.y = 64 - label.height;
    // 将label添加到导航控制器的view中，并且是盖在导航栏下边
    //    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    [self.view insertSubview:label aboveSubview:_mainTableView];
    
    // 4.动画
    // 先利用1s的时间，让label往下移动一段距离
    CGFloat duration = 0.7; // 动画的时间
    [UIView animateWithDuration:duration animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    } completion:^(BOOL finished) {
        // 延迟1s后，再利用1s的时间，让label往上移动一段距离（回到一开始的状态）
        CGFloat delay = 0.7; // 延迟1s
        // UIViewAnimationOptionCurveLinear:匀速
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
    
    // 如果某个动画执行完毕后，又要回到动画执行前的状态，建议使用transform来做动画
}

@end
