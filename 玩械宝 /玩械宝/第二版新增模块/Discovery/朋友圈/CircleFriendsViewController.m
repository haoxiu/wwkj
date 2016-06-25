//
//  CircleFriendsViewController.m
//  玩械宝
//
//  Created by wawa on 16/6/13.
//  Copyright © 2016年 zgcainiao. All rights reserved.
//

#import "CircleFriendsViewController.h"
#import "CircleFriendsViewControllerCell.h"

#import "CircleFriendsModel.h"
#import "DataPersistenceManager.h"

@interface CircleFriendsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView*_tableView;
}

@property (nonatomic,strong) NSMutableArray *cFriendsArr;//好友信息

@end

@implementation CircleFriendsViewController

//-(void)viewWillAppear:(BOOL)animated
//{
//    NSMutableArray * array=[DataPersistenceManager readFriendInfo];
//    if (!array) {
//        [self loadData];
//    }else
//    {
//        _cFriendsArr=array;
////         NSString * username=[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
//       [self loadData];
//    }
//    }
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"朋友圈";
    _cFriendsArr=[[NSMutableArray alloc]init];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.rowHeight=163;
    [self.view addSubview:_tableView];
    [self loadData];
}
-(void)loadData
{
    NSString * username=[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    [CYNetworkTool post:URL_Friendq params:@{@"username":username} success:^(id json) {
        if ([json[@"state"] isEqualToString:@"1"]){
            [_cFriendsArr removeAllObjects];
            for (NSDictionary * friendDic in json[@"data"]) {
                
               CircleFriendsModel * friendModel=[[CircleFriendsModel alloc]initContentWithDic:friendDic];
                
               [_cFriendsArr addObject:friendModel];
            }
//           [DataPersistenceManager saveFriendInfo:_cFriendsArr];
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"获取好友失败"];
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cFriendsArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CircleFriendsModel * friendsModel =_cFriendsArr[indexPath.row];
    static NSString *identy = @"CircleFriendsViewControllerCell";
    CircleFriendsViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if (!cell){
        cell = [CircleFriendsViewControllerCell viewFromBundle];
        cell.model=friendsModel;
    };
    return cell;

 }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
