//
//  MyHomeMachineViewController.m
//  玩械宝
//
//  Created by echo on 11/11/15.
//  Copyright (c) 2015 zgcainiao. All rights reserved.
//

#import "MyHomeMachineViewController.h"

#import "MyButtonView.h"
#import "Header.h"

#import "UIImageView+WebCache.h"
#import "CYNetworkTool.h"
#import "MBProgressHUD+NJ.h"
#import "CollectWithMeTableViewCellMode.h"
#import "CollectWithMeTableViewCell.h"
#import "CollectViewMode.h"
#import "CellViewController.h"

#import "SDRefresh.h"

#import "MachineParamsModel.h"
#import "MyBuyDetailViewController.h"

@interface MyHomeMachineViewController ()<MyButtonViewDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *headView;

@property (strong, nonatomic) NSMutableArray *buttonViews;

@property (nonatomic, assign) int selectedTag; //9为置空

@property (weak, nonatomic) IBOutlet UITableView *mainTable;

@property (weak, nonatomic) IBOutlet UIButton *coverBtn;

@property (weak, nonatomic) IBOutlet UITableView *childTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *childTableHeightConstraint;
@property (strong, nonatomic) NSMutableArray *childTittles;

@property (assign, nonatomic) int page;

@property (assign, nonatomic) int sqCount;

@property (strong, nonatomic) NSMutableArray *rentModels;
@property (strong, nonatomic) NSMutableArray *modes;

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;

@property (strong, nonatomic) MachineParamsModel *machineParams;

/**最上面（最新）的id*/
@property (copy, nonatomic) NSString *maxId;

//最下面的id
@property (copy, nonatomic) NSString *minId;

@property (assign ,nonatomic) BOOL isChildRefresh;

@end

@implementation MyHomeMachineViewController{

    MBProgressHUD *hd;
}

//picthumb 压缩的图

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _buttonViews = [NSMutableArray array];
    
    [self setViews];
    _selectedTag = 9;
    
    _rentModels =[NSMutableArray array];
    _modes =[NSMutableArray array];
    _childTittles = [NSMutableArray array];
    _sqCount = 0;
    
    _isChildRefresh = NO;
    
    _page = 1;
    
    _machineParams = [[MachineParamsModel alloc] init];
    _machineParams.price = @"价格";
    _machineParams.brand = @"品牌";
    _machineParams.address = @"省市";

    [self loadData];
    
    [self setupHeader];
    [self setupFooter];
}

- (void)setViews
{
    [self hideChildAndCover:YES];
    
    //设置btnView 和 btn
    NSArray * array = [NSArray arrayWithObjects:@"品牌", @"价格",@"省市", @"类型", nil];
    
    [_headView setWidth:CYWindowWidth];
    
    CGFloat width = _headView.width / 3;
    
    for (int i = 0; i < 3; i++) {
   
    MyButtonView *myBtnView = [[MyButtonView alloc] initWithContrainer:_headView withFrame:CGRectMake(width * i, 0, width, 35) andText: [array objectAtIndex:i]];
        
        [_headView layoutSubviews];
        
        myBtnView.tag = i;
        
        myBtnView.delegate = self;
        
        [_buttonViews addObject:myBtnView];
        
        myBtnView = nil;
    }
    
    UIView *footView = [[UIView alloc]init];
    
    _mainTable.tableFooterView = footView;
    
}



#pragma mark - 上拉下拉刷新数据

- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:_mainTable];
    
    [refreshHeader addTarget:self refreshAction:@selector(headerRefresh)];
    _refreshHeader = refreshHeader;
    
}


- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:_mainTable];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

- (void)headerRefresh
{
    if (_isChildRefresh) {
        [self loadDataHearder:URL_MainAll withParams:@{
                                                       @"order":@"排序",
                                                       @"price":_machineParams.price,
                                                       @"cartype":self.title,
                                                       @"catid":_catid,
                                                       @"brand":_machineParams.brand,
                                                       @"address":_machineParams.address,
                                                       @"pagenow":@1}];
    } else {
    [self loadDataHearder:@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_pubmax" withParams:@{
                                                   @"order":@"排序",
                                                   @"price":_machineParams.price,
                                                   @"cartype":self.title,
                                                   @"catid":_catid,
                                                   @"brand":_machineParams.brand,
                                                   @"address":_machineParams.address,
                                                   @"maxid":_maxId,
                                                   @"pagenow":@1}];
    }

}

- (void)footerRefresh
{
    if (_isChildRefresh) {
        [self loadDataFooter:URL_MainAll withParams:@{
                                                       @"order":@"排序",
                                                       @"price":_machineParams.price,
                                                       @"cartype":self.title,
                                                       @"catid":_catid,
                                                       @"brand":_machineParams.brand,
                                                       @"address":_machineParams.address,
                                                       @"pagenow":@(_page)}];
    } else {
    [self loadDataFooter:@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_pubmin" withParams:@{
                                                   @"order":@"排序",
                                                   @"price":_machineParams.price,
                                                   @"cartype":self.title,
                                                   @"catid":_catid,
                                                   @"brand":_machineParams.brand,
                                                   @"address":_machineParams.address,
                                                   @"minid":_minId,
                                                   @"pagenow":@(_page)}];
    }
}

#pragma mark - load数据

- (void) childTableRefreshData
{
    _isChildRefresh = YES;
    _page = 1;
    
    hd = [MBProgressHUD showMessage:@"正在加载"];
    hd.dimBackground = NO;
    
    [CYNetworkTool post:URL_MainAll params:@{
                                             @"order":@"排序",
                                             @"price":_machineParams.price,
                                             @"cartype":self.title,
                                             @"catid":_catid,
                                             @"brand":_machineParams.brand,
                                             @"address":_machineParams.address,
                                             @"pagenow":@1} success:^(id json){
        if ([json isKindOfClass:[NSDictionary class]]) {
            
            [MBProgressHUD hideHUD];
            
            [MBProgressHUD showError:@"暂无数据"];
            
            if  (_rentModels.count !=0){
                [_rentModels removeAllObjects];
                [_modes removeAllObjects];
            }
            [_mainTable reloadData];
            
            return ;
        }
        else if ([json isKindOfClass:[NSArray class]]) {
            
            if  (_rentModels.count !=0){
                [_rentModels removeAllObjects];
                [_modes removeAllObjects];
            }
            _page ++;
            
            for (NSDictionary *dic in json) {
                CollectWithMeTableViewCellMode *model = [[CollectWithMeTableViewCellMode alloc] initWithDict:dic];
                
                [_rentModels addObject:model];
                [_modes addObject:dic];
            }
            
            
            [_mainTable reloadData];
            

            [MBProgressHUD hideHUD];
            [self showStatusWith:@"加载完毕"];
        }
    } failure:^(NSError *error) {

        [MBProgressHUD showError:@"网络异常"];
        [hd removeFromSuperview];
    }];
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
                
//                if  (_rentModels.count !=0){
//                    [_rentModels removeAllObjects];
//                    [_modes removeAllObjects];
//                }
//                _page ++;
                
                 NSMutableArray *arrayRent = [NSMutableArray array];
                NSMutableArray *arrayModes = [NSMutableArray array];
                
                for (NSDictionary *dic in json) {
                    CollectWithMeTableViewCellMode *model = [[CollectWithMeTableViewCellMode alloc] initWithDict:dic];
                    
//                    [_rentModels addObject:model];
//                    [_modes addObject:dic];
                    [arrayRent addObject:model];
                    [arrayModes addObject:dic];
                }
                
                [arrayRent addObjectsFromArray:_rentModels];
                [arrayModes addObjectsFromArray:_modes];
                
                _rentModels = arrayRent;
                _modes = arrayModes;
                
                [self.refreshHeader endRefreshing];
                [_mainTable reloadData];
                
                [self showStatusWith:@"加载完毕"];
                
                if (! _isChildRefresh) {
                    [self addMachines];
                }
            }
    } failure:^(NSError *error) {
        [self.refreshHeader endRefreshing];
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
            
            for (NSDictionary *dic in json) {
                CollectWithMeTableViewCellMode *model = [[CollectWithMeTableViewCellMode alloc] initWithDict:dic];
                
                [_rentModels addObject:model];
                [_modes addObject:dic];
            }
            
            [self.refreshFooter endRefreshing];
            [_mainTable reloadData];
            

            [self showStatusWith:@"加载完毕"];
            
            if (! _isChildRefresh) {
                [self addMachines];
            }
        }
    } failure:^(NSError *error) {
        [self.refreshFooter endRefreshing];
        [MBProgressHUD showError:@"网络异常"];
    }];
}


- (void)loadData
{
    [self setupDB];

    //查看数据库是否存有信息
    [self readMachines];
  
    if (_sqCount) {
        //存有信息
        CollectWithMeTableViewCellMode *mode = [_rentModels firstObject];
        _maxId = mode.ID;
        
        mode = [_rentModels lastObject];
        _minId = mode.ID;
        
        [_mainTable reloadData];
        
    }else {

        //数据库没有，发请求获取数据
        
    hd = [MBProgressHUD showMessage:@"正在加载"];
    hd.dimBackground = NO;
    
//    NSDictionary *params = @{@"order":@"排序",@"price":@"价格",@"cartype":self.title,@"catid":_catid,@"brand":@"品牌",@"address":@"省市",@"pagenow":@1};
    
    [CYNetworkTool post:URL_MainAll params:@{
                                             @"order":@"排序",
                                             @"price":_machineParams.price,
                                             @"cartype":self.title,
                                             @"catid":_catid,
                                             @"brand":_machineParams.brand,
                                             @"address":_machineParams.address,
                                             @"pagenow":@1}
                success:^(id json) {
                    if ([json isKindOfClass:[NSDictionary class]]) {
                        //否则会崩溃
                        [_refreshHeader removeFromSuperview];
                        
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"暂无数据"];
            
            return ;
        }
        
        if ([json isKindOfClass:[NSArray class]]) {
        
            for (NSDictionary *dic in json) {
                
                //                NSLog(@"++++++++++++++%@",[dic objectForKey:@"id"]);
                CollectWithMeTableViewCellMode *model = [[CollectWithMeTableViewCellMode alloc] initWithDict:dic];

                [_rentModels addObject:model];
                [_modes addObject:dic];
            }
        }
        
        _page ++;
        [MBProgressHUD hideHUD];
        [_mainTable reloadData];
                    
                    CollectWithMeTableViewCellMode *mode = [_rentModels firstObject];
                    _maxId = mode.ID;
                    
                    mode = [_rentModels lastObject];
                    _minId = mode.ID;
                    
        [self addMachines];
   
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常"];
    }];
    

    }
}

#pragma mark - childTable、cover
/**管理child 和 cover 的方法*/
- (void)hideChildAndCover:(BOOL)isHide
{
    [_coverBtn setHidden:isHide];
    [_childTable setHidden:isHide];
}


- (IBAction)coverBtnClick:(id)sender {
    [self hideChildAndCover:YES];
    
    //取消之前选中的btn
    MyButtonView *btn = [_buttonViews objectAtIndex:_selectedTag];
    btn.isSelected = NO;
    [btn btnIsSelected];
    
    _selectedTag = 9;
}

/**定义childTable的内容*/
- (void) setChileTable
{
    switch (_selectedTag) {
        case 0:
            _childTittles = [NSMutableArray arrayWithObjects:@"不限", @"小松", @"卡特",@"加藤", @"神钢", @"住友", @"现代",@"斗山",@"三一重工",@"沃尔沃",@"日立",@"龙工",@"柳工",@"其他", nil];
            
            [_childTableHeightConstraint setConstant:(30.0 * 7)];
            [_childTable reloadData];
            break;
        case 1:
            _childTittles = [NSMutableArray arrayWithObjects:@"不限",@"10万以下",@"10-15万",@"15-35万",@"35万以上", nil];
            
            [_childTableHeightConstraint setConstant:(30.0 * _childTittles.count)];
            [_childTable reloadData];
            break;
        case 2:
        {
            NSMutableArray *array = [NSMutableArray arrayWithObject:@"不限"];
            [CYNetworkTool post:@"http://eswjdg.com/index.php?m=mmapi&c=member&a=getpro" params:@{@"m":@"mmapi",@"c":@"member",@"a":@"getpro"} success:^(id json) {
                for (NSDictionary *dic in json) {
                    
                    [array addObject:dic[@"name"]];
                }
                _childTittles = array;
                
                [_childTableHeightConstraint setConstant:(30.0 * 7)];
                [_childTable reloadData];
                
            } failure:^(NSError *error) {
                [self hideChildAndCover:YES];
                [MBProgressHUD showError:@"网络异常"];
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - MyButtonViewDelegate

- (void)myButtonViewdidBtnClick:(MyButtonView *)myButtonView
{
//    @"品牌", @"价格",@"省市", @"排序"
//    NSLog(@"%d",myButtonView.tag);
    
    if (myButtonView.isSelected) {//选中状态(第一次被点击)
        if (_selectedTag != 9) {// 之前还有btn被选中
            //取消之前选中的btn
            MyButtonView *btn = [_buttonViews objectAtIndex:_selectedTag];
            btn.isSelected = NO;
            [btn btnIsSelected];
        }
        _selectedTag = myButtonView.tag;
        
        //显示对应的childTable
        [self setChileTable];
        
        [self hideChildAndCover:NO];
        
    }else { //已经点击取消选中
        _selectedTag = 9;
        //关闭相应的childTable
        [self hideChildAndCover:YES];
    }
}

#pragma mark  - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_mainTable == tableView) {
        return _rentModels.count;
    }
    else {
        return _childTittles.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_mainTable == tableView) {
        CollectViewMode *modeF =[[CollectViewMode alloc]initWithDict:_modes[indexPath.row]];
        return modeF.cellHeight;
    }
    else {
        return 30;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_mainTable == tableView) {
        CollectWithMeTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"collectWithMeTableViewCell"];
        if (!cell) {
            cell =[[NSBundle mainBundle] loadNibNamed:@"CollectWithMeTableViewCell" owner:nil options:nil][0];
        }
        
        CollectWithMeTableViewCellMode *mode =[[CollectWithMeTableViewCellMode alloc] init];
        mode =_rentModels[indexPath.row];
        NSData *imgData = [[NSData alloc]initWithBase64EncodedString:mode.icon options:NSDataBase64DecodingIgnoreUnknownCharacters];
        cell.icon.imageView.image =[UIImage imageWithData:imgData];
        
        cell.mode = mode;
        
        if (! [mode.userName isEqualToString:@""]) {
            cell.userName.text =mode.userName;
        }
        /*14求租  12出租  9卖车  13买车  10 求职  11 招聘*/
        cell.esayPresent.text =mode.esayPresent;
        cell.time.text =mode.time;
        
        NSInteger price = [mode.price intValue]*10000;
        NSString *textPrice = [NSString stringWithFormat:@"%ld",(long)price];
        
        cell.price.text =textPrice;
        cell.detailPresent.text =mode.detailPresent;
//        cell.useTime.text =mode.useTime;
        
        NSString *useTime1 = [NSString stringWithFormat:@"%@ 小时",mode.useTime];
        cell.useTime.text = useTime1;
        cell.mapText.text =mode.mapText;
        cell.xinghao.text = mode.aboutClassLableText;
//        cell.leixing.text = mode.cartype;
        
        if ([_catid isEqualToString:@"14"] || [_catid isEqualToString:@"13"]) {
            [cell.price setHidden:YES];
            [cell.pricehide1 setHidden:YES];
            [cell.pricehide2 setHidden:YES];
            [cell.timehide setHidden:YES];
            [cell.useTime setHidden:YES];
        }
        
        if ([mode.icon isEqualToString:@""]) {
            
        }else{
            NSData *igData = [[NSData alloc]initWithBase64EncodedString:mode.icon options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *headImg = [UIImage imageWithData:igData];
            [cell.icon setBackgroundImage:headImg forState:UIControlStateNormal];
        }
        
        if (mode.images.count !=0 && ![mode.images[0][@"image"] isEqualToString:@"0"]) {
            
            cell.imgArr = mode.images;

        }else{
            
            [cell.collectionView removeFromSuperview];
            
            cell.imgBackView = NULL;
            cell.collectionView = nil;

            cell.imgBackView.backgroundColor =[UIColor colorWithWhite:0 alpha:0];
        }
        return cell;
    }
    else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"childCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] init];
        }
        cell.textLabel.text = _childTittles[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_mainTable == tableView) {
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        if (username.length == 0) {
            [MBProgressHUD showError:@"请先登录"];
            self.tabBarController.selectedIndex = selectedIndexNum;
            return;
        }
        
        if ([_catid isEqualToString: @"9"] || [_catid isEqualToString: @"12"]) {
            
            CellViewController *detail =[[CellViewController alloc]init];
            detail.indexPath =indexPath;
            detail.type =_type;
            detail.mode =_rentModels[indexPath.row];
            detail.shouldHide = NO;
            detail.isFromCollect = NO;
            [self.navigationController pushViewController:detail animated:YES];
        }else {
            MyBuyDetailViewController *detail =[[MyBuyDetailViewController alloc]init];

            detail.type =_type;
            detail.mode =_rentModels[indexPath.row];
            detail.shouldHide = NO;
            detail.isFromCollect = NO;
            [self.navigationController pushViewController:detail animated:YES];
        }
    }
    else {
        
        MyButtonView *btn = _buttonViews[_selectedTag];

        switch (_selectedTag) {
            case 0://品牌
                if (indexPath.row == 0) {
                    
                    _machineParams.brand = @"品牌";
                }else{
                _machineParams.brand = _childTittles[indexPath.row];
                }
                
                [btn.optionLabel setText:_childTittles[indexPath.row]];
                break;
            case 1://价格
                if (indexPath.row == 0) {
                    
                    _machineParams.price = @"价格";
                }else {
                _machineParams.price = _childTittles[indexPath.row];
                    NSLog(@"%@",_machineParams.price);
                }
                
                [btn.optionLabel setText:_childTittles[indexPath.row]];
                break;
            case 2://省市
                if (indexPath.row == 0) {
                    
                    _machineParams.address = @"省市";
                }else {
                    _machineParams.address = _childTittles[indexPath.row];
                }
                
                [btn.optionLabel setText:_childTittles[indexPath.row]];
                break;
                
            default:
                break;
        }
        
        
        [self hideChildAndCover:YES];
        
        btn.isSelected = NO;
        [btn btnIsSelected];
        _selectedTag = 9;
        
        [self childTableRefreshData];
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
    [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_machine (id integer PRIMARY KEY, mode blob NOT NULL, machineid integer NOT NULL UNIQUE, cartype text NOT NULL,catid text NOT NULL);"];
}

- (void)addMachines
{
    for (int i = 0; i < _rentModels.count; i ++) {
        NSDictionary *dic = _modes[i];
        CollectWithMeTableViewCellMode * mo = _rentModels[i];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
        
        [self.db executeUpdateWithFormat:@"INSERT INTO t_machine(mode, machineid, cartype, catid) VALUES (%@, %@, %@, %@);", data, mo.ID, mo.cartype, _catid];
    }
}

- (void)readMachines
{
    FMResultSet *set = [self.db executeQueryWithFormat:@"SELECT * FROM t_machine WHERE catid=%@ AND cartype=%@ ORDER BY machineid DESC;", _catid, self.title];
    while (set.next) {
        NSData *data = [set objectForColumnName:@"mode"];
        NSDictionary *mode = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        [_modes addObject:mode];
        
        CollectWithMeTableViewCellMode *model = [[CollectWithMeTableViewCellMode alloc] initWithDict:mode];
        
        [_rentModels addObject:model];
        
        _sqCount ++;
    }
}

//- (void)readMachinesWithMinID:(NSString *)ID
//{
//    FMResultSet *set = [self.db executeQuery:@"SELECT * FROM t_machine LIMIT 0,10 WHERE catid=%@ AND machineid<%@ ORDER BY id DESC;",_catid, ID];
//    while (set.next) {
//        NSData *data1 = [set objectForColumnName:@"machine"];
//        NSData *data2 = [set objectForColumnName:@"mode"];
//        CollectWithMeTableViewCellMode *machine = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
//        NSMutableDictionary *mode = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
//        
//        [_rentModels addObject:machine];
//        [_modes addObject:mode];
//    }
//}
//
//- (void)readMachinesWithMaxID:(NSString *)ID
//{
//    FMResultSet *set = [self.db executeQuery:@"SELECT * FROM t_machine LIMIT 0,10 WHERE catid=%@ AND machineid>%@ ORDER BY machineid DESC;",_catid, ID];
//    while (set.next) {
//        NSData *data1 = [set objectForColumnName:@"machine"];
//        NSData *data2 = [set objectForColumnName:@"mode"];
//        CollectWithMeTableViewCellMode *machine = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
//        NSMutableDictionary *mode = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
//        
//        [_rentModels addObject:machine];
//        [_modes addObject:mode];
//    }
//}
#pragma mark - 提示动画
- (void)showStatusWith:(NSString *)status
{
    // 1.创建label                        qas
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
    
    [self.view insertSubview:label aboveSubview:_mainTable];
    
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

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [hd removeFromSuperview];
    
}

@end
