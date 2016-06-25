//
//  ViewController.h
//  玩械宝
//
//  Created by Stone袁 on 15/12/26.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>


@class User;
/**
 *  消息列表
 */
@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{


    __weak IBOutlet UITextField *_inputView;
    
    __weak IBOutlet UIView *_superView;
    
    NSMutableArray *_data; //存储model

    __weak IBOutlet UITableView *_tableView;
}
@property(nonatomic,retain)NSMutableArray *data;
@property(nonatomic,strong)User *toUser;

@end

