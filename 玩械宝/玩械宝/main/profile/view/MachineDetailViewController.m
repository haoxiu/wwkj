//
//  MachineDetailViewController.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/17.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "MachineDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "PhotoViewController.h"
#import "UserInfoViewController.h"
#import "DataService.h"
#import "DetailInfoModel.h"
#import "SVProgressHUD.h"
#import <ShareSDK/ShareSDK.h>

#import "Header.h"
#import "ConnectTool.h"

@interface MachineDetailViewController ()

@end

@implementation MachineDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"机械详情";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self loadViews];
    _picturesCollectionView.dataSource = self;
    _picturesCollectionView.delegate = self;
    [_picturesCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"picCell"];
}

- (void)loadViews {
    
    // 收藏按钮
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(0, 20, 40, 30);
    collectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [collectBtn addTarget:self action:@selector(collectAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:collectBtn];
    
    // 分享按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(00, 0, 40, 30);
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItems = @[item1,item2];

    _showUser.layer.cornerRadius = 3;
    _callBtn.layer.cornerRadius = 3;
    
    if (_hideSth) {
        
        _priceLabel.hidden = YES;
        _workTimeLabel.hidden = YES;
        _conditionsLabel.hidden = YES;
        _madeTimeLabel.hidden = YES;
        _applicationLabel.hidden = YES;
        _timeLabel.hidden = YES;
        _conditionLabel1.hidden = YES;
        _madetimeLabel1.hidden = YES;
        _appLabel.hidden = YES;
        _priceLabel1.hidden = YES;
        _height1.constant = 0;
        _height2.constant = 0;
        _height3.constant = 0;
        _height4.constant = 0;
        _height5.constant = 0;
        _height6.constant = 0;
        _height8.constant = 0;
        _height9.constant = 0;
        _height10.constant = 0;
        _height11.constant = 0;
        _height12.constant = 0;
        _height13.constant = 2;
        _height14.constant = 0;
        _height15.constant = 0;
        _height16.constant = 0;
        }
    
    _brandLabel.text = [NSString stringWithFormat:@"%@%@",_model.brand,_model.version];
    _priceLabel.text = [NSString stringWithFormat:@"%@万元",_model.price];
    _workTimeLabel.text = [NSString stringWithFormat:@"%@",_model.worktime];
    _inputTimeLabel.text = [NSString stringWithFormat:@"%@",_model.inputtime];
    _conditionsLabel.text = [NSString stringWithFormat:@"%@",_model.conditions];
    _madeTimeLabel.text = [NSString stringWithFormat:@"%@",_model.madetime];
    _placeLabel.text = [NSString stringWithFormat:@"%@",_model.place];
    _applicationLabel.text = [NSString stringWithFormat:@"%@",_model.application];
    _descTV.editable = NO;
    _descTV.text = [NSString stringWithFormat:@"%@",_model.desc];
    
}

//- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    
//    NSLog(@"%@",key);
//}
// 收藏
- (void)collectAction {
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if (username.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        self.tabBarController.selectedIndex = 2;
        return;
    }
    [SVProgressHUD showWithStatus:@"收藏中"];
    [DataService requestURL:@"http://eswjdg.com/index.php?m=mmapi&c=member&a=suresol" httpMethod:@"POST" params:@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"id":_model.ID,@"type":_type} completion:^(id result) {
        
        if ([result[@"state"] isEqualToNumber:@1]) {
            
            [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"收藏失败"];
        }
    }];
}
// 分享
- (void)share:(UIButton *)button {
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


// 跳转个人信息界面
- (IBAction)userAction:(UIButton *)sender {
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if (username.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        self.tabBarController.selectedIndex = 2;
        return;
    }
    UserInfoViewController *userVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
    if (_model.username != nil) {
        
        [DataService requestURL:@"http://eswjdg.com/index.php?m=mmapi&c=member&a=userinfo" httpMethod:@"POST" params:@{@"username":_model.username} completion:^(id result) {
            
            DetailInfoModel *model = [[DetailInfoModel alloc]initContentWithDic:result];
            userVC.model = model;
     
        }];
    }
    userVC.fromOtherController = YES;
    [self.navigationController pushViewController:userVC animated:YES];
    
}


// 拨打电话
- (IBAction)callAction:(UIButton *)sender {
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if (username.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        self.tabBarController.selectedIndex = 2;
        return;
    }
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_model.phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

// 显示图片的UICollectionView
#pragma mark UICollectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
 
    return _model.picture.count;
}
// 返回单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"picCell" forIndexPath:indexPath];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:cell.contentView.bounds];
    imgView.layer.cornerRadius = 7;

    imgView.clipsToBounds = YES;
    [cell.contentView addSubview:imgView];
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://waji.zgcainiao.com/%@",_model.picture[indexPath.item][@"image"]]]];
//    UIImage *img = [UIImage imageWithData:data];
//    if (img != nil) {
    
        [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://eswjdg.com/%@",_model.picture[indexPath.item][@"image"]]] placeholderImage:[UIImage imageNamed:@"waji"]];
//    }
//    else {
    
//        [imgView sd_setImageWithURL:[NSURL URLWithString:@"http://pic39.nipic.com/20140323/18181467_151437266161_2.jpg"]];
//    }
    
    if ([_model.picture[indexPath.item][@"image"] isEqualToString:@"0"]) {
        
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:@"http://pic39.nipic.com/20140323/18181467_151437266161_2.jpg"]];
    }
    return cell;
}
// 单元格大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(collectionView.width/3-10, 80);
}

// 单元格（图片）选中事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoViewController *photoVC = [[PhotoViewController alloc]init];
    NSMutableArray *urls = [NSMutableArray array];
    for (NSDictionary *dic in _model.picture) {
        
        NSString *url = [NSString stringWithFormat:@"http://eswjdg.com/%@",dic[@"image"]];
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
//        UIImage *img = [UIImage imageWithData:data];
//        if (img == nil) {
//        
//            url = @"http://pic39.nipic.com/20140323/18181467_151437266161_2.jpg";
//        }
        if ([dic[@"image"] isEqualToString:@"0"]) {
            
            url = @"http://pic39.nipic.com/20140323/18181467_151437266161_2.jpg";
        }
        [urls addObject:url];
    }
    photoVC.urls = urls;
    photoVC.indexPath = indexPath;
    [self.navigationController pushViewController:photoVC animated:YES];
}
@end
