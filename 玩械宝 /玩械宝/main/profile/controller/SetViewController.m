//
//  SetViewController.m
//  玩械宝
//
//  Created by 刘昊 on 16/6/27.
//  Copyright © 2016年 zgcainiao. All rights reserved.
//

#import "SetViewController.h"
#import "MyHomeMachineViewController.h"
#import "MainController.h"
#import "AboutViewController.h"
@interface SetViewController ()
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *titles;
@end

@implementation SetViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    ;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _titles = @[@"清除缓存",@"账号与安全",@"关于我们",@"版本更新",@"退出"];
  
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;//不显示右侧滑块
    _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;//分割线
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PublishCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _titles.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublishCell" forIndexPath:indexPath];
    cell.textLabel.text = _titles[indexPath.row];

    return cell;
}
#pragma mark 单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}
#pragma mark 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //取消单元格选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {//清除缓存
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"清理缓存" message:@"确定要清理缓存吗 ？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }if (indexPath.row == 1) {//账号安全
        
    }if (indexPath.row == 2) {//关于我们
        AboutViewController *aboutMe =[[AboutViewController alloc]init];
        
        [self.navigationController pushViewController:aboutMe andHideTabbar:YES animated:YES];
    }if (indexPath.row == 3) {//版本更新
        
    }if (indexPath.row == 4) {//退出
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

@end
