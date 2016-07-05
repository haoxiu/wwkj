//
//  YourTestChatViewControlle.m
//  挖挖
//
//  Created by wawa on 16/5/11.
//  Copyright © 2016年 Wawa. All rights reserved.
//

#import "YourTestChatViewControlle.h"
#import "LinkManViewController.h"
#import "ConversationViewController.h"

#import "UIColor+RCColor.h"
#import "FriendInfoModel.h"
#import "DataPersistenceManager.h"



@interface YourTestChatViewControlle ()

@property (nonatomic,strong) RCConversationModel *tempModel;

@property(nonatomic, strong) RCChatSessionInputBarControl *chatSessionInputBarControl;
@end

@implementation YourTestChatViewControlle

- (void)viewDidLoad {
    //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
    [super viewDidLoad];
     self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title=@"会话列表";
     //设置tableView样式
    self.conversationListTableView.separatorColor = [UIColor colorWithHexString:@"dfdfdf" alpha:1.0f];
     //自定义空会话的背景View。当会话列表为空时，将显示该View
    self.conversationListTableView.tableFooterView = [UIView new];
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    }

/**
 *重写RCConversationListViewController的onSelectedTableRow事件
 *
 *  @param conversationModelType 数据模型类型
 *  @param model                 数据模型
 *  @param indexPath             索引
 */

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath
{

    ConversationViewController *chat = [[ConversationViewController alloc]init];
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chat.conversationType = ConversationType_PRIVATE;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chat.targetId = model.targetId;
    //设置聊天会话界面要显示的标题
    chat.title = model.conversationTitle;
    [self.navigationController pushViewController:chat andHideTabbar: YES animated:YES];
    [self removeItemAtIndex:2];
}
- (void)removeItemAtIndex:(NSInteger)index
{
    if (index==2)
    {
        NSNumber*number=[[NSNumber alloc]initWithInteger:index];
        NSLog(@"%@",number);
       
    }
}
//@property (nonatomic, strong) RCPluginBoardView *pluginBoardView
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
