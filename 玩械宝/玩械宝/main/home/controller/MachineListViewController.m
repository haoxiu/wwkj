//
//  MachineListViewController.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/26.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "MachineListViewController.h"
#import "HeadView.h"
#import "DataService.h"
#import "SVProgressHUD.h"
#import "UserInfoViewController.h"
#import "MachineDetailViewController.h"
#import "MJRefresh.h"
#import "CellViewController.h"
#import "CollectWithMeTableViewCell.h"
#import "CollectWithMeTableViewCellMode.h"
#import "UIImageView+WebCache.h"
#import "CollectViewMode.h"
#import "runNewView.h"

#import "LcPrint.h"
#import "LcPrint+LLDB.h"

@interface MachineListViewController ()
{
    NSMutableArray *_machines;
    UIView *head;
    UITableView *_tableView;    // 机器列表
    UITableView *_chooseTable;  // 选项列表
    UIView *searchView;         // 搜索视图
    NSMutableArray *marr;
    int page;
    int number;
}
@property (strong, nonatomic) NSMutableArray *rentModels;
@property (strong, nonatomic) NSMutableArray *modes;
@property (strong, nonatomic) NSMutableArray *IDArr;
@property (strong, nonatomic) runNewView *TabHead;
@end

@implementation MachineListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _rentModels =[NSMutableArray array];
    _modes =[NSMutableArray array];
    _IDArr =[NSMutableArray array];
    [self loadSc];
    [self loadData];
    [_tableView header];
    [self loadSubviews];
    
}

- (void)loadSc{
    NSDictionary * params = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]};
    NSString *url =@"http://eswjdg.com/index.php?m=mmapi&c=member&a=getsol";
    [DataService requestURL:url httpMethod:@"POST" params:params completion:^(id result)  {
        if ([result isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in result) {
                [_IDArr addObject:dic[@"id"]];
            }
        }else{
            return ;
        }
    }];

}

- (void)loadSubviews {
    page = 1;
    // 导航栏搜索按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(showSearch)];

    self.navigationItem.rightBarButtonItem = rightItem;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 头部按钮视图
    head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 35)];
    [self.view addSubview:head];
    head.backgroundColor =[UIColor whiteColor];
    CGFloat width = head.width/4;
    NSArray *titles = @[@"品牌",@"价格",@"省市",@"排序"];
    marr = [NSMutableArray arrayWithArray:titles];
    // 按钮
    for (int i = 0; i < 4; i++) {
        
        UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(i*width, 0, width, head.height)];
        [control addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        control.tag = 100+i;
        control.highlighted = YES;
        [head addSubview:control];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, control.width-25, control.height)];
        title.text = titles[i];
        title.font = [UIFont systemFontOfSize:12];
        title.textAlignment = NSTextAlignmentRight;
        title.tag = 2;
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(title.right+2, 10, 40, control.height)];
        imgView.image = [UIImage imageNamed:@"xiala"];
        imgView.tag = 1;
        [control addSubview:imgView];
        [control addSubview:title];
    }
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, head.bottom-2, head.width, 2)];
    line.backgroundColor = kNaviColor;
    [head addSubview:line];
    
    // 机器列表
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, head.bottom, self.view.width, self.view.height-head.y-49-44)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setTabHeader];
    [self.view addSubview:_tableView];
    
    UIView *foot = [[UIView alloc]init];
    foot.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = foot;
    
    UINib *nib = [UINib nibWithNibName:@"machineCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"machineCell"];
}

// 首次进入加载数据
- (void)loadData {
    
    [SVProgressHUD showWithStatus:@"加载中。。。"];
    NSDictionary *params = @{@"order":@"排序",@"price":@"价格",@"cartype":self.title,@"catid":_catid,@"brand":@"品牌",@"address":@"省市",@"pagenow":@1};

    
    [DataService requestURL:@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_pub" httpMethod:@"POST" params:params completion:^(id result) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            [SVProgressHUD showErrorWithStatus:@"暂无数据"];
            [_TabHead stopActivity:@"加载完成"];
            [UIView animateWithDuration:2.0 animations:^{
                
            } completion:^(BOOL finished) {
                _tableView.tableHeaderView =nil;
            }];
            return ;
        }
        
       
        if ([result isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dic in result) {
                
//                NSLog(@"++++++++++++++%@",[dic objectForKey:@"id"]); 
                CollectWithMeTableViewCellMode *model = [[CollectWithMeTableViewCellMode alloc]initWithDict:dic];
                
                
                [_rentModels addObject:model];
                [_modes addObject:dic];
            }
        }
        [_tableView reloadData];
        _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            page ++;
            [self loadMore];
        }];
        //[SVProgressHUD showSuccessWithStatus:@"加载完成"];
        [_TabHead stopActivity:@"加载完成"];
        [UIView animateWithDuration:2.0 animations:^{
            
        } completion:^(BOOL finished) {
            _tableView.tableHeaderView =nil;
        }];
        
        
//        [NSThread detachNewThreadSelector:@selector(refreshUI) toTarget:self withObject:nil];
        
    }];
}

- (void)loadMore {
    [SVProgressHUD showWithStatus:@"加载中。。。"];
    
    NSDictionary *params = @{@"order":@"排序",@"price":@"价格",@"cartype":self.title,@"catid":_catid,@"brand":@"品牌",@"address":@"省市",@"pagenow":@(page)};
    
    [DataService requestURL:@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_pub" httpMethod:@"POST" params:params completion:^(id result) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            [SVProgressHUD showErrorWithStatus:@"暂无更多数据"];
            _tableView.footer.hidden = YES;
            return ;
        }
        
        if ([result isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in result) {
                MachineModel *model = [[MachineModel alloc]initContentWithDic:dic];
                [_machines addObject:model];
            }
        }
        [_tableView reloadData];
        [_tableView.footer endRefreshing];
//        [SVProgressHUD showSuccessWithStatus:@"加载完成"];
        //        [NSThread detachNewThreadSelector:@selector(refreshUI) toTarget:self withObject:nil];
        
    }];

}
- (void)refreshUI {
}
// 显示搜索视图
- (void)showSearch {
    
    // 首次，创建
    if (searchView == nil) {
        
        searchView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.view.width-20, 35)];
        searchView.layer.borderWidth = 1;
        searchView.layer.cornerRadius = 10;
        searchView.layer.borderColor = [UIColor whiteColor].CGColor;
        searchView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        UITextField *searchTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, searchView.width-60, searchView.height)];
        searchTF.borderStyle = UITextBorderStyleNone;
        searchTF.placeholder = @"搜索";
        searchTF.tag = 5;
#warning returnKeyType返回键
        searchTF.returnKeyType = UIReturnKeySearch;
        searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        [searchView addSubview:searchTF];
        
        searchTF.delegate = self;
        
        UIImageView *searchImg = [[UIImageView alloc]initWithFrame:CGRectMake(searchTF.right+5, (searchView.height-30)/2, 30, 30)];
        searchImg.image = [UIImage imageNamed:@"serch"];
        searchImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(search)];
        [searchImg addGestureRecognizer:tap];
        [searchView addSubview:searchImg];
        
        [self.view insertSubview:searchView belowSubview:head];
        [UIView animateWithDuration:.3 animations:^{
#warning transform改变 
//            CGAffineTransformMakeTranslation每次都是以最初位置的中心点为起始参照
//            CGAffineTransformTranslate每次都是以传入的transform为起始参照
//            CGAffineTransformIdentity为最初状态，即最初位置的中心点
            searchView.transform = CGAffineTransformMakeTranslation(0, 35);
            _tableView.transform = CGAffineTransformMakeTranslation(0, 35);
        }];
    }
    // 上/下移动
    else {
    
        if (searchView.y == 35) {
            [self.view endEditing:YES];
            [UIView animateWithDuration:.3 animations:^{
            searchView.transform = CGAffineTransformIdentity;
            _tableView.transform = CGAffineTransformIdentity;
            }];
        }
        else {
            [UIView animateWithDuration:.3 animations:^{
                
                searchView.transform = CGAffineTransformMakeTranslation(0, 35);
                _tableView.transform = CGAffineTransformMakeTranslation(0, 35);
            }];

        }
    }
}

// 搜索
- (void)search{
    
    UITextField *tf = (UITextField *)[searchView viewWithTag:5];
    NSString *keyword = tf.text;
    if (keyword.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入关键字"];
        return;
    }
    [self.view endEditing:YES];
    [UIView animateWithDuration:.3 animations:^{
        searchView.transform = CGAffineTransformIdentity;
        _tableView.transform = CGAffineTransformIdentity;
    }];
    [SVProgressHUD showWithStatus:@"搜索中。。。"];
    NSDictionary *params = @{@"order":marr[3],@"price":marr[1],@"cartype":self.title,@"catid":_catid,@"brand":marr[0],@"address":marr[2],@"keyword":keyword};
    [DataService requestURL:@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_pub" httpMethod:@"POST" params:params completion:^(id result) {
       
        _machines = [NSMutableArray array];
        [_tableView reloadData];
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            [SVProgressHUD showErrorWithStatus:@"未找到"];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:nil];
        for (NSDictionary *dic in result) {
            
            MachineModel *model = [[MachineModel alloc]initContentWithDic:dic];
            [_machines addObject:model];
        }
        [_tableView reloadData];
    }];
}

// 头部按钮点击事件
- (void)buttonAction:(UIControl *)control {
    
    [_chooseTable removeFromSuperview];
    _chooseTable = nil;
    _chooseTable = [[UITableView alloc]initWithFrame:CGRectMake(0, self.view.height, self.view.width, 150)];
    _chooseTable.delegate = self;
    _chooseTable.dataSource = self;
    _chooseTable.bounces = NO;
    UIView *foot = [[UIView alloc]init];
    foot.backgroundColor = [UIColor clearColor];
    _chooseTable.tableFooterView = foot;
    [_chooseTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"chooseCell"];
    [self.view addSubview:_chooseTable];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        _chooseTable.transform = CGAffineTransformMakeTranslation(0, -150);
        
    } completion:NULL];
    
    _index = control.tag -100;
        switch (_index) {
            case 0:{
                NSLog(@"品牌");
                self.name = @"选择品牌";
                self.datas = [NSMutableArray array];
                [DataService requestURL:@"http://eswjdg.com/index.php?m=mmapi&c=index&a=get_cat" httpMethod:@"POST" params:@{@"catid":self.catid} completion:^(id result) {
                    for (NSDictionary *dic in result) {
                        [self.datas addObject:dic[@"catname"]];
                    }
                    [_chooseTable reloadData];
                }];
            }
                break;
                
            case 1:
                _datas = [NSMutableArray arrayWithObjects:@"不限",@"10万以下",@"10-15万",@"15-35万",@"35万以上", nil];
                [_chooseTable reloadData];
                _name = @"选择价格";
                
                break;
                
            case 2:{
                _name = @"选择省市";
                _datas = [NSMutableArray array];
                [DataService requestURL:@"http://eswjdg.com/index.php?m=mmapi&c=member&a=getpro" httpMethod:@"POST" params:@{@"m":@"mmapi",@"c":@"member",@"a":@"getpro"} completion:^(id result) {
                    
                    for (NSDictionary *dic in result) {
                        
                        [_datas addObject:dic[@"name"]];
                    }
                    [_chooseTable reloadData];
                }];
            }
                break;
                
            default:
                _name = @"选择排序方式";
                _datas = [NSMutableArray arrayWithObjects:@"默认",@"价格",@"小时数",@"发布时间", nil];
                [_chooseTable reloadData];
                break;
        }
}

#pragma mark - UITableView delegate
// 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableView) {
        CollectViewMode *modeF =[[CollectViewMode alloc]initWithDict:_modes[indexPath.row]];
        return modeF.cellHeight;
    }
    else {
        return 40;
    }
}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _tableView) {
        
        return _rentModels.count;
    }
    else {
        return _datas.count;
    }
}

// 返回单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  

    if (tableView == _tableView) {
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
      
        //传值
        cell.mode = mode;

        /*12求租  14出租  13卖车  9买车  10 求职  11 招聘*/
        cell.esayPresent.text =mode.esayPresent;
        cell.time.text =mode.time;
        cell.price.text =mode.price;
        cell.detailPresent.text =mode.detailPresent;
        cell.useTime.text =mode.useTime;
        cell.mapText.text =mode.mapText;
        cell.xinghao.text = mode.aboutClassLableText;
//        cell.leixing.text = mode.cartype;
        
        

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
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chooseCell" forIndexPath:indexPath];
        cell.textLabel.text = _datas[indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        return cell;
    }
}

// 选中行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _tableView) {
        CellViewController *detail =[[CellViewController alloc]init];
        detail.indexPath =indexPath;
        detail.type =_type;
        detail.mode =_rentModels[indexPath.row];
        detail.shouldHide =YES;
//        CollectWithMeTableViewCell *cell =[[CollectWithMeTableViewCell alloc]init];
        [self.navigationController pushViewController:detail animated:YES];

    }
    else {
        
        UIControl *control = (UIControl *)[head viewWithTag:_index+100];
        UILabel *label = (UILabel *)[control viewWithTag:2];
        label.text = [NSString stringWithFormat:@"%@",_datas[indexPath.row]];
        [UIView animateWithDuration:0.15 animations:^{
           
            tableView.transform = CGAffineTransformIdentity;
        }];
        // 保存头视图各按钮的标题
        marr = [NSMutableArray array];
        for (int i = 100; i<104; i++) {
            
            UIControl *control = (UIControl *)[head viewWithTag:i];
            UILabel *label = (UILabel *)[control viewWithTag:2];
            [marr addObject:label.text];
        }
        [SVProgressHUD showWithStatus:@"正在刷新"];
        NSDictionary *params = @{@"order":marr[3],@"price":marr[1],@"cartype":self.title,@"catid":_catid,@"brand":marr[0],@"address":marr[2]};
        [DataService requestURL:@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_pub" httpMethod:@"POST" params:params completion:^(id result) {
            
            _rentModels = [NSMutableArray array];
            [_tableView reloadData];
            if ([result isKindOfClass:[NSDictionary class]]) {
                
                [SVProgressHUD showErrorWithStatus:@"暂无数据"];
                return ;
            }
            [SVProgressHUD showSuccessWithStatus:nil];
            for (NSDictionary *dic in result) {
                
                CollectWithMeTableViewCellMode *model = [[CollectWithMeTableViewCellMode alloc]initWithDict:dic];
                [_rentModels addObject:model];
            }
            [_tableView reloadData];

        }];
    }
}

// 组头标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == _chooseTable) {
        return _name;
    }
    else {
        return nil;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self search];
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void) setTabHeader{
    _TabHead =[[runNewView alloc]initWithFrame:CGRectMake(0, 0, _tableView.width, 40)];
    _tableView.tableHeaderView =_TabHead;
}

@end
