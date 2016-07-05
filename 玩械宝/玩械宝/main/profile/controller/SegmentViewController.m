//
//  SegmentViewController.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/16.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "SegmentViewController.h"

#import "ProfileTableView.h"
#import "DataService.h"
#import "MachineModel.h"
#import "SVProgressHUD.h"
#import "JobTableView.h"
#import "EmployeModel.h"
#import "ZhaoPinTableView.h"
#import "HMSegmentedControl.h"

@interface SegmentViewController ()
{
    HMSegmentedControl *segctrl1;
    UIScrollView *scrollerView;
    NSInteger _lastIndex;
}
@end

@implementation SegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIDevice currentDevice].systemVersion floatValue]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self _loadData];
    [self loadViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

// 加载第一个tableview的数据
- (void)_loadData {
    _rentModels = [NSMutableArray array];
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSString *url;
    NSDictionary *params;
    if (_type == MyCollection) {
        url = @"http://eswjdg.com/index.php?m=mmapi&c=member&a=getsol";
        params = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"catid":@12};
    }
    else {
        url = @"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_pub";
        if (_type == WaitCheck) {
            
            params = @{@"status":@1,@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"catid":@12};
        }
        else {
            params = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"catid":@12};
        }
    }
    [DataService requestURL:url httpMethod:@"POST" params:params completion:^(id result) {
        
        if ([result isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dic in result) {
                
                MachineModel *model = [[MachineModel alloc]initContentWithDic:dic];
                [_rentModels addObject:model];
            }
            
            ProfileTableView *tableView = (ProfileTableView *)[scrollerView viewWithTag:100];
            if (_type == MyCollection) {
                
                tableView.type = @"check";
            }
            tableView.models = _rentModels;
            [SVProgressHUD showSuccessWithStatus:@"加载完成"];
        }
        
        else  {
            [SVProgressHUD showErrorWithStatus:@"暂无数据"];
        }
    }];

}
- (void)loadViews {
    
    
    segctrl1 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"全部",@"我要招聘",@"我要求职"]];
    [segctrl1 setFrame:CGRectMake(0, 0,kScreenWidth, 35)];
    [segctrl1 setSelectionStyle:HMSegmentedControlSelectionStyleFullWidthStripe];
    [segctrl1 setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
    [segctrl1 setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [segctrl1 setSelectedTitleTextAttributes:@{NSForegroundColorAttributeName:kNaviColor}];
    [segctrl1 addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];
    [segctrl1 setTag:1];
    [self.view addSubview:segctrl1];
    
    
    
//        segctrl1.selectedIndicatorColor = kNaviColor;
//    segctrl1.selectedTextColor = [UIColor blueColor];
//    segctrl1.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
//    segctrl1.selectedBackgroundColor = segctrl1.backgroundColor;
//    segctrl1.allowNoSelection = NO;
//    segctrl1.frame = CGRectMake(0, 0,kScreenWidth, 35);
//    segctrl1.indicatorThickness = 4;
//    [segctrl1 addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:segctrl1];
    

    scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, segctrl1.bottom+3, kScreenWidth, kScreenHeight-segctrl1.bottom-64)];
    scrollerView.backgroundColor = [UIColor redColor];
    scrollerView.bounces = NO;
    scrollerView.pagingEnabled = YES;
    scrollerView.delegate = self;
    scrollerView.contentSize = CGSizeMake(scrollerView.width * 6, scrollerView.height);
    [self.view addSubview:scrollerView];
   /* 
    12求租
    14出租
    9卖车
    13买车
    10 求职
    11 招聘
    */
    NSArray *types = @[@"",@"11",@"10"];
    for (int i = 0; i< 6; i++) {
        
        if (i == 5) {
            
            JobTableView *tableView = [[JobTableView alloc]initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, scrollerView.height)];
            tableView.tag = i+100;
            tableView.type = types[i];
            [scrollerView addSubview:tableView];
        }
        else if(i == 4) {
            
            ZhaoPinTableView *tableView = [[ZhaoPinTableView alloc]initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, scrollerView.height)];
            tableView.tag = i+100;
            tableView.type = types[i];
            [scrollerView addSubview:tableView];
        }
        else {
            ProfileTableView *tableView = [[ProfileTableView alloc]initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, scrollerView.height)];
            tableView.tag = i+100;
            tableView.type = types[i];
            [scrollerView addSubview:tableView];
        }
    }

}

#pragma mark UIScrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView != scrollerView) {
        return;
    }
    NSInteger index = scrollerView.contentOffset.x/scrollerView.width;
//    if (index != segctrl1.selectedSegmentIndex) {
//    if (index != _lastIndex) {
    
        [segctrl1 setSelectedSegmentIndex:index animated:YES];
        [self _loadData:index];
        _lastIndex = index;
//    }
//    }
}

// 分段视图点击事件
- (void)segmentCtrlValuechange:(HMSegmentedControl *)segment {
    
    
    [scrollerView setContentOffset:CGPointMake(scrollerView.width*segment.selectedSegmentIndex, 0) animated:YES];
    [self _loadData:segment.selectedSegmentIndex];
    
}

// 加载当前显示的tableview的数据
- (void)_loadData:(NSInteger)index {
    
    NSString *url;
    NSDictionary *params;
    NSNumber *catId;
    NSString *a;
    switch (index) {
        case 0:
            catId = @12;
            a = @"get_pub";
            break;
        case 1:
            catId = @14;
            a = @"get_pub";
            break;
        case 2:
            catId = @9;
            a = @"get_pub";
            break;
        case 3:
            catId = @13;
            a = @"get_pub";
            break;
        case 4:
            catId = @11;
            a = @"get_zparc";
            break;
        case 5:
            catId = @10;
            a= @"get_yp";
            break;
        default:
            break;
    }
    /*
     12求租
     14出租
     9卖车
     13买车
     10 求职
     11 招聘
     */

    if (_type == MyCollection) {
        url = @"http://eswjdg.com/index.php?m=mmapi&c=member&a=getsol";
        params = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"catid":catId};
    }
    else {
        url = [NSString stringWithFormat:@"http://eswjdg.com/index.php?m=mmapi&c=sale&a=%@",a];
        if (_type == WaitCheck) {
            
            params = @{@"status" :@1,@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"catid":catId};
        }
        else {
            
            params = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"catid":catId};
        }
    }
    
    
    [SVProgressHUD showWithStatus:@"正在加载"];
    [DataService requestURL:url httpMethod:@"POST" params:params completion:^(id result) {
        if ([result isKindOfClass:[NSArray class]]) {
             _rentModels = [NSMutableArray array];
            
            // 我要求职
            if ([catId isEqualToNumber:@10]) {
                JobTableView *tableView = (JobTableView *)[scrollerView viewWithTag:100+index];
                for (NSDictionary *dic in result) {
                    
                    EmployeModel *model = [[EmployeModel alloc]initContentWithDic:dic];
                    [_rentModels addObject:model];
                }
                tableView.models = _rentModels;
            }
            else if ([catId isEqualToNumber:@11]) {
                
                ZhaoPinTableView *tableView = (ZhaoPinTableView *)[scrollerView viewWithTag:100+index];
                tableView.type = [catId stringValue];
                for (NSDictionary *dic in result) {
                    
                    ZhaoPinModel *model = [[ZhaoPinModel alloc]initContentWithDic:dic];
                    [_rentModels addObject:model];
                }
                tableView.models = _rentModels;

            }
            // 其他
            else{
                ProfileTableView *tableView = (ProfileTableView *)[scrollerView viewWithTag:100+index];
                if (_type == MyCollection) {
                    
                    tableView.type1 = @"check";
                }
                for (NSDictionary *dic in result) {
                    MachineModel *model = [[MachineModel alloc]initContentWithDic:dic];
                    [_rentModels addObject:model];
                }
                tableView.models = _rentModels;
            }
            [SVProgressHUD showSuccessWithStatus:@"加载完成"];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"暂无数据"];
        }
    }];
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
