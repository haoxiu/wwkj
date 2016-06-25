//
//  CellViewController.m
//  玩械宝
//
//  Created by huangyangqing on 15/9/30.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "CellViewController.h"
#import "UIImageView+WebCache.h"

#import "Header.h"
#import "MBProgressHUD+NJ.h"
#import "CYNetworkTool.h"

#import "UserInfoViewController.h"
#import "DetailInfoModel.h"

#import "LcPrint.h"
#import "LcPrint+LLDB.h"

#import "PhotoViewController.h"

@interface CellViewController ()<UIScrollViewDelegate>{
    
    NSTimer *timer;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollHConstraint;


@property (nonatomic, strong) UIImageView *imageViews;
@property (nonatomic, strong) NSArray *imageArr;
@property (assign, nonatomic) BOOL isCollected;
@property (nonatomic, assign) NSInteger index;
@end

@implementation CellViewController{
    MBProgressHUD *hub;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden =NO;
    self.edgesForExtendedLayout =UIRectEdgeNone;
    
    
    if (_shouldHide) {
        _share.hidden =YES;
    } else {
        if (_isFromCollect) {
            _share.selected = YES;
        } else {
            [self loadCollectData];
        }
    }
    
    self.title = @"详细信息";
    
    [self loadViews];
    
}


- (void)loadViews{
    
    _brand.text =_mode.aboutClassLableText;
    _MachineName.text =_mode.esayPresent;
    
    NSString *price1 = [NSString stringWithFormat:@"%@万元",_mode.price];
    
    _price.text =_mode.price;
    _mongy.text = price1;
    _publicTime.text =_mode.time;
    _inputtime.text =_mode.time;
    _brand.text =_mode.esayPresent;
    _conditions.text =_mode.conditions;
    _madetime.text =_mode.madetime;
    _place.text =_mode.mapText;
    _application.text =_mode.application;
    _descriptionS.text =_mode.detailPresent;
    
    NSString *userTime = [NSString stringWithFormat:@"%@ 小时",_mode.useTime];
    
    _hours.text = userTime;
    
    
    [_share addTarget:self action:@selector(collectAction) forControlEvents:UIControlEventTouchUpInside];
    
    _imageArr =[NSArray arrayWithArray:_mode.images];
    for (int i =0; i <_imageArr.count; i ++) {
        _imageViews =[[UIImageView alloc]initWithFrame:CGRectMake(i *kScreenWidth, 0, kScreenWidth, _photoScrollView.height)];
        [_imageViews sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://eswjdg.com/%@",_imageArr[i][@"image"]]] placeholderImage:[UIImage imageNamed:@"waji.jpg"]];
        
        _photoScrollView.maximumZoomScale = 3;
        _photoScrollView.minimumZoomScale = .5;
        [_photoScrollView addSubview:_imageViews];
        
#warning 图片自适应
        _imageViews.contentMode = UIViewContentModeScaleAspectFit;
        
        _photoScrollView.delegate = self;
    }
    
    _photoScrollView.showsHorizontalScrollIndicator = NO;
    _photoScrollView.showsVerticalScrollIndicator = NO;
    _photoScrollView.contentSize =CGSizeMake(_imageArr.count *kScreenWidth , 0);
    _photoScrollView.backgroundColor =[UIColor whiteColor];
    //    _photoScrollView.contentOffset = CGPointZero;
    
    _photoScrollView.pagingEnabled =YES;
    
    //手势tap
    //单击
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleAction)];
    
    [_photoScrollView addGestureRecognizer:singleTap];
    
}

#pragma mark 单击添加一个覆盖视图（collectionview）
- (void)ss{
    
    PhotoViewController *phCtrl = [[PhotoViewController alloc]init];
    
    NSMutableArray *urlArr = [NSMutableArray array];
    
    //循环图片数组，拼接URL
    for (int i = 0; i < _imageArr.count; i ++) {
        
        NSString *urlString = [NSString stringWithFormat:@"http://eswjdg.com/%@",_imageArr[i][@"image"]];
        
        NSString *phtot =  _imageArr[i][@"image"];
        if ([phtot isEqualToString:@"0"]) {
            
            //提示“没图”
            [MBProgressHUD showError:@"这人太懒没上图"];
            
            return;
            
        }else{
            
            [urlArr addObject:urlString];
        }
    }
    
    phCtrl.urls = urlArr;
    
    //indexPath  >>计算偏移量
    
    //    phCtrl.indexPath =
    
    [self.navigationController pushViewController:phCtrl animated:YES];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    
    //    _viewHeight [self.btnLineConstraints setConstant:(int)type*(ScreenWidth/3)];
    
    CGFloat factH = _descriptionS.bottom + 10.0 + 49.0;
    
    if (factH > CYWindowHeight) {
        [_viewHConstraint setConstant:factH];
    }else {
        [_viewHConstraint setConstant:CYWindowHeight]; //进入
    }
    
}

- (void)loadCollectData
{
    [CYNetworkTool post:URL_JugeAllCollect params:@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"id":_mode.ID} success:^(id json) {
        if ([json[@"state"] isEqualToString:@"1"]) { //收藏了的
            
            _share.enabled = NO;
        }
        else {
            
        }
        
    } failure:^(NSError *error) {
        //        [MBProgressHUD showError:@"网络异常"];
    }];
}


- (void)collectAction {
    if (_isFromCollect) {
        if (_share.selected) {//已经选中的,删除
            [self deleteCollect];
        }else { //未选中的,收藏
            [self collect];
        }
    }else {
        [self collect];
    }
}


#pragma mark 收藏
- (void)collect
{
    [CYNetworkTool post:URL_AddCollect params:@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"id":_mode.ID,@"type":_type} success:^(id json) {
        if ([[json[@"state"] stringValue] isEqualToString:@"1"]) {
            if (_isFromCollect) {
                _share.selected = YES;
            }else {
                _share.enabled = NO;
            }
            [MBProgressHUD showSuccess:@"收藏成功"];
        }
        else {
            //是否要判断
            
            [MBProgressHUD showError:@"收藏失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络异常"];
    }];
}

- (void)deleteCollect
{
    [CYNetworkTool post:URL_DeleteCollect params:@{@"colid":_mode.colid} success:^(id json) {
        if ([[json[@"state"] stringValue] isEqualToString:@"1"]) {
            _share.selected = NO;
            [MBProgressHUD showSuccess:@"已取消收藏"];
            
            
        }
        else if ([[json[@"state"] stringValue] isEqualToString:@"101"]){
            //是否要判断
            
            [MBProgressHUD showError:@"取消收藏失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络异常"];
    }];
}

- (IBAction)showUserAction:(UIButton *)sender {
    
    hub = [MBProgressHUD showMessage:@"正在加载"];
    hub.dimBackground = NO;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"profile" bundle:nil];
    UserInfoViewController *userVC = [sb instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
    
    if (_mode.phoneName != nil) {
        
        [CYNetworkTool post:URL_UserInfo params:@{@"username":_mode.phoneName} success:^(id json) {
            
            DetailInfoModel *userModel = [[DetailInfoModel alloc] initContentWithDic:json];
            userVC.model = userModel;
            userVC.fromOtherController = YES;
            
            [MBProgressHUD hideHUD];
            
            [self.navigationController pushViewController:userVC animated:YES];
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"网络异常"];
            [hub removeFromSuperview];
        }];
        
    }
}


- (IBAction)callAction:(UIButton *)sender {
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if (username.length == 0) {
        
        [MBProgressHUD showError:@"请先登录"];
        self.tabBarController.selectedIndex = 2;
        return;
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_mode.phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

#pragma mark 图片的点击事件

-(void)singleAction{
    //发通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"singleTapNatification" object:nil userInfo:nil];
    
    //单击再弹出一个视图显示图片
    
    [self ss];
    
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return _imageViews;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [hub removeFromSuperview];
}

- (IBAction)show:(id)sender {
    
    NSLog(@"首页详情列表分享");
    
}
@end
