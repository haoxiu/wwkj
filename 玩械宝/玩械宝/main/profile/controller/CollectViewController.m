//
//  CollectViewController.m
//  玩械宝
//
//  Created by huangyangqing on 15/9/29.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//
#import "CollectWithMeTableViewCell.h"
#import "CollectViewController.h"
#import "CellViewController.h"
#import "CollectWithMeTableViewCellMode.h"
#import "DataService.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "RecruitmentTableViewCell.h"
#import "RecruitmentTableViewCellMode.h"
#import "RecruitmentTableViewCellModeZP.h"
#import "EmployeViewController.h"
#import "ApplyJobViewController.h"
#import "CollectViewMode.h"
#import "MJRefresh.h"
#import "MJRefreshHeader.h"
#import "runNewView.h"
#import "Header.h"

@interface CollectViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property BOOL cilckButtonWithWho;
@property (nonatomic,assign) int buttonTag;
@property (nonatomic,strong) NSArray *arr_0;
@property (nonatomic,strong) NSArray *arr_1;
@property (nonatomic,strong) UITableView *tableView_1;
@property (nonatomic,strong) UIButton *loadButton;
@property (nonatomic,strong) NSMutableArray *rentModels;
@property (nonatomic,strong) NSMutableArray *QModes;
@property (nonatomic,strong) NSMutableArray *ZModes;
@property (nonatomic,strong) NSMutableArray *modes;
@property (nonatomic, strong) runNewView *TabHead;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) AFHTTPRequestOperation *loadDataService;
@property (nonatomic) int page;
@property (nonatomic) int page1;
@property (nonatomic) int page2;
@property (nonatomic) int page3;
@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page =1;
    _page1 =1;
    _page2 =1;
    _page3 =1;
    _rentModels =[NSMutableArray array];
    _QModes =[NSMutableArray array];
    _modes =[NSMutableArray array];
    _ZModes =[NSMutableArray array];
    self.navigationController.navigationBarHidden =NO;
    self.view.backgroundColor =[UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _cilckButtonWithWho =YES;
    _arr_0 =@[@"大型挖掘机",@"小型挖掘机",@"装载机",@"推土机",@"起重机",@"压路机",@"混泥土设备",@"其他"];
    _arr_1 =@[@"我要出租",@"我要求租",@"我要卖车",@"我要买车",@"我要招聘",@"我要求职"];
    [self loadData];
    [self loadViews];
}




- (void)loadData{
    NSString *url;
    NSDictionary *params;
    
    if (_loadButton ==nil || _loadButton.tag ==0) {
        _page =_page3;
        if ([self.title isEqualToString:@"我的发布"]){
            url =@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_allfbmm";
        }else if ([self.title isEqualToString:@"我的收藏"]){
            url = @"http://eswjdg.com/index.php?m=mmapi&c=member&a=getsol";
        }else{
            url =@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_allshmm";
        }
        params = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"pagenow":@(_page)};
    }else if (_loadButton.tag ==1){
        _page =_page1;
        if ([self.title isEqualToString:@"等待审核"]) {
            url =@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_zparc";
            params =@{@"catid ":@10,@"status":@1,@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"pagenow":@(_page)};
        }else if ([self.title isEqualToString:@"我的发布"]){
            url =@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_zparc";
            params =@{@"catid ":@10,@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"pagenow":@(_page)};
        }else{
                url = @"http://eswjdg.com/index.php?m=mmapi&c=member&a=getsol";
                params = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"catid":@10};
            
            
            
//            url =@"http://eswjdg.com/index.php?m=mmapi&c=member&a=get_zparc";
//            params =@{@"catid ":@10,@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"pagenow":@(_page)};
        }
    }else {
        _page =_page2;
        if ([self.title isEqualToString:@"等待审核"]) {
            url =@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_yp";
            params =@{@"catid ":@11,@"status":@1,@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"pagenow":@(_page)};
        }else if ([self.title isEqualToString:@"我的发布"]){
            url =@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_yp";
            params =@{@"catid ":@11,@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"pagenow":@(_page)};
        }else{
            url = @"http://eswjdg.com/index.php?m=mmapi&c=member&a=getsol";
            params = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"catid":@11};
        }
    }
    _loadDataService = [DataService requestURL:url httpMethod:@"POST" params:params completion:^(id result)  {
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            [self runIsOK];
            _tableView.footer.hidden =YES;
            [_tableView.footer endRefreshing];
            return ;
        }
        else if ([result isKindOfClass:[NSArray class]]) {
            if (_loadButton ==nil || _loadButton.tag ==0) {
                for (NSDictionary *dic in result) {
                    CollectWithMeTableViewCellMode *model = [[CollectWithMeTableViewCellMode alloc]initWithDict:dic];
                    
                    [_rentModels addObject:model];
                    [_modes addObject:dic];
                    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        _page3++;
                        [self loadData];
                    }];
                }
            }else if (_loadButton.tag ==1){
                if  (_QModes.count !=0){
                    [_QModes removeAllObjects];
                }
                for (NSDictionary *dic in result) {
                    RecruitmentTableViewCellMode *mode =[[RecruitmentTableViewCellMode alloc]initWithDict:dic];
                    [_QModes addObject:mode];
                    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        _page1 ++;
                        [self loadData];
                    }];
                }
            }else{
                
                for (NSDictionary *dic in result) {
                    RecruitmentTableViewCellModeZP *mode =[[RecruitmentTableViewCellModeZP alloc]initWithDict:dic];
                    
                    [_QModes addObject:mode];
                    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        _page2 ++;
                        [self loadData];
                    }];
                }
            }
           // [SVProgressHUD showSuccessWithStatus:@"加载完成"];
            [_tableView reloadData];
            [self runIsOK];
        }
        else{
            [_tableView reloadData];
            _tableView.footer.hidden =YES;
            [_tableView.footer endRefreshing];
            //[SVProgressHUD showErrorWithStatus:@"暂无数据"];
            [self runIsOK];
        }
    }];
    
}
- (void)loadQData{
    NSString *url;
    NSDictionary *params;

    if ([self.title isEqualToString:@"等待审核"]) {
        if (_loadButton.tag ==1) {
            url =@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_zparc";
            params =@{@"catid ":@10,@"status":@1,@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]};
        }else{
            url =@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_yp";
            params =@{@"catid ":@11,@"status":@1,@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]};
        }
    }else if ([self.title isEqualToString:@"我的发布"]){
        if (_loadButton.tag ==1) {
            url =@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_zparc";
            params =@{@"catid ":@10,@"status":@99,@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]};
        }else{
            url =@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_yp";
            params =@{@"catid ":@11,@"status":@99,@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]};
        }
    }else{
        if (_loadButton.tag ==1) {
            url = @"http://eswjdg.com/index.php?m=mmapi&c=member&a=getsol";
            params = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"catid":@10};
        }else{
            url = @"http://eswjdg.com/index.php?m=mmapi&c=member&a=getsol";
            params = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"catid":@11};
        }
    }
    
    [DataService requestURL:url httpMethod:@"POST" params:params completion:^(id result) {
        if ([result isKindOfClass:[NSArray class]]) {
            for (NSDictionary *QMode  in result) {
               if (_loadButton.tag ==1){
                    RecruitmentTableViewCellMode *mode =[[RecruitmentTableViewCellMode alloc]initWithDict:QMode];
                    [_QModes addObject:mode];
               }else{
                   RecruitmentTableViewCellModeZP *mode =[[RecruitmentTableViewCellModeZP alloc]initWithDict:QMode];
                   [_QModes addObject:mode];
               }
            }
        }
    }];
    [_tableView reloadData];
    [self runIsOK];
    }
- (void)loadViews{
    _headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44+1)];
    _headView.backgroundColor =[UIColor clearColor];
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, _headView.bottom, self.view.width, self.view.height -64 -44-1 -44) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.tag =100;
    UIView *footView =[[UIView alloc]init];
    footView.backgroundColor =[UIColor clearColor];
    _tableView.tableFooterView =footView;
    [self setTabHeader];
    
    UIView *backView =[[UIView alloc]init];
    backView.backgroundColor =[UIColor clearColor];
    _tableView_1 =[[UITableView alloc]initWithFrame:CGRectMake(0, _tableView.top -320, _tableView.width, 320) style:UITableViewStylePlain];
    _tableView_1.delegate =self;
    _tableView_1.dataSource =self;
    _tableView_1.tag =101;
    _tableView_1.tableFooterView =backView;
    _tableView_1.backgroundColor =[UIColor clearColor];
    if ([_tableView_1 respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView_1 setSeparatorInset:UIEdgeInsetsZero];
    }
        
    if ([_tableView_1 respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView_1 setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    [self.view addSubview:_tableView];
    
    [self.view addSubview:_headView];
    for (int i =0; i <3; i++) {
        UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(i *(self.view.width/3.0 +0.5), 0, self.view.width/3.0 -0.5, 44)];
        btn.backgroundColor =[UIColor whiteColor];
        [btn setTitleColor:[UIColor colorWithRed:83/255.0 green:195/255.0 blue:135/255.0 alpha:1] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnCilck:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag =i;
        [_headView addSubview:btn];
        btn.titleLabel.font =[UIFont systemFontOfSize:14];
        if (i ==0) {
            btn.backgroundColor =[UIColor grayColor];
            _loadButton =btn;
            [btn setTitle:@"全部" forState:UIControlStateNormal];
        }
        else if (i ==1) {
            [btn setTitle:@"求职" forState:UIControlStateNormal];
        }else{
            [btn setTitle:@"招聘" forState:UIControlStateNormal];
        }
    }

    [self.view insertSubview:_tableView_1 belowSubview:_headView];
}
//按钮逻辑
- (void)typeButton:(UIButton *)button{
    
    if (button != _loadButton || !_loadButton) {
        _buttonTag =(int)button.tag;
        [_tableView_1 reloadData];
        if (_loadButton ==nil) {
            UIView *tView =[[UIView alloc]initWithFrame:CGRectMake(0, _tableView.top,_tableView.width,_tableView.height)];
            tView.tag =1000;
            tView.alpha =0;
            tView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.5];
            [self.view insertSubview:tView belowSubview:_tableView_1];
            [UIView animateWithDuration:.5 animations:^{
                _tableView_1.transform =CGAffineTransformMakeTranslation(0, 320);
                tView.alpha =1;
            }completion:^(BOOL finished) {
                
            }];
            _loadButton =button;
            _loadButton.selected =!_loadButton.selected;
        }else{
            _loadButton.selected =!_loadButton.selected;
            _loadButton =button;
            _loadButton.selected =!_loadButton.selected;
        }
    }else{
        [UIView animateWithDuration:.5 animations:^{
            _tableView_1.transform =CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            UIView *tView =[self.view viewWithTag:1000];
            [tView removeFromSuperview];
        }];
        button.selected =NO;
        _loadButton =nil;
    }
    
}

#pragma mark - tableView代理和数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag ==100) {
        if (_loadButton ==nil ||_loadButton.tag ==0) {
            return _rentModels.count;
        }else{
            return _QModes.count;
        }
        
    }else{
        if (_buttonTag ==0) {
            return _arr_0.count;
        }else{
            return _arr_1.count;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag ==100) {
        if (_rentModels.count !=0 && (_loadButton ==nil || _loadButton.tag==0)) {
            CollectViewMode *modeF =[[CollectViewMode alloc]initWithDict:_modes[indexPath.row]];
            return modeF.cellHeight;
        }else{
            return 40;
        }
    }else{
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_loadButton ==nil ||_loadButton.tag ==0){
        if (tableView.tag ==100) {
            static NSString *ID =@"IDENT";
            CollectWithMeTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell =[[NSBundle mainBundle] loadNibNamed:@"CollectWithMeTableViewCell" owner:nil options:nil][0];
            }
            CollectWithMeTableViewCellMode *mode =[[CollectWithMeTableViewCellMode alloc]init];
            mode =_rentModels[indexPath.row];
            NSData *imgData = [[NSData alloc]initWithBase64EncodedString:mode.icon options:NSDataBase64DecodingIgnoreUnknownCharacters];
            cell.icon.imageView.image =[UIImage imageWithData:imgData];
            cell.userName.text =mode.userName;
            if ([self.title isEqualToString:@"我的收藏"]) {
                cell.aboutClassLableText.text =mode.type;
                
                if ([mode.type isEqualToString:@"12"]) {
                    cell.aboutClassLableText.text =@"求租";
                    
                }else if ([mode.type isEqualToString:@"14"]){
                    cell.aboutClassLableText.text =@"出租";
                    
                }else if ([mode.type isEqualToString:@"13"]){
                    cell.aboutClassLableText.text =@"卖车";
                    
                }else if ([mode.type isEqualToString:@"9"]){
                    cell.aboutClassLableText.text =@"买车";
                    
                }else if ([mode.type isEqualToString:@"10"]){
                    cell.aboutClassLableText.text =@"求职";
                    
                }else{
                    cell.aboutClassLableText.text =@"招聘";
                }
            }else{
                cell.aboutClassLableText.text = mode.parentid;
                if ([cell.aboutClassLableText.text isEqualToString:@"12"]) {
                    cell.aboutClassLableText.text =@"求租";
                }else if ([cell.aboutClassLableText.text isEqualToString:@"14"]){
                    cell.aboutClassLableText.text =@"出租";
                }else if ([cell.aboutClassLableText.text isEqualToString:@"13"]){
                    cell.aboutClassLableText.text =@"卖车";
                }else if ([cell.aboutClassLableText.text isEqualToString:@"9"]){
                    cell.aboutClassLableText.text =@"买车";
                }else if ([cell.aboutClassLableText.text isEqualToString:@"10"]){
                    cell.aboutClassLableText.text =@"求职";
                }else{
                    cell.aboutClassLableText.text =@"招聘";
                }
            }
            /*12求租  14出租  13卖车  9买车  10 求职  11 招聘*/
            cell.esayPresent.text =mode.esayPresent;
            cell.time.text =mode.time;
            cell.price.text =mode.price;
            cell.detailPresent.text =mode.detailPresent;
            cell.useTime.text =mode.useTime;
            cell.mapText.text =mode.mapText;
            cell.xinghao.text = mode.aboutClassLableText;
            cell.leixing.text = mode.cartype;
            
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
            static NSString *ID =@"S1";
            UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                cell.backgroundColor =[UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1];
                cell.textLabel.font =[UIFont systemFontOfSize:13];
                cell.textLabel.textColor =[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
                if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
                    [cell setSeparatorInset:UIEdgeInsetsZero];
                }
                if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                    [cell setLayoutMargins:UIEdgeInsetsZero];
                }
            }
            if (_buttonTag ==0) {
                cell.textLabel.text =_arr_0[indexPath.row];
            }
            else{
                cell.textLabel.text =_arr_1[indexPath.row];
            }
            return cell;
        }
    }else{
        static NSString *ID =@"recruitment";
        RecruitmentTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell =[[NSBundle mainBundle] loadNibNamed:@"RecruitmentTableViewCell" owner:nil options:nil][0];
        }
        if (_loadButton.tag ==1) {
            RecruitmentTableViewCellModeZP *mode =[[RecruitmentTableViewCellModeZP alloc]init];
            mode =_QModes[indexPath.row];
            cell.address.text =mode.address;
            cell.year.text =mode.year;
            cell.kind.text =mode.kind;
        }else {
            RecruitmentTableViewCellMode *mode =[[RecruitmentTableViewCellMode alloc]init];
            mode =_QModes[indexPath.row];
            cell.address.text =mode.address;
            cell.year.text =mode.year;
            cell.kind.text =mode.kind;
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_loadButton ==nil || _loadButton.tag ==0) {
        CellViewController *cellView =[[CellViewController alloc]init];
        cellView.mode =_rentModels[indexPath.row];
        cellView.shouldHide =NO;
        [self.navigationController pushViewController:cellView animated:YES];
    }else if (_loadButton.tag ==2){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"profile" bundle:nil];
        EmployeViewController *empl = [sb instantiateViewControllerWithIdentifier:@"EmployeViewController"];
        empl.mode =_QModes[indexPath.row];
        [self.navigationController pushViewController:empl animated:YES];
    }else{
        ApplyJobViewController *job =[[UIStoryboard storyboardWithName:@"profile" bundle:nil] instantiateViewControllerWithIdentifier:@"ApplyJobViewController"];
        job.model =_QModes[indexPath.row];
        [self.navigationController pushViewController:job animated:YES];
    }
}

- (void)btnCilck:(UIButton *)button{
    
    [DataService cancelPreviousPerformRequestsWithTarget:self];
    if (_loadButton ==nil || _loadButton ==button) {
        _loadButton =button;
        button.backgroundColor =[UIColor grayColor];
        
    }else{
        [_loadDataService cancel];
        _loadButton.backgroundColor =[UIColor whiteColor];
        button.backgroundColor =[UIColor grayColor];
        _loadButton =button;
        if  (_rentModels.count !=0){
            [_rentModels removeAllObjects];
        }
        if (_modes.count !=0) {
            [_modes removeAllObjects];
        }
        if (_QModes.count !=0) {
            [_QModes removeAllObjects];
        }
        [self setTabHeader];
        [_tableView reloadData];
        [self loadData];
    }
}

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
    [UIView animateWithDuration:2.0 animations:^{
        _tableView.tableFooterView.transform =CGAffineTransformMakeScale(1, 0.1);
    } completion:^(BOOL finished) {
        _tableView.tableHeaderView =nil;
    }];
    }
}
@end
