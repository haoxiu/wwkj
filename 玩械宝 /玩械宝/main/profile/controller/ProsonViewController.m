//
//  ProsonViewController.m
//  玩械宝
//
//  Created by Stone袁 on 16/3/12.
//  Copyright (c) 2016年 zgcainiao. All rights reserved.
//

#import "ProsonViewController.h"
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

#import "UINavigationController+CY.h"
#import "MyPCWViewController.h"
#import "MyWaitCheckViewController.h"
#import "CYNetworkTool.h"
#import "UIImageView+WebCache.h"
#import "QRCodeManager.h"

#import "MyHomeMachineViewController.h"

@interface ProsonViewController (){

    UITableView *_tableView;
    UIView * _bgView;
    UIView * _aView;
    
}
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, strong) NSArray *imgs1;
@property (nonatomic, strong) NSArray *imgs2;
@property (nonatomic, strong) NSArray *imgs3;

@property (nonatomic, strong) NSArray *titllArrs;
@property (nonatomic, strong) NSArray *titllArrs1;
@property (nonatomic, strong) NSArray *titllArrs2;
@property (nonatomic, strong) NSArray *titllArrs3;
@property (nonatomic, strong) TableHeadView *hv;


@end

static NSString *identy = @"cellId";

@implementation ProsonViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    ;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    
    statusBarView.backgroundColor=[UIColor blackColor];
    
    [self.view addSubview:statusBarView];

    //图片数组
    _imgs = @[@"personal_select_icon"];
    _imgs1 = @[@"publi_shing_icon",@"collection_03",@"hourglass_button"];
    _imgs2 = @[@"build",@"clean_up_cache",@"password_button"];

    _imgs3 =@[@"about_button"];
    
    //文字数组
    
    _titllArrs = @[@"个人信息"];
    _titllArrs1 = @[@"我的发布",@"我的收藏",@"等待审核"];
    _titllArrs2 = @[@"我的二维码",@"清理缓存",@"修改密码"];
    _titllArrs3 = @[@"关于我们"];

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    UIView*headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,88)];
    
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-100,0,200,35)];
    [button setTitle:@"退出登陆" forState:UIControlStateNormal];
    button.layer.cornerRadius = 2;
    button.layer.masksToBounds = YES;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [button setBackgroundColor:[UIColor colorWithRed:1 green:.4 blue:.4 alpha:1]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(exitLogin) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:button];
    _tableView.tableFooterView=headView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    _tableView.showsVerticalScrollIndicator = NO;//不显示右侧滑块
    _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;//分割线
    
    //注册单元格
    [_tableView registerNib:[UINib nibWithNibName:@"PresonViewCellTableViewCell" bundle:nil] forCellReuseIdentifier:identy];
    
    //头视图
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"TableHeadView" owner:nil options:nil];
    _hv =[nibView objectAtIndex:0];
    
    _hv.frame = CGRectMake(0, 0, kScreenWidth, 150);
    
    [_tableView setTableHeaderView:_hv];
    //加载数据
    [self loadDates];
}
//退出登录
-(void)exitLogin
{
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"username"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"nickname"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"pwd"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"hdimg"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"sex"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"sign"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"isSaved"];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MainController *mainVC = [[MainController alloc]init];
    window.rootViewController = mainVC;
}
- (void)loadDates{

    [CYNetworkTool post:URL_UserInfo params:@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]} success:^(id json) {
        
        DetailInfoModel *_model = [[DetailInfoModel alloc]initContentWithDic:json];
        NSString *hdimg = json[@"hdimg"];
        
        NSData *imgData = [[NSData alloc]initWithBase64EncodedString:hdimg options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *headImg = [UIImage imageWithData:imgData];
        //把 性别、个人签名 添加到偏好设置中持久化
        [[NSUserDefaults standardUserDefaults]setObject:_model.sex forKey:@"sex"];
        [[NSUserDefaults standardUserDefaults]setObject:_model.sign forKey:@"sign"];
        [[NSUserDefaults standardUserDefaults]setObject:_model.hdimg forKey:@"hdImg"];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"isSaved"];
        _hv.nickImg.layer.cornerRadius = _hv.nickImg.width/2;
        _hv.nickImg.clipsToBounds = YES;
        _hv.nickImg.translatesAutoresizingMaskIntoConstraints = NO;
        
        if (headImg != nil) {
            _hv.nickImg.image = headImg;
        }
        
    } failure:^(NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
        });
    }];

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 10;
    }if (section == 1) {
        return 0.1;
    }if (section == 2) {
        return 0.1;
    }else{
        return 0.1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 4;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return _imgs.count;
    }if (section == 1) {
        
        return _imgs1.count;
    }if (section == 2) {
        
        return _imgs2.count;
    }
    else{
        return _imgs3.count;
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    PresonViewCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy forIndexPath:indexPath];

    if (indexPath.section == 0) {
        cell.imageview.image = [UIImage imageNamed:_imgs[indexPath.row]];
        cell.lable.text = _titllArrs[indexPath.row];
        cell.img.image = [UIImage imageNamed:@"right_icon"];
    }if (indexPath.section == 1) {
        cell.imageview.image = [UIImage imageNamed:_imgs1[indexPath.row]];
        cell.lable.text = _titllArrs1[indexPath.row];
        cell.img.image = [UIImage imageNamed:@"right_icon"];
    }if (indexPath.section == 2) {
        cell.imageview.image = [UIImage imageNamed:_imgs2[indexPath.row]];
        cell.lable.text = _titllArrs2[indexPath.row];
        cell.img.image = [UIImage imageNamed:@"right_icon"];
    }if (indexPath.section == 3) {
        cell.imageview.image = [UIImage imageNamed:_imgs3[indexPath.row]];
        cell.lable.text = _titllArrs3[indexPath.row];
        cell.img.image = [UIImage imageNamed:@"right_icon"];
  }

    return cell;
}

#pragma mark 单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44;
}

#pragma mark 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //点击颜色马上变回来
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //个人信息

    if (indexPath.section == 0) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"profile" bundle:nil];
        
        UserInfoViewController *userInfo = [sb instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
        
        [self.navigationController pushViewController:userInfo andHideTabbar:YES animated:YES];
        
        
        
    }else if (indexPath.section == 1){
        
        //我的发布
        if (indexPath.row == 0) {

            MyPCWViewController *wc =[[MyPCWViewController alloc]init];
            wc.title = @"我的发布";
            wc.flag = 1;
            [self.navigationController pushViewController:wc andHideTabbar:YES animated:YES];
            //我的收藏
        }else if (indexPath.row == 1){
        
            MyPCWViewController *wc =[[MyPCWViewController alloc]init];
            wc.title = @"我的收藏";
            wc.flag = 2;
            [self.navigationController pushViewController:wc andHideTabbar:YES animated:YES];
            //等待审核
        }else if (indexPath.row == 2){
            MyPCWViewController *wc =[[MyPCWViewController alloc]init];
            wc.title = @"等待审核";
            wc.flag = 3;
            [self.navigationController pushViewController:wc andHideTabbar:YES animated:YES];
        }

    }else if (indexPath.section == 2){
    
        //我的二维码
        if (indexPath.row == 0) {
            NSLog(@"我的二维码");
            [self QrcodeGenerated];
            //清理缓存
        }else if (indexPath.row == 1){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"清理缓存" message:@"确定要清理缓存吗 ？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            [alert show];
        
            //修改密码
        }else if (indexPath.row == 2){
            changePwdViewController *changePwd =[[changePwdViewController alloc]init];
            
            [self.navigationController pushViewController:changePwd andHideTabbar:YES animated:YES];
        }
        //关于我们
    }else if (indexPath.section == 3){
        AboutViewController *aboutMe =[[AboutViewController alloc]init];
        
        [self.navigationController pushViewController:aboutMe andHideTabbar:YES animated:YES];

    }}
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
#pragma mark UIScrollViewDelegate
//滑动时调用,实时调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsety = scrollView.contentOffset.y;
    //向上滑动
    if (offsety > -1) {
        
        _hv.top = -offsety;
        
        _tableView.scrollEnabled = YES;
        //向下滑动
    }else{
        
        _tableView.scrollEnabled = NO;

    }
}
#pragma mark UIAlertViewDelegete
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0) {
        return;
        //清理缓存（沙盒缓存和数据表）
    }else if (buttonIndex == 1){
        MyHomeMachineViewController *homeCtr = [[MyHomeMachineViewController alloc]init];
        
        // 初始化
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"wanxiebao.sqlite"];
        homeCtr.db = [FMDatabase databaseWithPath:path];
        [homeCtr.db open];
        //删除表
        NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE t_machine"];
        [homeCtr.db executeUpdate:sqlstr];
        
        // 清除表
        NSString *sqlstr1 = [NSString stringWithFormat:@"DELETE FROM t_machine"];
        
        [homeCtr.db executeUpdate:sqlstr1];
        
        
        //清空缓存
        [[SDImageCache sharedImageCache] clearDisk];
        //清空内存中的图片
        [[SDImageCache sharedImageCache] clearMemory];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
