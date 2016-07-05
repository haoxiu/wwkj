//
//  FriendsDetailsViewController.m
//  玩械宝
//
//  Created by wawa on 16/5/17.
//  Copyright © 2016年 zgcainiao. All rights reserved.
//

#import "FriendsDetailsViewController.h"
#import "ViewController.h"
#import "ConversationViewController.h"

#import "FriendInfoModel.h"
#import "DataPersistenceManager.h"

@interface FriendsDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView*_tableView;
    UIView*_headView;
    UIView*_footView;
    
    UIView * _bgView;
    UIView * _aView;
}
@property (nonatomic,strong) NSMutableArray *titArr;//头像
@property(nonatomic,strong) FriendInfoModel *model;
@end

@implementation FriendsDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;  
}
-(void)viewWillAppear:(BOOL)animated
{
    [CYNetworkTool post:URL_UserInfo params:@{@"username":_friendModel.Friend} success:^(id json) {
        _model = [[FriendInfoModel alloc]initContentWithDic:json];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"获取好友失败"];
    }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"详细资料";
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.rowHeight=40;
    [self.view addSubview:_tableView];
    
    _headView=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,120)];
    _tableView.tableHeaderView=_headView;
    _footView=[[UIView alloc]initWithFrame:CGRectMake(0,_tableView.frame.size.height,self.view.frame.size.width,150)];
    _tableView.tableFooterView=_footView;
    
    
    UIImageView*headImg=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-40,20,80,80)];
    UIButton*headBut=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-40,20,80,80)];
    [headBut addTarget:self action:@selector(HeadTransparentLayer) forControlEvents:UIControlEventTouchUpInside];
    [headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Key,_friendModel.hdimg]] placeholderImage:[UIImage imageNamed:@"me.jpg"]];
    headImg.layer.cornerRadius = 40;
    headImg.layer.masksToBounds = YES;
    [_headView addSubview:headBut];
    [_headView addSubview:headImg];
    
    _titArr=[NSMutableArray arrayWithObjects:@"姓名",@"电话",@"性别",@"个性签名",@"最新发布", nil];
    
    UIButton*messageBut=[[UIButton alloc]initWithFrame:CGRectMake(50,50,_headView.frame.size.width-100,40)];
    [messageBut setTitle:@"发送消息" forState:UIControlStateNormal];
    messageBut.layer.cornerRadius = 2;
    messageBut.layer.masksToBounds = YES;
    messageBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    messageBut.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [messageBut setBackgroundColor:[UIColor colorWithRed:18/255.0 green:184/255.0 blue:246/255.0 alpha:1]];
    [messageBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [messageBut addTarget:self action:@selector(sendMessageFriend) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:messageBut];
    
    UIButton*deleteBut=[[UIButton alloc]initWithFrame:CGRectMake(50,110,_headView.frame.size.width-100,40)];
    [deleteBut setTitle:@"删除好友" forState:UIControlStateNormal];
    deleteBut.layer.cornerRadius = 2;
    deleteBut.layer.masksToBounds = YES;
    deleteBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    deleteBut.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [deleteBut setBackgroundColor:[UIColor colorWithRed:1 green:.4 blue:.4 alpha:1]];
    [deleteBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteBut addTarget:self action:@selector(deleteFriend) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:deleteBut];

}
//头像透明层
-(void)HeadTransparentLayer
{
    _bgView=[[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    _bgView.backgroundColor=[UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:0.7];
    [self.view addSubview:_bgView];
    //白色底层
    _aView = [[UIView alloc]initWithFrame:CGRectMake(10,20,self.view.frame.size.width-20,self.view.frame.size.height-20)];
    _aView.backgroundColor = [UIColor whiteColor];
    _aView.layer.cornerRadius = 6.0*[FlexBile ratio];
    _aView.userInteractionEnabled = YES;
    [_bgView addSubview:_aView];
    
    UIImageView*headimage=[[UIImageView alloc]initWithFrame:CGRectMake(0,_aView.frame.size.height/2-150,_aView.frame.size.width,300)];
    [headimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Key,_friendModel.hdimg]] placeholderImage:[UIImage imageNamed:@"me.jpg"]];
    [_aView addSubview:headimage];
 }
 //发消息
-(void)sendMessageFriend
{
    ConversationViewController *chat = [[ConversationViewController alloc]init];
    chat.conversationType = ConversationType_PRIVATE;
    chat.targetId =_friendModel.Friend;
    //设置聊天会话界面要显示的标题~
    chat.title = _friendModel.nickname;
    [self.navigationController pushViewController:chat andHideTabbar: YES animated:YES];
}
//删除好友 显示AlterView
-(void)deleteFriend
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除好友" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        return;
    }
    if (buttonIndex==1)
    {
        //调用删除的请求（先删除本地的）
    NSString * username=[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    [self getDeleteFriendsUsername:username friend:_friendModel.Friend];
    [DataPersistenceManager removeFriendInfo];
    }
}
//删除好友
-(void)getDeleteFriendsUsername:(NSString*)userName friend:(NSString *)Friend
{
    [CYNetworkTool post:URL_deleteFriend params:@{@"username":userName,@"friend":Friend} success:^(id json) {
        if ([json[@"state"] isEqualToString:@"1"])
        {
         [self.navigationController popViewControllerAnimated:YES];
        }
            } failure:^(NSError *error) {  
        [MBProgressHUD showError:@"删除好友失败"];
  }];
}
//每个区显示多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _titArr.count;
}
//单元格显示
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString * tittle =_titArr[indexPath.row];
    cell.textLabel.text = tittle;
    
    if ([tittle isEqualToString:@"姓名"])
    {
        if ([_friendModel.nickname isEqualToString:@""])
        {
               cell.detailTextLabel.text=_friendModel.remark;
            if ([_friendModel.remark isEqualToString:@""])
            {
                NSString *originTel = [NSString stringWithFormat:@"%@",_friendModel.Friend];
                //   隐藏手机号中间四位数
                NSString *tel = [originTel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                cell.detailTextLabel.text=tel;
            }
        }else
        {
            cell.detailTextLabel.text=_friendModel.nickname;
        }
         }else if ([tittle isEqualToString:@"电话"])
    {
         cell.detailTextLabel.text=_friendModel.Friend;

    }else if ([tittle isEqualToString:@"性别"])
    {
        cell.detailTextLabel.text=_friendModel.sex;
    }else if ([tittle isEqualToString:@"个性签名"])
    {
         cell.detailTextLabel.text=_model.sign;
        if ([_model.sign isEqualToString:@""]) {
           cell.detailTextLabel.text=@"有空写个签名呗!";
        }
    }else if ([tittle isEqualToString:@"最新发布"])
    {
        cell.detailTextLabel.text=@"2016-05-21";
    }
    cell.textLabel.textColor=CYNavColor;
     return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
