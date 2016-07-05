//
//  MyCollectViewController.m
//  玩械宝
//
//  Created by echo on 11/5/15.
//  Copyright (c) 2015 zgcainiao. All rights reserved.
//

//我的发布

#import "MyPublishViewController.h"

//机械的详细页面
#import "CellViewController.h"

//全部列表cell
#import "CollectWithMeTableViewCell.h"
#import "CollectWithMeTableViewCellMode.h"

#import "DataService.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

//招聘列表cell:地点、类型、年限
#import "RecruitmentTableViewCell.h"
#import "RecruitmentTableViewCellMode.h"
#import "RecruitmentTableViewCellModeZP.h"

//招聘详情
#import "EmployeViewController.h"
//求职详情
#import "ApplyJobViewController.h"

#import "CollectViewMode.h"

#import "MJRefresh.h"
#import "MJRefreshHeader.h"
#import "runNewView.h"

#import "Header.h"
#import "SDRefresh.h"

#import "MBProgressHUD+NJ.h"

/*（1）SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
 
 （2）[refreshHeader addToScrollView:目标tableview];  //加入到目标tableview，默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
 
 （3）[refreshHeader addTarget: refreshAction:加载内容的方法] 或者 refreshHeader.beginRefreshingOperation = ^{} 任选其中一种即可
 
 PS：
 
 加载数据完成后调用 [refreshHeader endRefreshing];
 
 如果需要一进入就自动加载一次数据，请调用[refreshHeader autoRefreshWhenViewDidAppear];
 
 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
 */

/*
 + (MBProgressHUD *)showMessage:(NSString *)message;
 
 + (void)hideHUDForView:(UIView *)view;
 + (void)hideHUD;
 */

@interface MyPublishViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,assign) int SelectedButtonTag;
@property (nonatomic, strong) UIButton *SelectedButton;

@property (nonatomic,strong) NSMutableArray *rentModels;
@property (nonatomic,strong) NSMutableArray *QzModes;
@property (nonatomic,strong) NSMutableArray *ZpModes;
@property (nonatomic,strong) NSMutableArray *modes;

//@property (nonatomic, strong) runNewView *TabHead;
@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) AFHTTPRequestOperation *loadDataService;

@property (nonatomic) int page;
@property (nonatomic) int page1;
@property (nonatomic) int page2;

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;

@end

@implementation MyPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的发布";
    
    _page =1;
    _page1 =1;
    _page2 =1;
    
    _rentModels =[NSMutableArray array];
    _QzModes =[NSMutableArray array];
    _modes =[NSMutableArray array];
    _ZpModes =[NSMutableArray array];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.view.backgroundColor =[UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _SelectedButtonTag = 0;
    
//    [self loadAllData];
    
    //设置了 全部 被 选中
    [self loadViews];
    
    [self setupHeader];
    
    [self setupFooter];
    
    [self headerRefresh];
}

- (void)viewDidAppear:(BOOL)animated
{
//    [MBProgressHUD showMessage:@"正在努力加载"];
}


#pragma mark - 上拉下拉刷新数据

- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:self.tableView];
    
//    [refreshHeader addTarget: refreshAction:加载内容的方法]
    
    [refreshHeader addTarget:self refreshAction:@selector(headerRefresh)];

    // 进入页面自动加载一次数据
//    [refreshHeader autoRefreshWhenViewDidAppear];
    
    _refreshHeader = refreshHeader;
}

- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.tableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}



- (void)footerRefresh
{
    //根据_SelectedButtonTag判断是 全部,求职,招聘 tableview
    switch (_SelectedButtonTag) {
            
            //            发送请求，加载数据
        case 0:
            [self loadDataFooter:URL_MyPublishAll withParams:@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"pagenow":@(_page)}];
            break;
        case 1:
            [self loadDataFooter:URL_MyPublishQz withParams:@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"catid":@10,@"pagenow":@(_page1)}];
            break;
        case 2:
            [self loadDataFooter:URL_MyPublishZp withParams:@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"catid":@11,@"pagenow":@(_page2)}];
            break;
            
        default:
            break;
    }
    
    //返回数据，拿到后 刷新tableview
    
    //    [self.tableView reloadData];
    //    [self.refreshFooter endRefreshing];
}
 
#pragma mark - load数据
- (void)headerRefresh
{
    //根据_SelectedButtonTag判断是 全部,求职,招聘 tableview
    switch (_SelectedButtonTag) {
            
//            发送请求，加载数据，page＝1
        case 0:
            _page = 1;
            [self loadDataHearder:URL_MyPublishAll withParams:@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"pagenow":@(_page)}];
            break;
        case 1:
            _page1 = 1;
            [self loadDataHearder:URL_MyPublishQz withParams:@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"catid":@10,@"pagenow":@(_page1)}];
            break;
        case 2:
            _page2 = 1;
            [self loadDataHearder:URL_MyPublishZp withParams:@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"catid":@11,@"pagenow":@(_page2)}];
            break;
            
        default:
            break;
    }
    
    //返回数据，拿到后 刷新tableview
    
//    [self.tableView reloadData];
//    [self.refreshFooter endRefreshing];
}


//从上往下拉
- (void)loadDataHearder:(NSString *)url withParams:(NSDictionary *)params{
    
    _loadDataService = [DataService requestURL:url httpMethod:@"POST" params:params completion:^(id result)  {
        
        if ([result isKindOfClass:[NSDictionary class]]) {
//            [MBProgressHUD showError:@"暂无更多"];
            
            [self.refreshHeader endRefreshing];
            return ;
        }
        else if ([result isKindOfClass:[NSArray class]]) {
            switch (_SelectedButtonTag) {
                case 0:
                    if  (_rentModels.count !=0){
                        [_rentModels removeAllObjects];
                        [_modes removeAllObjects];
                    }
                    _page ++;
                    
                    for (NSDictionary *dic in result) {
                        CollectWithMeTableViewCellMode *model = [[CollectWithMeTableViewCellMode alloc] initWithDict:dic];
                        
                        [_rentModels addObject:model];
                        [_modes addObject:dic];
                    }
                    
                    break;
                case 1:
                    if  (_QzModes.count !=0){
                        [_QzModes removeAllObjects];
                    }
                    _page1 ++;
                    
                    for (NSDictionary *dic in result) {
                        RecruitmentTableViewCellModeZP *mode =[[RecruitmentTableViewCellModeZP alloc]initWithDict:dic];
                        [_QzModes addObject:mode];
                    }
                    
                    break;
                case 2:
                    if  (_ZpModes.count !=0){
                        [_ZpModes removeAllObjects];
                    }
                    _page2 ++;
                    
                    for (NSDictionary *dic in result) {
                        RecruitmentTableViewCellMode *mode =[[RecruitmentTableViewCellMode alloc]initWithDict:dic];
                        
                        [_ZpModes addObject:mode];
                    }
                    
                    break;
                    
                default:
                    break;
            }
            
            [self.tableView reloadData];
            [self.refreshHeader endRefreshing];
            
//            [MBProgressHUD hideHUD];
        }
        else{
            [self.refreshFooter endRefreshing];
//            [_tableView reloadData];
            _tableView.footer.hidden =YES;
//            [MBProgressHUD showError:@"网络异常"];
        }

    }];
}

//从下往上拉
- (void)loadDataFooter:(NSString *)url withParams:(NSDictionary *)params{
    
    _loadDataService = [DataService requestURL:url httpMethod:@"POST" params:params completion:^(id result)  {
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            [self.refreshFooter endRefreshing];
            return ;
        }
        else if ([result isKindOfClass:[NSArray class]]) {
            switch (_SelectedButtonTag) {
                case 0:
                    _page ++;
                    
                    for (NSDictionary *dic in result) {
                        CollectWithMeTableViewCellMode *model = [[CollectWithMeTableViewCellMode alloc] initWithDict:dic];
                        
                        [_rentModels addObject:model];
                        [_modes addObject:dic];
                    }
                    
                    break;
                case 1:
                    _page1 ++;
                    
                    for (NSDictionary *dic in result) {
                        RecruitmentTableViewCellModeZP *mode =[[RecruitmentTableViewCellModeZP alloc]initWithDict:dic];
                        [_QzModes addObject:mode];
                    }
                    
                    break;
                case 2:
                    _page2 ++;
                    
                    for (NSDictionary *dic in result) {
                        RecruitmentTableViewCellMode *mode =[[RecruitmentTableViewCellMode alloc]initWithDict:dic];
                        
                        [_ZpModes addObject:mode];
                    }
                    
                    break;
                    
                default:
                    break;
            }
            
            [self.tableView reloadData];
            [self.refreshFooter endRefreshing];
            
//            [MBProgressHUD hideHUD];
        }
        else{
            [self.refreshFooter endRefreshing];
            //            [_tableView reloadData];
            _tableView.footer.hidden =YES;
//            [MBProgressHUD showError:@"网络异常"];
        }
        
    }];
}

- (void)loadViews{
    _headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44+1)];
    _headView.backgroundColor =[UIColor clearColor];
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, _headView.bottom, self.view.width, self.view.height -64 -44-1 -44) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    
    //    _tableView.tag =100;
    
    UIView *footView =[[UIView alloc]init];
    footView.backgroundColor =[UIColor clearColor];
    _tableView.tableFooterView =footView;
    
//    [self setTabHeader];
    
    UIView *backView =[[UIView alloc]init];
    backView.backgroundColor =[UIColor clearColor];
    
    [self.view addSubview:_tableView];
    
    [self.view addSubview:_headView];
    
    for (int i =0; i <3; i++) {
        UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(i *(self.view.width/3.0 +0.5), 0, self.view.width/3.0 -0.5, 44)];
        btn.backgroundColor =[UIColor whiteColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnCilck:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag =i;
        
        [_headView addSubview:btn];
        
        btn.titleLabel.font =[UIFont systemFontOfSize:14];
        
        if (i ==0) {
            btn.backgroundColor =[UIColor colorWithRed:20/255.0 green:204/255.0 blue:143/255.0 alpha:1];
            
            _SelectedButtonTag = 0;
            [btn setSelected:YES];
            _SelectedButton = btn;
            
            [btn setTitle:@"全部" forState:UIControlStateNormal];
        }
        else if (i ==1) {
            [btn setTitle:@"求职" forState:UIControlStateNormal];
        }else{
            [btn setTitle:@"招聘" forState:UIControlStateNormal];
        }
    }
    
    //    [self.view insertSubview:_tableView_1 belowSubview:_headView];
}


#pragma mark - tableView代理和数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = 0;
    switch (_SelectedButtonTag) {
        case 0:
            num = _modes.count;
            break;
        case 1:
            num = _QzModes.count;
            break;
        case 2:
            num = _ZpModes.count;
            break;
        default:
            break;
    }
    return num;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_rentModels.count != 0 && _SelectedButtonTag == 0) {
        CollectViewMode *modeF =[[CollectViewMode alloc] initWithDict:_modes[indexPath.row]];
        return modeF.cellHeight;
    }else{
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (_SelectedButtonTag == 0){
        
        static NSString *ID =@"IDENT";
        CollectWithMeTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell =[[NSBundle mainBundle] loadNibNamed:@"CollectWithMeTableViewCell" owner:nil options:nil][0];
        }
        CollectWithMeTableViewCellMode *mode =[[CollectWithMeTableViewCellMode alloc] init];
        mode =_rentModels[indexPath.row];
        NSData *imgData = [[NSData alloc]initWithBase64EncodedString:mode.icon options:NSDataBase64DecodingIgnoreUnknownCharacters];
        cell.icon.imageView.image =[UIImage imageWithData:imgData];
        cell.userName.text =mode.userName;
        
        switch ([mode.parentid intValue]) {
            case 12:
                cell.aboutClassLableText.text =@"出租";
                break;
            case 14:
                cell.aboutClassLableText.text =@"求租";
                break;
            case 13:
                cell.aboutClassLableText.text =@"买车";
                break;
            case 9:
                cell.aboutClassLableText.text =@"卖车";
                break;
            case 10:
                cell.aboutClassLableText.text =@"求职";
                break;
            case 11:
                cell.aboutClassLableText.text =@"招聘";
                break;
            default:
                break;
        }
        //出租  14求租  13买车  9卖车  10 求职  11 招聘
        cell.esayPresent.text =mode.esayPresent;
        cell.time.text =mode.time;
        cell.price.text =mode.price;
        cell.detailPresent.text =mode.detailPresent;
        cell.useTime.text =mode.useTime;
        cell.mapText.text =mode.mapText;
        cell.xinghao.text = mode.aboutClassLableText;
        cell.leixing.text = mode.cartype;
        cell.collect.hidden =YES;
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hdimg"] isEqualToString:@""]) {
            
        }else{
            NSData *igData = [[NSData alloc]initWithBase64EncodedString:[[NSUserDefaults standardUserDefaults] objectForKey:@"hdimg"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *headImg = [UIImage imageWithData:igData];
            [cell.icon setBackgroundImage:headImg forState:UIControlStateNormal];
        }
        
        if ( mode.images.count !=0 &&![mode.images[0][@"image"] isEqualToString:@"0"]) {
            NSArray *imgs =[NSArray arrayWithObjects:cell.image_1,cell.image_2,cell.image_3,cell.image_4, nil];
            for (int i =0 ;i<MIN(imgs.count, mode.images.count); i++) {
                UIImageView *imgView =imgs[i];
                [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://waji.zgcainiao.com/%@",mode.images[i][@"image"]]] placeholderImage:[UIImage imageNamed:@"waji"]];
            }
        }else{
            cell.image_1.image =nil;
            cell.image_2.image =nil;
            cell.image_3.image =nil;
            cell.image_4.image =nil;
            cell.imgBackView.backgroundColor =[UIColor colorWithWhite:0 alpha:0];
        }
        return cell;
        
    }else{
        static NSString *ID =@"recruitment";
        RecruitmentTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell =[[NSBundle mainBundle] loadNibNamed:@"RecruitmentTableViewCell" owner:nil options:nil][0];
        }
        if (_SelectedButtonTag ==1) {
            //求职,有sex
            RecruitmentTableViewCellModeZP *mode =[[RecruitmentTableViewCellModeZP alloc]init];
            mode = _QzModes[indexPath.row];
            cell.address.text =mode.address;
            cell.year.text =mode.year;
            cell.kind.text =mode.kind;
        }else {
            RecruitmentTableViewCellMode *mode =[[RecruitmentTableViewCellMode alloc]init];
            mode = _ZpModes[indexPath.row];
            cell.address.text =mode.address;
            cell.year.text =mode.year;
            cell.kind.text =mode.kind;
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_SelectedButtonTag == 0) {
        CellViewController *cellView =[[CellViewController alloc]init];
        cellView.mode =_rentModels[indexPath.row];
        cellView.isMian =NO;
        [self.navigationController pushViewController:cellView animated:YES];
    }else if (_SelectedButtonTag == 2){
        //招聘
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"profile" bundle:nil];
        ApplyJobViewController *empl = [sb instantiateViewControllerWithIdentifier:@"ApplyJobViewController"];
        empl.model = _ZpModes[indexPath.row];
        [self.navigationController pushViewController:empl animated:YES];
    }else{
        //求职
        EmployeViewController *job =[[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"EmployeViewController"];
        job.mode =_QzModes[indexPath.row];
        [self.navigationController pushViewController:job animated:YES];
    }
}

- (void)btnCilck:(UIButton *)button{
    [DataService cancelPreviousPerformRequestsWithTarget:self];
    
    if (_SelectedButtonTag == button.tag) {
        return;
    }else{
        
//        [MBProgressHUD showMessage:@"正在努力加载"];
        
        [_SelectedButton setSelected:NO];
        _SelectedButton.backgroundColor = [UIColor whiteColor];
        
        [button setSelected:YES];
        _SelectedButtonTag = (int)button.tag;
        _SelectedButton = button;
        
        button.backgroundColor = [UIColor colorWithRed:20/255.0 green:204/255.0 blue:143/255.0 alpha:1];
        
        [_loadDataService cancel];

        switch (_SelectedButtonTag) {
            case 0:
                if  (_modes.count == 0){
                    [self headerRefresh];
                }
                break;
            case 1:
                if (_QzModes.count == 0) {
                    [self headerRefresh];
                }
                break;
            case 2:
                if (_ZpModes.count == 0) {
                    [self headerRefresh];
                }
                break;
            default:
                break;
        }
 
        
        [_tableView reloadData];
        
    }
    
}
/*
- (void) setTabHeader{
    if (!_TabHead) {
        _TabHead =[[runNewView alloc]initWithFrame:CGRectMake(0, 0, _tableView.width, 40)];
    }else{
        [_TabHead staterActivity];
    }
    _tableView.tableHeaderView =_TabHead;
    // [self loadData];
}



- (void) runIsOK{
    if (_TabHead) {
        [_TabHead stopActivity:@"加载完成"];
        [UIView animateWithDuration:0.7 animations:^{
            _tableView.tableFooterView.transform =CGAffineTransformMakeScale(1, 0.1);
        } completion:^(BOOL finished) {
            _tableView.tableHeaderView =nil;
        }];
    }
}
*/

@end
