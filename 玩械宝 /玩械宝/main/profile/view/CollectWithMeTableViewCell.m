//
//  CollectWithMeTableViewCell.m
//  玩械宝
//
//  Created by huangyangqing on 15/9/29.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "CollectWithMeTableViewCell.h"
#import "CollectViewMode.h"

#import "DetailInfoModel.h"

#import "UserInfoViewController.h"

#import "MBProgressHUD+NJ.h"
#import "CYNetworkTool.h"
#import "Header.h"
#import "UIView+viewController.h"
#import "CollectionViewCell.h"
#import "PhotoViewController.h"

 static NSString *indentity = @"cell";

@implementation CollectWithMeTableViewCell

- (void)awakeFromNib {

    _icon.layer.cornerRadius =_icon.width/2;
    _icon.clipsToBounds =YES;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置单元格的大小
    layout.itemSize = CGSizeMake(50, 50);
    //滑动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //设置水平空隙
    layout.minimumLineSpacing = 20;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    //注册单元格
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:indentity];
}




- (void)setImgArr:(NSArray *)imgArr{

    _imgArr = imgArr;
    

}

#pragma mark collection cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _imgArr.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentity forIndexPath:indexPath];
    

    if (![_imgArr[indexPath.row][@"picthumb"] isEqualToString:@""]) {
        
        cell.imgurl = _imgArr[indexPath.row][@"picthumb"];
        
    }else{
    
        cell.imgurl = _imgArr[indexPath.row][@"image"];

    }
    return cell;
    
}

#pragma mark 选中的图放大浏览

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoViewController *phtotCtr = [[PhotoViewController alloc]init];
    
    NSMutableArray *urlArr = [NSMutableArray array];
    
    //循环图片数组，拼接URL
    for (int i = 0; i < _imgArr.count; i ++) {
        
        NSString *urlString = [NSString stringWithFormat:@"http://eswjdg.com/%@",_imgArr[i][@"image"]];
        
        NSString *phtot =  _imgArr[i][@"image"];
        if ([phtot isEqualToString:@"0"]) {
            
            //提示“没图”
            [MBProgressHUD showError:@"这人太懒没上图"];
            
            return;
            
        }else{
            
            [urlArr addObject:urlString];
        }
    }
    
    phtotCtr.urls = urlArr;
    
    phtotCtr.indexPath = indexPath;
    
    
    [self.firstAvailableUIViewController.navigationController pushViewController:phtotCtr animated:YES];

}


- (IBAction)ProflieAction:(UIButton *)sender {
    MBProgressHUD *hd = [MBProgressHUD showMessage:@"正在加载"];
    hd.dimBackground = NO;
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if (username.length == 0) {
        
        [hd removeFromSuperview];
        
        sender.enabled = YES;
        [MBProgressHUD showError:@"请先登录"];
        self.firstAvailableUIViewController.tabBarController.selectedIndex = selectedIndexNum;
        return;
    }
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"profile" bundle:nil];
    UserInfoViewController *userVC = [sb instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
    
    if (_mode.phoneName != nil) {
        
        NSDictionary *params = @{@"username":_mode.phoneName};
        
        
        sender.enabled = NO;
        
        [CYNetworkTool post:URL_UserInfo params:params success:^(id json) {
            [MBProgressHUD hideHUD];
            if (![json[@"state"] isEqualToNumber:@1]) {
                [MBProgressHUD showError:json[@"msg"]];
                return ;
            }
            DetailInfoModel *userModel = [[DetailInfoModel alloc]initContentWithDic:json];
            userVC.model = userModel;
            userVC.fromOtherController = YES;
            sender.enabled = YES;
            [self.firstAvailableUIViewController.navigationController pushViewController:userVC animated:YES];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"网络异常"];
            [hd removeFromSuperview];
        }];
        
    }
}


- (IBAction)mapButton:(id)sender {
    
    NSLog(@"点击有地图");
    
}
@end
