//
//  MyPCWViewController.m
//  玩械宝
//
//  Created by echo on 11/15/15.
//  Copyright (c) 2015 zgcainiao. All rights reserved.
//

#import "MyPCWViewController.h"

#import "Header.h"
#import "CYNetworkTool.h"
#import "MBProgressHUD+NJ.h"
#import "UIImageView+WebCache.h"
#import "DataService.h"

#import "CollectViewMode.h"
#import "RecruitmentTableViewCell.h"
#import "RecruitmentTableViewCellModeZP.h"
#import "RecruitmentTableViewCellMode.h"

#import "CollectWithMeTableViewCellMode.h"
#import "CollectWithMeTableViewCell.h"
#import "CollectViewMode.h"
#import "CellViewController.h"

#import "ZhaoPinModel.h"
#import "EmployeModel.h"
#import "MachineModel.h"
#import "ApplyJobViewController.h"
#import "EmployeViewController.h"

#import "SDRefresh.h"
#import "MyBuyDetailViewController.h"

@interface MyPCWViewController ()<UITableViewDataSource,UITableViewDelegate>{

    NSInteger index;
    NSDictionary *params;
    NSString *delUrl;
}

@property (weak, nonatomic) IBOutlet UILabel *headLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UITableView *mainTable;

// 买车、卖车、出租、租车、招聘、求职 信息
@property (weak, nonatomic) IBOutlet UITableView *childTable;

@property (weak, nonatomic) IBOutlet UIButton *coverBtn;

@property (strong, nonatomic) NSMutableArray *models;
@property (strong, nonatomic) NSMutableArray *dics;
@property (strong, nonatomic) NSArray *childTittles;

@property (assign, nonatomic) BOOL isSelected;

/**0买车、1卖车、2出租、3租车、4招聘、5求职*/
@property (assign, nonatomic) int selectedTag;

@property (strong, nonatomic) NSArray *catids;

@property (copy, nonatomic) NSString *catid;

@property (copy, nonatomic) NSString *url;
@property (strong, nonatomic) NSDictionary *params;

@property (assign, nonatomic) int page;

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@end

@implementation MyPCWViewController
{
    MBProgressHUD *hd;
}
//页面返回时重新加载数据解决删除了的信息还在的情况
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_page!= 0)
    {
        _page --;
    }
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    self.navigationController.navigationBarHidden = NO;
    [self setViews];
    
    _url = [[NSString alloc] init];
    _params = [NSDictionary dictionary];
    
    _models = [NSMutableArray array];
    _dics = [NSMutableArray array];
    
    [self setUrlAndParams];
    [self loadData];
    
    [self setupFooter];
    [super viewDidLoad];
    
}
- (void)setViews
{
    [self hideCoverAndChild:YES andHighlightHeadLabelAndIcon:NO];
    _isSelected = NO;
    
    _childTittles = [NSArray arrayWithObjects:@"买车信息", @"卖车信息", @"出租信息", @"求租信息", @"招聘信息", @"求职信息", nil];
    _catids = [NSArray arrayWithObjects:@"13", @"9", @"12", @"14", @"10", @"11", nil];
    
    _selectedTag = 0;
    _catid = _catids[_selectedTag];
    _page = 1;
    
    UIView *footView = [[UIView alloc]init];
    
    _mainTable.tableFooterView = footView;
    
}

#pragma mark - childTable相关

- (IBAction)coverBtnClick:(id)sender {
    [self hideCoverAndChild:YES andHighlightHeadLabelAndIcon:NO];
}

- (IBAction)headButtonClick:(id)sender
{
    if (! _isSelected) {//第一次点击
        [self hideCoverAndChild:NO andHighlightHeadLabelAndIcon:YES];
        _isSelected = YES;
    } else {//第二次点击
        [self hideCoverAndChild:YES andHighlightHeadLabelAndIcon:NO];
        _isSelected = NO;
    }
}
- (void)hideCoverAndChild:(BOOL)ishide andHighlightHeadLabelAndIcon:(BOOL)isHighlight
{
    [_childTable setHidden:ishide];
    [_coverBtn setHidden:ishide];
    
    [_headLabel setHighlighted:isHighlight];
    [_iconImageView setHighlighted:isHighlight];
}

#pragma mark - 上拉下拉刷新数据
- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:_mainTable];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}
- (void)footerRefresh
{
    [self loadDataFooter:_url withParams:_params];
}
#pragma mark - loadData
- (void)setUrlAndParams
{
    switch (_flag) {
        case 1: //发布
        {
            if (_selectedTag == 4) {//招聘
                _url = @"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_zparc";
                
            } else if (_selectedTag == 5) {//求职
                _url = @"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_yp";
            }else {
                _url =@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_pub";
            }
            _params = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"catid":_catid, @"pagenow":@(_page)};
        }
            break;
        case 2: //收藏
        {
            _url =@"http://eswjdg.com/index.php?m=mmapi&c=member&a=getsol";
            
            if (_selectedTag == 4) {//招聘
                _catid = @"11";
            }else if (_selectedTag == 5) {
                _catid = @"10";
            }
            _params = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"catid":_catid, @"pagenow":@(_page)};
        }
            
            break;
        case 3: //等待审核
        {
            if (_selectedTag == 4) {//招聘
                _url = @"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_zparc";
                
            } else if (_selectedTag == 5) {//求职
                _url = @"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_yp";
            }else {
                _url =@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_pub";
            }
#warning 参数的顺序不能变化，否则会 返回全部catid的总数据
            _params = @{@"status":@1,@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"catid":_catid,@"pagenow":@(_page)};
        }
            break;
            
        default:
            break;
    }
}

- (void)loadData
{
    hd = [MBProgressHUD showMessage:@"正在加载"];
    hd.dimBackground = NO;
    
    [CYNetworkTool post:_url params:_params success:^(id json) {
        
                    if ([json isKindOfClass:[NSDictionary class]]) {
                        
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"暂无数据"];
                        hd.dimBackground = YES;
                        [hd removeFromSuperview];
                        
                        if (_models) {
                            [_models removeAllObjects];
                            [_dics removeAllObjects];
                        }
                    }
                    
                    if ([json isKindOfClass:[NSArray class]]) {
                        if (_models) {
                            [_models removeAllObjects];
                            [_dics removeAllObjects];
                        }

                        for (NSDictionary *dic in json) {
                            
                            if (_selectedTag == 5) {
                                RecruitmentTableViewCellModeZP * model = [[RecruitmentTableViewCellModeZP alloc] initWithDict:dic];
                                [_models addObject:model];
                            }else if (_selectedTag == 4)
                            {
                                RecruitmentTableViewCellMode *model = [[RecruitmentTableViewCellMode alloc] initWithDict:dic];
                                [_models addObject:model];
                                
                            }else {
                                CollectWithMeTableViewCellMode *model = [[CollectWithMeTableViewCellMode alloc] initWithDict:dic];
                                [_models addObject:model];
                            }
                            
                            [_dics addObject:dic];
                            
                        }
                    }
                    
                    _page ++;
        
                    [MBProgressHUD hideHUD];
                    [_mainTable reloadData];
                    [hd removeFromSuperview];

                } failure:^(NSError *error) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"网络异常"];
                    [hd removeFromSuperview];
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
                
                [_models addObject:model];
                [_dics addObject:dic];
            }
            
            [self.refreshFooter endRefreshing];
            [_mainTable reloadData];
            
            
            [self showStatusWith:@"加载完毕"];
        }
    } failure:^(NSError *error) {
        [self.refreshFooter endRefreshing];
        [MBProgressHUD showError:@"网络异常"];
    }];
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _childTable) {
        return 6;
    } else {
        return _models.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_mainTable == tableView) {
        if (_selectedTag == 4 || _selectedTag == 5) {
            //求职招聘
            return 40;
        } else {
            
            CollectViewMode *modeF =[[CollectViewMode alloc]initWithDict:_dics[indexPath.row]];
            return modeF.cellHeight;
        }
    }
    else {
        return 30;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _childTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"childCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] init];
        }
        cell.textLabel.text = _childTittles[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
        
    } else {
        if (_selectedTag == 4 || _selectedTag == 5) {
            
            //求职招聘
            static NSString * ID =@"recruitment";
            RecruitmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//            if (!cell) {
                cell =[[NSBundle mainBundle] loadNibNamed:@"RecruitmentTableViewCell" owner:nil options:nil][0];
//            }
            if (_selectedTag == 4) {
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
            
        } else {
            
            CollectWithMeTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"collectWithMeTableViewCell"];
            if (!cell) {
                cell =[[NSBundle mainBundle] loadNibNamed:@"CollectWithMeTableViewCell" owner:nil options:nil][0];
            }
            
            CollectWithMeTableViewCellMode *mode =[[CollectWithMeTableViewCellMode alloc] init];
            mode =_models[indexPath.row];
            NSData *imgData = [[NSData alloc]initWithBase64EncodedString:mode.icon options:NSDataBase64DecodingIgnoreUnknownCharacters];
            cell.icon.imageView.image =[UIImage imageWithData:imgData];

            cell.mode = mode;
            
            if (! [mode.userName isEqualToString:@""]) {
                cell.userName.text =mode.userName;
            }
            
            //12求租  14出租  13卖车  9买车  10 求职  11 招聘
            cell.esayPresent.text =mode.esayPresent;
            cell.time.text =mode.time;
            
            NSInteger price = [mode.price intValue]*10000;
            NSString *textPrice = [NSString stringWithFormat:@"%ld",(long)price];
            cell.price.text =textPrice;
            
            cell.detailPresent.text =mode.detailPresent;
            
            NSString *useTime1 = [NSString stringWithFormat:@"%@ 小时",mode.useTime];
            cell.useTime.text = useTime1;
            
            cell.mapText.text =mode.mapText;
            cell.xinghao.text = mode.aboutClassLableText;
//            cell.leixing.text = mode.cartype;
            
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
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _childTable) {
        if (_selectedTag != indexPath.row){//选中的不是已经显示的
            _selectedTag = (int)indexPath.row;
            [_headLabel setText:[NSString stringWithFormat:@"%@", _childTittles[_selectedTag]]];
            _catid = _catids[_selectedTag];
            
            //发送请求，刷新 mainTable
            _page = 1;
            [self setUrlAndParams];
            [self loadData];
            
        }
        [self hideCoverAndChild:YES andHighlightHeadLabelAndIcon:NO];
        _isSelected = NO;
        
    } else {
        if (_selectedTag == 5) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"profile" bundle:nil];
            //求职详情
            EmployeViewController *employeVC = [sb instantiateViewControllerWithIdentifier:@"EmployeViewController"];
            employeVC.mode = _models[indexPath.row];
//            employeVC.type = @"10";
            if (_flag == 3) {//等待审核
                employeVC.shouldHide = YES;
            }else {
                employeVC.shouldHide = NO;
            }
            
            if (_flag == 2) { //我的收藏
                employeVC.isFromCollect = YES;
            } else {
                employeVC.isFromCollect = NO;
            }
            [self.navigationController pushViewController:employeVC animated:YES];
        }
        else if (_selectedTag == 4){
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"profile" bundle:nil];
            //招聘详情
            ApplyJobViewController *applyVC = [sb instantiateViewControllerWithIdentifier:@"ApplyJobViewController"];
            applyVC.model = _models[indexPath.row];
//            applyVC.type = @"11";
            if (_flag == 3) {//等待审核
                applyVC.shouldHide = YES;
            }else {
                applyVC.shouldHide = NO;
            }
            if (_flag == 2) { //我的收藏
                applyVC.isFromCollect = YES;
            } else {
                applyVC.isFromCollect = NO;
            }
            [self.navigationController pushViewController:applyVC animated:YES];
            
        }else {
            if ([_catid isEqualToString: @"9"] || [_catid isEqualToString: @"12"]) {
            
            CellViewController *detail =[[CellViewController alloc]init];
            detail.indexPath =indexPath;
            detail.type =_catid;
            detail.mode =_models[indexPath.row];
            if (_flag == 3) {//等待审核
                detail.shouldHide = YES;
            }else {
            detail.shouldHide = NO;
            }
                if (_flag == 2) { //我的收藏
                    detail.isFromCollect = YES;
                } else { //我的发布
                    detail.isFromCollect = NO;
                }
                
            [self.navigationController pushViewController:detail animated:YES];
        }else {
            MyBuyDetailViewController *detail =[[MyBuyDetailViewController alloc]init];

            detail.type =_catid;
            detail.mode =_models[indexPath.row];
            if (_flag == 3) {//等待审核
                detail.shouldHide = YES;
            }else {
                detail.shouldHide = NO;
            }
            
            if (_flag == 2) { //我的收藏
                detail.isFromCollect = YES;
            } else {
                detail.isFromCollect = NO;
            }
            [self.navigationController pushViewController:detail animated:YES];
        }
        }
    }
}

// 解决复用问题
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *subViews = [cell.contentView subviews];
    [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark 侧滑删除
//单元格上面的删除,插入按钮被点击时,调用的方法
//此协议方法,实现后,左滑单元格会出现删除按钮
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        index = indexPath.row;
        
        [self deleteCode:&index];
        
    }
}

- (void)deleteCode:(NSInteger*)index{
    
        [[[UIAlertView alloc]initWithTitle:@"警告"
                                   message:@"确定删除此条消息？"
                                  delegate:self
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:@"确定", nil] show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
//    _selectedTag  1,2,3   _flag 1,2,3
    
    if (_selectedTag == 5) { //招聘
        
        RecruitmentTableViewCellModeZP *mode = _models[index];
        if (_flag == 3) { //等待审核
            
            delUrl = URL_DeleteZp;
            params = @{@"id":mode.ID};

        } else if (_flag == 2) {//我的收藏
            delUrl = URL_DeleteCollect;
            
            params = @{@"colid":mode.colid};
            
        }else{  //我的发布
        
            delUrl = URL_DeleteZp;
            params = @{@"id":mode.ID};

        }
        
    }else if (_selectedTag == 4){  //求职
    
        RecruitmentTableViewCellMode *mode = _models[index];
        if (_flag == 3) { //等待审核
            delUrl = URL_Deleteyp;
            params = @{@"id":mode.ID};

        } else if (_flag == 2) {//我的收藏
            delUrl = URL_DeleteCollect;
            params = @{@"colid":mode.colid};
            
        }else{  //我的发布
            delUrl = URL_Deleteyp;
            params = @{@"id":mode.ID};

        }
    }else{   //
    
        CollectWithMeTableViewCellMode *mode = _models[index];
        if (_flag == 3) { //等待审核
            delUrl = URL_DeletePub;
            params = @{@"id":mode.ID};
        } else if (_flag == 2) {//我的收藏
            delUrl = URL_DeleteCollect;
            
            params = @{@"colid":mode.colid};
            
        }else{  //我的发布
            
            delUrl = URL_DeletePub;
            params = @{@"id":mode.ID};
        }
    }
    
    if (buttonIndex == 1) {

        [DataService requestURL:delUrl httpMethod:@"POST" params:params completion:^(id result) {
            
//            NSLog(@"%@",result);
            if ([result[@"state"] isEqualToNumber:@1]) {
                
                [_models removeObjectAtIndex:index];
                [self.mainTable reloadData];
            }
            else {
                
            }
        }];
        
        
    }
        
}

    



#pragma mark - 提示动画
- (void)showStatusWith:(NSString *)status{
    
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


//视图切换时加载视图移除
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [hd removeFromSuperview];
    
}

@end
