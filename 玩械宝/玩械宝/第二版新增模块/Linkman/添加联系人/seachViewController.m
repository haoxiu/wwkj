//
//  seachViewController.m
//  玩械宝
//
//  Created by wawa on 16/5/12.
//  Copyright © 2016年 zgcainiao. All rights reserved.
//

#import "seachViewController.h"
#import "LinkManViewController.h"
#import "CYNetworkTool.h"

#import "FriendInfoModel.h"
#import "DataPersistenceManager.h"

@interface seachViewController ()
{
    UITextField*_rightTf;
    UITextField*_noteTf;
    
    UILabel*_nameLab1;
    FriendInfoModel * _sechfriendModel;
}
@property (nonatomic,strong) NSMutableArray *seachArr;//　搜索的好友信息
@end

@implementation seachViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title=@"添加联系人";
 
    UIImageView*leftImg=[[UIImageView alloc]initWithFrame:CGRectMake(20,95, 20, 20)];
    leftImg.image=[UIImage imageNamed:@"personal_add_icon"];
    [self.view addSubview:leftImg];
    
    _rightTf=[[UITextField alloc]initWithFrame:CGRectMake(50,85, self.view.frame.size.width-80, 40)];
    _rightTf.textColor=[UIColor blackColor];
    _rightTf.font=[UIFont fontWithName:@"帐号／手机号" size:20];
    _rightTf.placeholder=@"帐号／手机号";
    _rightTf.borderStyle=UITextBorderStyleNone;
    _rightTf.text=@"";
    //判断是否是根据二维码扫描跳过来的
    if (self.url)
    {
        _rightTf.text=[NSString stringWithFormat:@"%@",self.url];
    }
    
    [self.view addSubview:_rightTf];
    
    UIView*upView1=[[UIView alloc]initWithFrame:CGRectMake(0,80, self.view.frame.size.width,2)];
    upView1.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:0.8];
    [self.view addSubview:upView1];
    
    UIView*downView1=[[UIView alloc]initWithFrame:CGRectMake(0,125, self.view.frame.size.width,2)];
    downView1.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:0.8];
    [self.view addSubview:downView1];
    
    UIButton*seachBut=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-40,83, 40, 40)];
    [seachBut setTitle:@"🔍" forState:UIControlStateNormal];
    [seachBut addTarget:self action:@selector(SearchFriends:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:seachBut];

}
//搜索按钮
-(void)SearchFriends:(UIButton *)but
{
    if ([_rightTf.text isEqualToString:@""])
    {
        [MBProgressHUD showError:@"请输入帐号或手机号"];
    }
    else if ([_rightTf.text length]<11)
    {
        [MBProgressHUD showError:@"请输入正确的帐号或手机号"];
    }
    else
    {
        [self q:_rightTf.text];
    }
}
//搜索请求
-(void)q:(NSString *)userName
{
     _nameLab1.text=@"";
    [CYNetworkTool post:URL_searchFriend params:@{@"username":userName} success:^(id json) {
        if ([json[@"state"] isEqualToString:@"1"])
        {
            for (NSDictionary * friendDic in json[@"data"])
            {
                _sechfriendModel=[[FriendInfoModel alloc]initContentWithDic:friendDic];
    
                [self layout];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"此好友不存在"];
    }];
 }
//添加好友
-(void)addFriendsRequest:(UIButton *)send
{
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    NSMutableArray * array=[DataPersistenceManager readFriendInfo];
    
    NSString * friend;
    if ([username isEqualToString:_sechfriendModel.username])
    {
        [MBProgressHUD showError:@"不能添加自己为好友"];
        //直接根据索引返回根视图
           [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        return;
    }
    for (int  i = 0; i <array.count; i ++)
    {
       FriendInfoModel * friendModel= array[i];
       
        if ( [friendModel.Friend isEqualToString:_sechfriendModel.username])
        {
            [MBProgressHUD showMessage:@"此联系人已是好友"];
            friend=friendModel.Friend;
            //直接根据索引返回根视图
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
            return;
        }
    }
    if(friend ==nil)
    {
        //需要修改备注
        [self addFriendsRequest:username friend:_sechfriendModel.username remark:_noteTf.text];
        [DataPersistenceManager removeFriendInfo];
         [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }
 }
//添加好友请求
-(void)addFriendsRequest:(NSString *)userName friend:(NSString *)Friend remark:(NSString *)Remark
{
    NSDictionary *parameters = @{@"username":userName,@"friend":Friend,@"remark":Remark};
    [CYNetworkTool post:URL_addFriend params:parameters success:^(id json)
    {
        if ([json[@"state"] isEqualToString:@"1"])
        {
            [MBProgressHUD showSuccess:@"添加成功"];
               }
      } failure:^(NSError *error) {
     [MBProgressHUD showError:@"网络异常"];
    }];
 }
-(void)layout
{
    UIView*upView2=[[UIView alloc]initWithFrame:CGRectMake(0,150, self.view.frame.size.width,2)];
    upView2.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:0.8];
    [self.view addSubview:upView2];
    
    UILabel*nameLab=[[UILabel alloc]initWithFrame:CGRectMake(20,155, self.view.frame.size.width-200,40)];
    nameLab.text=@"昵称";
    [self.view addSubview:nameLab];
    
    _nameLab1=[[UILabel alloc]initWithFrame:CGRectMake(70,155, self.view.frame.size.width-200,40)];
    _nameLab1.text=_sechfriendModel.nickname;
    [self.view addSubview:_nameLab1];
    
    UIView*middleView1=[[UIView alloc]initWithFrame:CGRectMake(60,155,2,35)];
    middleView1.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:0.8];
    [self.view addSubview:middleView1];
    
    UIView*downView2=[[UIView alloc]initWithFrame:CGRectMake(0,195, self.view.frame.size.width,2)];
    downView2.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:0.8];
    [self.view addSubview:downView2];
    
    UIView*upView3=[[UIView alloc]initWithFrame:CGRectMake(0,220, self.view.frame.size.width,2)];
    upView3.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:0.8];
    [self.view addSubview:upView3];
    
    UILabel*noteLab=[[UILabel alloc]initWithFrame:CGRectMake(20,225, self.view.frame.size.width-200,40)];
    noteLab.text=@"备注";
    [self.view addSubview:noteLab];
    
    UIView*middleView2=[[UIView alloc]initWithFrame:CGRectMake(60,225,2,35)];
    middleView2.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:0.8];
    [self.view addSubview:middleView2];
    
    _noteTf=[[UITextField alloc]initWithFrame:CGRectMake(70,225, self.view.frame.size.width-80, 40)];
    _noteTf.textColor=[UIColor blackColor];
    _noteTf.font=[UIFont fontWithName:@"输入备注" size:20];
    _noteTf.placeholder=@"输入备注";
    _noteTf.borderStyle=UITextBorderStyleNone;
    
    [self.view addSubview:_noteTf];
    
    
    UIView*downView3=[[UIView alloc]initWithFrame:CGRectMake(0,265, self.view.frame.size.width,2)];
    downView3.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:0.8];
    [self.view addSubview:downView3];
    
    UIButton*SendBut=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50,300,100,40)];
    SendBut.backgroundColor=[UIColor lightGrayColor];
    SendBut.layer.cornerRadius =5;
    SendBut.layer.masksToBounds = YES;
    [SendBut setTitle:@"确认添加" forState:UIControlStateNormal];
    [SendBut addTarget:self action:@selector(addFriendsRequest:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SendBut];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
