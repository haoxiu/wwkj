//
//  LinkManViewController.m
//  玩械宝
//
//  Created by Stone袁 on 15/12/17.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "LinkManViewController.h"
#import "LinkManCell.h"
#import "Scan2DViewController.h"

#import "PublicViewController.h"
#import "ZhaoPinViewController.h"
#import "QiuZhiViewController.h"
#import "BuyCarViewController.h"
#import "SellViewController.h"
#import "seachViewController.h"

#import "FriendInfoModel.h"
#import "DataPersistenceManager.h"

@interface LinkManViewController ()
{
    NSMutableDictionary *dic;
    NSArray *newKeysArr;
    UIView*_headView;
}

@property (nonatomic,strong) NSMutableArray *friendsArr;//好友信息

@end

@implementation LinkManViewController

-(void)viewWillAppear:(BOOL)animated
{
    NSMutableArray * array=[DataPersistenceManager readFriendInfo];
    if (!array) {
        NSString * username=[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
        [self getFriendsList:username];
    }else
    {
        _friendsArr=array;
        [self dataSouceDeal];
        NSString * username=[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
        [self getFriendsList:username];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"联系人";
    UIView *views = [UIView new];
    views.backgroundColor = [UIColor clearColor];
    
    dic=[[NSMutableDictionary alloc]init];
    _friendsArr=[NSMutableArray array];
    newKeysArr=[NSMutableArray array];
    
    
    [_tableView setTableFooterView:views];
    UIBarButtonItem *addButon=[[UIBarButtonItem alloc] initWithTitle:@"消息" style:UIBarButtonItemStylePlain target:self action:@selector(TheSessionList)];
    [addButon setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem=addButon;
    
    
    _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,88)];
    _headView.backgroundColor=[UIColor whiteColor];
    
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(40,-5,_headView.frame.size.width,40)];
    [button setTitle:@"添加好友" forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addLinkMan) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:button];
    
    UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(10,37, self.view.frame.size.width-10,1)];
    lineView.backgroundColor=[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    [_headView addSubview:lineView];
    
    UIButton*button1=[[UIButton alloc]initWithFrame:CGRectMake(40,45,_headView.frame.size.width,40)];
    [button1 setTitle:@"扫描二维码" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button1.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [button1 addTarget:self action:@selector(ScanTheqrCode) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:button1];
    UIImageView*LinkImg=[[UIImageView alloc]initWithFrame:CGRectMake(15,5,20, 20)];
    LinkImg.image=[UIImage imageNamed:@"personal_add_icon"];
    [_headView addSubview:LinkImg];
    UIImageView*scanImg=[[UIImageView alloc]initWithFrame:CGRectMake(15,55,20,20)];
    scanImg.image=[UIImage imageNamed:@"two_code"];
    [_headView addSubview:scanImg];
    
    self.tableView.tableHeaderView=_headView;
    self.tableView.rowHeight=50;
    self.tableView.sectionHeaderHeight=20;
    [self.view addSubview:self.tableView];
}
-(void)getFriendsList:(NSString*)userName
{
   [CYNetworkTool post:URL_loadingFriend params:@{@"username":userName} success:^(id json) {
        if ([json[@"state"] isEqualToString:@"1"]){
            [_friendsArr removeAllObjects];
            for (NSDictionary * friendDic in json[@"data"]) {
                FriendInfoModel * friendModel=[[FriendInfoModel alloc]initContentWithDic:friendDic];
                [_friendsArr addObject:friendModel];
            }
            [DataPersistenceManager saveFriendInfo:_friendsArr];
        [self.tableView reloadData];
        //加载数据
        [self dataSouceDeal];
   }
   } failure:^(NSError *error) {
       [MBProgressHUD showError:@"获取好友失败"];
    }];
}
//跳转添加联系人界面
-(void)addLinkMan
{
    seachViewController*vc=[[seachViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//扫描二维码
-(void)ScanTheqrCode
{
    Scan2DViewController *scanViewwController = [[Scan2DViewController alloc]init];
    [self.navigationController pushViewController:scanViewwController animated:YES];
}
//获取会话列表
-(void)TheSessionList
{
    YourTestChatViewControlle *chatList = [[YourTestChatViewControlle alloc] init];
    [self.navigationController pushViewController:chatList  animated:YES];
}
/**
 *  加载数据
 */
-(void)dataSouceDeal
{
    [dic removeAllObjects];
    for (FriendInfoModel * friendModel in _friendsArr) {
        NSString*stringHead;
        if ([friendModel.nickname isEqualToString:@""])
        {
            if ([friendModel.remark isEqualToString:@""])
            {
                NSString *originTel = [NSString stringWithFormat:@"%@",friendModel.Friend];
                //   隐藏手机号中间四位数
                NSString *tel = [originTel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                stringHead = tel;
            }
            else
            {
                stringHead=friendModel.remark;
            }
        }
        else
        {
            stringHead=friendModel.nickname;
        }
        // 取出首字母
        NSString *firstLetter = [[PinYinForObjc chineseConvertToPinYinHead:stringHead] uppercaseString];
        if (![dic objectForKey:firstLetter]) {
            [dic setObject:[NSMutableArray array] forKey:firstLetter];
        }
        [[dic objectForKey:firstLetter] addObject:friendModel];
}
    
    newKeysArr = [dic.allKeys sortedArrayUsingSelector:@selector(compare:)];
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dic.allKeys.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dic objectForKey:newKeysArr[section]] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendInfoModel * friendModel = [dic[newKeysArr[indexPath.section]] objectAtIndex:indexPath.row];
    static NSString *identy = @"LinkManCell";
    LinkManCell*cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if (!cell)
    {
        cell = [LinkManCell viewFromBundle];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model=friendModel;
    };
    return cell;
}

//区头索引
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 背景图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,0,DEF_SCREEN_WIDTH, 30)];
    bgView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    // 显示分区的 label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,-5, DEF_SCREEN_WIDTH-40, 30)];
    label.text =newKeysArr[section];
    label.textColor=CYNavColor;
    label.font = FONT_SIZE(14);
    [bgView addSubview:label];
    return bgView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendInfoModel * model= [dic[newKeysArr[indexPath.section]] objectAtIndex:indexPath.row];
    FriendsDetailsViewController*vc=[[FriendsDetailsViewController alloc]init];
    vc.friendModel=model;
    [self.navigationController pushViewController:vc  animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//右侧的索引标题数组
- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    return newKeysArr;
}
#pragma mark - 懒加载一些内容
- (NSMutableArray *)friendsArr
{
    if (!_friendsArr) {
        _friendsArr = [NSMutableArray array];
    }
    return _friendsArr;
}
////给删除的确认按钮设置标题；默认是 Delete
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"delete";
//}
////当点击右侧的删除按钮时，会调用的协议方法
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
////    //修改数据数组
////    [_dataArr removeObjectAtIndex:indexPath.row];
////    [self.tableView reloadData];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
