//
//  MyInfoViewController.m
//  玩械宝
//
//  Created by 刘昊 on 16/6/27.
//  Copyright © 2016年 zgcainiao. All rights reserved.
//

#import "MyInfoViewController.h"

#import "PresonViewCellTableViewCell.h"
#import "TableHeadView.h"
#import "Header.h"
#import "AboutViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "UserInfoViewController.h"
#import "changePwdViewController.h"
#import "SegmentViewController.h"
#import "DataService.h"
#import "MachineModel.h"
#import "CollectViewController.h"
#import "MainController.h"
#import "SetViewController.h"
#import "HeadTableViewCell.h"
#import "NotLogTableViewCell.h"
#import "PersonInfoViewController.h"

#import "UINavigationController+CY.h"
#import "MyPCWViewController.h"
#import "MyWaitCheckViewController.h"
#import "CYNetworkTool.h"
#import "UIImageView+WebCache.h"
#import "QRCodeManager.h"

#import "MyHomeMachineViewController.h"

static NSString *identy = @"cellId";
static NSString *identify = @"id";
static NSString *identfiy = @"Id";
@interface MyInfoViewController ()
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) HeadTableViewCell *hv;
@property (nonatomic, strong) NotLogTableViewCell *cellV;
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UIView * aView;
@property (nonatomic)NSString *str;
@property (nonatomic, strong) UIImage *headImg;
@end

@implementation MyInfoViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    ;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    _imgs = @[@"新版我的未登录状态_031",@"新版我的未登录状态_017",@"新版我的未登录状态_210",@"新版我的未登录状态_110",@"新版我的未登录状态_114"];
    _titles= @[@"我的发布",@"我的二维码",@"我的收藏",@"等待审核",@"设置"];
//    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
//    
//    statusBarView.backgroundColor=[UIColor blackColor];
//    
//    [self.view addSubview:statusBarView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    _tableView.showsVerticalScrollIndicator = NO;//不显示右侧滑块
    _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;//分割线

    //注册单元格
    [_tableView registerNib:[UINib nibWithNibName:@"PresonViewCellTableViewCell" bundle:nil] forCellReuseIdentifier:identy];
    [_tableView registerNib:[UINib nibWithNibName:@"HeadTableViewCell" bundle:nil] forCellReuseIdentifier:identify];
    [_tableView registerNib:[UINib nibWithNibName:@"NotLogTableViewCell" bundle:nil] forCellReuseIdentifier:identfiy];
    //头视图
    
//    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"TableHeadView" owner:nil options:nil];
//    _hv =[nibView objectAtIndex:0];
//    
//    _hv.frame = CGRectMake(0, 0, kScreenWidth, 150);
//    
//    [_tableView setTableHeaderView:_hv];
    
    //加载数据
    [self loadDates];

    
}

- (void)loadDates
{
    [CYNetworkTool post:URL_UserInfo params:@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]} success:^(id json) {
        
        DetailInfoModel *_model = [[DetailInfoModel alloc]initContentWithDic:json];
        NSString *hdimg = json[@"hdimg"];
        _str = json[@"state"];
        NSData *imgData = [[NSData alloc]initWithBase64EncodedString:hdimg options:NSDataBase64DecodingIgnoreUnknownCharacters];
        _headImg = [UIImage imageWithData:imgData];
//        //把 性别、个人签名 添加到偏好设置中持久化
        [[NSUserDefaults standardUserDefaults]setObject:_model.sex forKey:@"sex"];
        [[NSUserDefaults standardUserDefaults]setObject:_model.sign forKey:@"sign"];
//        [[NSUserDefaults standardUserDefaults]setObject:_model.hdimg forKey:@"hdimg"];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"isSaved"];
        _hv.nickImg.layer.cornerRadius = _hv.nickImg.width/2;
        _hv.nickImg.clipsToBounds = YES;
        _hv.nickImg.translatesAutoresizingMaskIntoConstraints = NO;
        if (_headImg != nil) {
        _hv.nickImg.image = _headImg;
        
        }
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
        });
        
    }];
    

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 10;
    }else{
        return 0.1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        
    return _titles.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        if (indexPath.section == 0){
//        if ([_str  isEqualToString:@"1"]) {

            _hv = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
            return _hv;
//        }else{
//            _cellV = [tableView dequeueReusableCellWithIdentifier:identfiy forIndexPath:indexPath];
//            _cellV.selectionStyle =UITableViewCellSelectionStyleNone;
//            [_cellV.loading addTarget:self action:@selector(theLogin:) forControlEvents:UIControlEventTouchUpInside];
//            NSLog(@"账号222：%@,%@",_hv.userName,_str);
//            return _cellV;
//        }
       
    }
    PresonViewCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy forIndexPath:indexPath];
    cell.imageview.image = [UIImage imageNamed:_imgs[indexPath.row]];
    cell.lable.text = _titles[indexPath.row];
    cell.img.image = [UIImage imageNamed:@"right_icon"];
    return cell;
}

- (void)theLogin:(UIButton *)send
{
    UIStoryboard *profileSB = [UIStoryboard storyboardWithName:@"profile" bundle:nil];
    LoginViewController *login = [profileSB instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:login andHideTabbar:YES animated:YES];
}
#pragma mark 单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100;
    }else{
        return 44;
    }
}

#pragma mark 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //点击颜色马上变回来
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
//            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"profile" bundle:nil];
            //            UserInfoViewController *userInfo = [sb instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
            PersonInfoViewController *info = [[PersonInfoViewController alloc] init];
            
            [self.navigationController pushViewController:info andHideTabbar:YES animated:YES];
        }
    }if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            MyPCWViewController *wc =[[MyPCWViewController alloc]init];
            wc.title = @"我的发布";
            wc.flag = 1;
            [self.navigationController pushViewController:wc andHideTabbar:YES animated:YES];
        }if (indexPath.row == 1){
            [self QrcodeGenerated];
        }if (indexPath.row == 2){
            MyPCWViewController *wc =[[MyPCWViewController alloc]init];
            wc.title = @"我的收藏";
            wc.flag = 2;
            [self.navigationController pushViewController:wc andHideTabbar:YES animated:YES];
        }if (indexPath.row == 3){
            MyPCWViewController *wc =[[MyPCWViewController alloc]init];
            wc.title = @"等待审核";
            wc.flag = 3;
            [self.navigationController pushViewController:wc andHideTabbar:YES animated:YES];

        }if (indexPath.row == 4) {
            SetViewController *sc = [[SetViewController alloc] init];
            sc.title = @"设置";
            [self.navigationController pushViewController:sc animated:YES];
        }
    }
}
//生成自己的二维码
-(void)QrcodeGenerated
{
    //透明层
    _bgView=[[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    _bgView.backgroundColor=[UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:0.7];
    [self.view addSubview:_bgView];
    //白色底层
    _aView = [[UIView alloc]initWithFrame:[FlexBile frameIPONE5Frame:CGRectMake(40,568/2-170, 320-80,330)]];
    _aView.backgroundColor = [UIColor whiteColor];
    _aView.layer.cornerRadius = 6.0*[FlexBile ratio];
    _aView.userInteractionEnabled = YES;
    [_bgView addSubview:_aView];

    NSString * username=[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    NSString*str=[[NSUserDefaults standardUserDefaults]objectForKey:@"hdimg"];
    NSString*nick=[[NSUserDefaults standardUserDefaults]objectForKey:@"nickname"];
    //顶部图片
    UIImageView*headimage=[[UIImageView alloc]initWithFrame:[FlexBile frameIPONE5Frame:CGRectMake(40,20,50,50)]];
     [headimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Key,str]] placeholderImage:[UIImage imageNamed:@"me.jpg"]];
    headimage.layer.cornerRadius = 25;
    headimage.layer.masksToBounds = YES;
    [_aView addSubview:headimage];

    UILabel*nclabel=[[UILabel alloc]initWithFrame:[FlexBile frameIPONE5Frame:CGRectMake(105,10, 320-80,50)]];
    nclabel.text=nick;
    nclabel.textColor=[UIColor blackColor];
    [_aView addSubview:nclabel];

   //生成的二维码
    UIImageView*image=[[UIImageView alloc]initWithFrame:[FlexBile frameIPONE5Frame:CGRectMake(40-20,568/2-210, 320-80-40,200)]];
    image.image=[QRCodeManager createQRCodeWithString:username];
    [_aView addSubview:image];
    //传过来的图片
    UIImageView*img=[[UIImageView alloc]initWithFrame:[FlexBile frameIPONE5Frame:CGRectMake(80,80,40,40)]];
    img.layer.cornerRadius = 20;
    img.layer.masksToBounds = YES;
    [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Key,str]] placeholderImage:[UIImage imageNamed:@"me.jpg"]];
    CALayer *lay = [img layer];
    lay.borderColor = [[UIColor whiteColor] CGColor];
    lay.borderWidth = 2.0f;
    [image addSubview:img];

    UILabel*label=[[UILabel alloc]initWithFrame:[FlexBile frameIPONE5Frame:CGRectMake(40-25,568/2-240+200+40, 320-80,30)]];
    label.text=@"扫一扫上面的二维码，加我为好友";
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=[UIColor lightGrayColor];
    [_aView addSubview:label];
    //添加点按手势
    UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTapsRequired =1;
    [_bgView addGestureRecognizer:tapGesture];
}
//手势回调方法
-(void)tapGesture:(UITapGestureRecognizer *)gesture
{
    [_bgView removeFromSuperview];
}
@end
