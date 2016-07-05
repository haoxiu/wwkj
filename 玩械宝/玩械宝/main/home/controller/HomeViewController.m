//
//  HomeViewController.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/11.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//
#define  KBox 5

#import "HomeViewController.h"
#import "DataService.h"
#import "HomeShow.h"
#import "BarItem.h"
#import "ChooseView.h"
#import "MachineListViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "SVProgressHUD.h"
#import "JobViewController.h"
#import "JXJobViewController.h"
#import "KindBtn.h"
#import "mapModel.h"

#import "UINavigationController+CY.h"
#import "Header.h"
#import "MyHomeMachineViewController.h"
#import "MyHomeJobViewController.h"


@interface HomeViewController (){
    HomeShow *_showView;
    UIPageControl *_page;
    ChooseView *_chooseView;
    CGFloat _maxY;
    KindBtn *_lastItem;
    //BarItem *_lastItem;
    int page;
    BOOL _isDCilck;//大类点击
    BOOL _isSCilck;//小类点击
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"玩械宝";
    
    //设置其他视图的伸展不到这里
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
#warning 小类名称---------------------------------------
    
    _titles = @[@"大型挖掘机",@"小型挖掘机",@"推土机",@"压路机",@"起重机",@"装载机",@"混凝土设备",@"其他"];
    
    [self _loadViews];
    [self _loadShowImg];
}


// 加载视图
- (void)_loadViews {

    // 分享按钮
     UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
     [btn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
     // 设置图片
     [btn setBackgroundImage:[UIImage imageNamed:@"share_icon.png"] forState:UIControlStateNormal];
     
     // 设置尺寸
     btn.width = btn.currentBackgroundImage.size.width;
     btn.height = btn.currentBackgroundImage.size.height;
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    
    // 滑动视图
    _showView = [[HomeShow alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 255/1334.0 *self.view.height+25)];
    _showView.contentSize = CGSizeMake(_showView.width *2, _showView.height);
    _showView.pagingEnabled = YES;
    _showView.bounces = NO;
    _showView.showsHorizontalScrollIndicator = NO;
    _showView.showsVerticalScrollIndicator = NO;
    _showView.delegate = self;
    _showView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_showView];
 
#warning ----------2
    UIView * centerView =[[UIView alloc]initWithFrame:CGRectMake(0, _showView.bottom, self.view.width, KBox +20 +KBox +self.view.height *0.12*2)];
    
    centerView.backgroundColor =[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    
    [self.view addSubview:centerView];
    
    
    NSArray * imgName =@[@"big_excavator_button",@"small_excavator_button",@"bulldozer_button",@"road_rollers_button",@"crane_button.png",@"loader_button",@"concrete_button",@"other_button"];
    
    //下面的分类的小图标
    for (int i =0; i< 8; i++) {
        KindBtn * btn =[[KindBtn alloc]initWithFrame:CGRectMake(i%4*(self.view.width/4 +0.3),centerView.bottom+i/4*(self.view.height*0.11 +0.3),(self.view.width -3*0.3)/4,self.view.height*0.11) title:_titles[i] image:imgName[i]];
        
        btn.imgView.frame =CGRectMake(btn.width*0.5 -70/187.0*btn.width*0.5, btn.height*0.5 -60/187.0*btn.width+7, 60/187.0 *btn.width, 60/187.0 *btn.width);

        [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        btn.titleLabel_New.textColor =[UIColor blackColor];
        btn.titleLabel_New.font = [UIFont systemFontOfSize:13];
        
        btn.backgroundColor = [UIColor whiteColor];
        
        
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        btn.tag =i;
    }
    UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(0, [self.view viewWithTag:5].bottom +1, self.view.width, self.view.height -[self.view viewWithTag:5].bottom -1)];
    backView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:backView];
    
    // 分页视图
    _page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 36, 16)];
    [centerView addSubview:_page];
    _page.pageIndicatorTintColor = [UIColor grayColor];
    _page.center = CGPointMake(centerView.center.x, 0.5 *_page.height);
    [_page addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    
#warning --------------------1
    _page.currentPageIndicatorTintColor = [UIColor colorWithRed:0/255.0 green:191/255.0 blue:255/255.0 alpha:1];

#warning 大类按钮®
    // 选择按钮
    NSArray *titles = @[@"我要求租",@"我要买车",@"我要求职",@"我要出租",@"我要卖车",@"我要招聘"];
    NSArray *imgs = @[@"for_rent_button",@"buy_car_button",@"job_seekers_button",@"rental_button",@"sell_car_button",@"hands_wanted_button"];
   // NSArray *selectedImgs = @[@"index_image_woyaoqiuzu",@"index_imge_woyaomaiche",@"index_image_qiuzhi",
                              //@"index_iamge_woyaochuzu",@"index_image_woyaomche",@"index_image_zhaoping"];
    
    float itemW =(self.view.width -2*KBox -4*KBox)/3;
    for (int i = 0; i < 6; i++) {
        
        KindBtn *item =[[KindBtn alloc]initWithFrame:CGRectMake(i%3 *(itemW +KBox) +2*KBox,_showView.bottom +_page.bottom +i/3 *(self.view.height *0.12 +KBox), itemW,self.view.height *0.12) title:titles[i] image:imgs[i]];
         item.titleLabel_New.font = [UIFont systemFontOfSize:14];
        switch (i) {
            case 0:
                //item.backgroundColor =[UIColor colorWithRed:1 green:100/255.0 blue:96/255.0 alpha:1];
                item.backgroundColor = CYBtnRedColor;
                
                _lastItem =item;
                break;
            case 1:
                item.backgroundColor =CYNavColor;
                break;
            case 2:
                item.backgroundColor =[UIColor colorWithRed:125/255.0 green:174/255.0 blue:249/255.0 alpha:1];
                break;
            case 3:
                item.backgroundColor =CYNavColor;
                break;
            case 4:
                item.backgroundColor =CYNavColor;
                break;
            case 5:
                item.backgroundColor =[UIColor colorWithRed:125/255.0 green:174/255.0 blue:249/255.0 alpha:1];
            default:
                break;
        }
        item.tag = 200+i;
        
        [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:item];
        _maxY = item.bottom;
    }
    // 开启定时器
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
}

// 加载轮播图数据
- (void)_loadShowImg {
    
    __block BOOL index = YES ;
    
    NSDictionary *params = @{@"m":@"mmapi",@"c":@"index",@"a":@"poster"};
    [DataService requestURL:@"http://eswjdg.com/index.php" httpMethod:@"POST" params:params completion:^(id result) {
       
        NSMutableArray *temp = [NSMutableArray array];
        if ([result isKindOfClass:[NSArray class]]) {
            
        }
        for (NSDictionary *dic in result) {
            
            NSString *urlString = [NSString stringWithFormat:@"%@%@",@"http://eswjdg.com",dic[@"imageurl"]];
            [temp addObject:urlString];
        }
        _showView.imgs = temp;
        _page.numberOfPages = temp.count;
        index = NO;
    }];
    
    if (index) {
        
        NSArray *imgArr = @[@"20150814110640113.jpg",@"20150814110701279.jpg",@"20150814110640113.jpg",@"20150814110614377.jpg",@"20150814110534880.jpg",@"20150814110614377.jpg"];
        _showView.imgs = imgArr;
        _page.numberOfPages = imgArr.count;
        
    }
    
}

// 分享
- (void)share{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"玩械宝最专业的机械设备资源整合平台。https://itunes.apple.com/cn/app/wan-xie-bao/id1013789429?l=en&mt=8"
                                       defaultContent:@"玩械宝"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"玩械宝"
                                                  url:@"https://itunes.apple.com/cn/app/wan-xie-bao/id1013789429?l=en&mt=8"
                                          description:@"玩械宝"
                                            mediaType:SSPublishContentMediaTypeNews];
  
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    // NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    [SVProgressHUD showErrorWithStatus:[error errorDescription]];
                                }
                            }];
    
}


// pagecontrol点击事件
- (void)pageChanged:(UIPageControl *)page {
    _showView.contentOffset = CGPointMake(_showView.width * page.currentPage, 0);
}

#warning 大类按钮点击  小类显示
// 功能按钮点击事件
- (void)itemClick:(KindBtn *)item {

    if (item.tag == 202) {
        
//        JobViewController *jobVC = [[JobViewController alloc]init];
        MyHomeJobViewController *jobVC = [[MyHomeJobViewController alloc] init];
        
        jobVC.catid = @"11";
        jobVC.title = @"招聘";
        
        [self.navigationController pushViewController:jobVC andHideTabbar:YES animated:YES];
        
    } else if (item.tag == 205) {
        
//        JobViewController *jobVC = [[JobViewController alloc]init];
        MyHomeJobViewController *jobVC = [[MyHomeJobViewController alloc] init];
        
        jobVC.title = @"求职";
        jobVC.catid = @"10";
        jobVC.isZhaoPin = YES;
        
        [self.navigationController pushViewController:jobVC andHideTabbar:YES animated:YES];
        
    } else {
        _lastItem.backgroundColor = CYNavColor;
        item.backgroundColor = CYBtnRedColor;
        _lastItem =item;
    }
}

/*12求租  14出租  13卖车  9买车  10 求职  11 招聘*/

// 定时器事件
- (void)timeAction {
    page ++;
    _page.currentPage = page;
    [_showView setContentOffset:CGPointMake(_showView.width*_page.currentPage, 0) animated:YES];
    if (page == _page.numberOfPages) {

        [_showView setContentOffset:CGPointMake(0, 0) animated:YES];
        _page.currentPage = 0;
        page = 0;
    }
}

#pragma UIScrollView delegate
// 滑动视图停止滑动调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _page.currentPage = scrollView.contentOffset.x /scrollView.width;

}

//已经选好了大类，点击的是 小类按钮
- (void)clickBtn:(UIButton *)btn{
    
//    MachineListViewController *machineVC = [[MachineListViewController alloc]init];
    MyHomeMachineViewController *machineVC = [[MyHomeMachineViewController alloc] init];
    
 /* 12求租  14出租  13卖车  9买车 */
    switch (_lastItem.tag) {
        case 200:{
            machineVC.type =@"12";
        }
            break;
        case 201:
            machineVC.type =@"9";
            break;
        case 203:
            machineVC.type =@"14";
            break;
        case 204:
            machineVC.type =@"13";
            break;
        default:
            
            break;
    }
    if (!_lastItem.tag) {
        machineVC.type =@"12";
    }

    machineVC.catid =machineVC.type;
    //类型的哪一行
    
    machineVC.title = self.titles[btn.tag];
    
    [UIView animateWithDuration:.1 animations:^{
        
        btn.backgroundColor = CYNavColor;
        
    } completion:^(BOOL finished) {
        
        [self.navigationController pushViewController:machineVC andHideTabbar:YES animated:YES];
        
        btn.backgroundColor =[UIColor whiteColor];
    }];
    
}


@end
