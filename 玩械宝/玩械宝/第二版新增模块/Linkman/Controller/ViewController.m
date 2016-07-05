//
//  ViewController.m
//  玩械宝
//
//  Created by Stone袁 on 15/12/26.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "ViewController.h"
#import "Message.h"
#import "MessageCell.h"
#import "User.h"
//#import "MyXMPPManager.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - View Lify Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.加载数据
    [self _loadData];
    
    //2. 创建视图
    [self _creatUI];
    
    //3.监听键盘弹出事件,当键盘弹出时,会收到UIKeyboardWillShowNotification通知
    //UIKeyboardWillShowNotification通知名,定义在UIWindow类中
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    //键盘收起的事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
    
    //接收到新消息
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMsg:) name:kReceiveMessageNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    //当视图出现的时候,显示最后一个单元格(最后一条消息)
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_data.count - 1 inSection:0];
    
    [_tableView scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}


#pragma mark - notificationAction
//键盘弹出后,会调用此通知方法
- (void)showKeyBoard:(NSNotification *)notification{
    
    //    NSLog(@"%@",notification.userInfo);
    NSDictionary *dic = notification.userInfo;
    
    //取得键盘的frame
//    NSValue *value = [dic objectForKey:UIKeyboardFrameBeginUserInfoKey];
//    CGRect rect = [value CGRectValue];
    
    //得到键盘的高度
//    CGFloat height =  rect.size.height;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    
    _superView.transform = CGAffineTransformMakeTranslation(0, 0);
    _tableView.transform = CGAffineTransformMakeTranslation(0, 0);
    
    [UIView commitAnimations];
}

//键盘收起
- (void)hideKeyBoard:(NSNotification *)notification
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    
    _superView.transform = CGAffineTransformIdentity;
    _tableView.transform = CGAffineTransformIdentity;
    
    [UIView commitAnimations];
}

- (void)receiveMsg:(NSNotification *)notification {
    
    NSDictionary *msg = notification.userInfo;
    
    //    NSString *fromUser = msg[@"fromUser"];
    NSString *text = msg[@"text"];
    
    [self addMessage:text isSelf:NO];
}

//创建视图(此处并没有创建视图,显示的视图已经在storyBoard中构建了)

- (void)_creatUI{
    
    _inputView.background = [UIImage imageNamed:@"chat_bottom_textfield.png"];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //将键盘上的return按钮改为send
    _inputView.returnKeyType = UIReturnKeySend;
    
    _inputView.delegate = self;
    
    
    
}

#pragma mark - Load Data
//加载数据
- (void)_loadData{
    
    //读取数据
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"messages.plist" ofType:nil];
    
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    
    _data = [NSMutableArray array];
    
    //将数据存储到model中
    for (NSDictionary *dic in array) {
        
        //创建model对象,将字典中的数据存储到model中
        Message *message = [[Message alloc] init];
        message.content = [dic objectForKey:@"content"];
        message.icon = [dic objectForKey:@"icon"];
        message.isSelf = [[dic objectForKey:@"self"] boolValue];
        message.time = [dic objectForKey:@"time"];
        
        
        //将message对象放在数组中
        //一个message对象代表一条消息
        [_data addObject:message];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return _data.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *intenty = @"UITableViewCell";
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:intenty];
    if (cell == nil) {
        
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:intenty];
    }
    
    Message *message =  _data[indexPath.row];
    
    //将model交给视图去显示
    [cell setMessage:message];
    
    
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
//返回单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //取到message对象,计算高度
    Message *message = _data[indexPath.row];
    CGSize size = [message.content sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(220, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height + 40;
    
    
}

//点击单元格时,缩回键盘
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //  将键盘缩回
    [_inputView endEditing:YES]; //[_inputView resignFirstResponder];
    
    //将视图的transform设为原始值
    _superView.transform = CGAffineTransformIdentity;
    _tableView.transform = CGAffineTransformIdentity;
    
    
}
//单元格上面的删除,插入按钮被点击时,调用的方法
//此协议方法,实现后,左滑单元格会出现删除按钮

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //1.删除数组中的对象
        [_data removeObjectAtIndex:indexPath.row];
        
        //    //2.刷新单元格
        //        [_tabelView reloadData];
        //在tableView中删除一个单元格
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    
    
}
#pragma -mark 发送消息
//send按钮被点击时,调用的方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //1.获取用户输入的内容
    NSString *text = textField.text;
    //2.添加消息到tableView
    [self addMessage:text isSelf:YES];
    
    //3.输入框置空
    textField.text = nil;
    
    
    //4.发送消息
//    [[MyXMPPManager shareManager] sendMessage:text toUser:self.toUser.jid];
    
    /*
     //2.创建一个message对象
     Message *message = [[Message alloc] init];
     message.content = text;
     message.icon = @"icon01.jpg";
     message.isSelf = YES;
     
     //将message对象放入数组中
     [_data addObject:message];
     
     //    //刷新表视图
     //    [_tabelView reloadData];
     
     //取得最后一个单元格的下标
     NSInteger index =  _data.count - 1;
     NSIndexPath*indexPath = [NSIndexPath indexPathForRow:index inSection:0];
     
     //在表视图的最后插入一个单元格
     [_tabelView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
     
     //滚动到最后一个单元格
     [_tabelView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
     
     //将输入框设为空
     _inputView.text = nil;
     */
    
    
    
    return YES;
    
}

- (void)addMessage:(NSString *)text isSelf:(BOOL)isSelf {
    
    //2.创建消息对象
    Message *msg = [[Message alloc] init];
    msg.content = text;
    msg.icon = isSelf?@"icon01.jpg":@"icon02.jpg";
    msg.isSelf = isSelf;
    
    //3.消息对象加入数组
    [self.data addObject:msg];
    
    
    
    //4.刷新tableView,显示新消息单元格
    [_tableView reloadData];
    
    
    int lastIndex = _data.count-1;  //最后一个消息的下标
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:lastIndex inSection:0];
    
    //往_tableView中插入一个单元格
    //    [_tableView insertRowsAtIndexPaths:@[lastIndexPath]
    //                      withRowAnimation:UITableViewRowAnimationRight];
    
    
    //5.滚动指定的cell  UITableViewScrollPositionBottom:在视图的底部
    [_tableView scrollToRowAtIndexPath:lastIndexPath
                      atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
}

@end
