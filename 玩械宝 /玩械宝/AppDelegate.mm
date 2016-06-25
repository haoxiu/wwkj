//
//  AppDelegate.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/11.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "AppDelegate.h"
#import "MainController.h"
#import "AroundViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboApi.h"
#import "WeiboSDK.h"

#import "LoginViewController.h"
#import "LaunchViewController.h"

#import "MyHomeMachineViewController.h"
#import "YourTestChatViewControlle.h"

#import "DataPersistenceManager.h"
#import "FriendInfoModel.h"

//融云即时通讯

#import<RongIMKit/RongIMKit.h>

#import<RongIMLib/RongIMLib.h>

#import<UIKit/UIKit.h>

//融云即时通讯
#import<RongIMKit/RCConversationViewController.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

@interface AppDelegate ()
{
    UINavigationController *navigationController;
}

@end

@implementation AppDelegate
static BMKMapManager *_mapManager =nil;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSString * username = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    self.token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *isOnce = [[NSUserDefaults standardUserDefaults]objectForKey:@"isOnce"];

    if (isOnce.length != 0 && username.length !=0 && _token.length != 0) {
    
        MainController *mainVC = [[MainController alloc]init];
        self.window.rootViewController = mainVC;
//        [self autoLogin];
    }
    else {
    
        self.window.rootViewController = [[LaunchViewController alloc]init];
        [[NSUserDefaults standardUserDefaults]setObject:@"hasUse" forKey:@"isOnce"];
        
    }
    //dIpk4dWvdHnuHhguVSegHoVslocM8ZEL
    // 要使用百度地图，请先启动BaiduMapManager
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
        //获取授权认证
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"dIpk4dWvdHnuHhguVSegHoVslocM8ZEL"  generalDelegate:nil];
    if (!ret)
    {
        NSLog(@"manager start failed!");
    }
    //初始化融云SDK。
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY];
    //开启输入状态监听
    [RCIM sharedRCIM].enableTypingStatus=YES;

    
    //设置会话列表头像和会话界面头像
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    if (iPhone6Plus) {
        [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(56, 56);
    } else {
        [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(46, 46);
    }
    //会话列表界面的用户头像设置为圆形边角
    [RCIM sharedRCIM].globalConversationAvatarStyle=RC_USER_AVATAR_CYCLE;
    NSInteger a = [[RCIM sharedRCIM] getConnectionStatus];
        //    NSLog(@"%ld____1",(long)a);
    if (a && username.length !=0 && _token.length != 0)
    {
        //链接融云服务器
        [[RCIM sharedRCIM] connectWithToken:_token success:^(NSString *userId) {
            [[RCIM sharedRCIM] setUserInfoDataSource:self];
                
                //           NSLog(@"Login successfully with userId: %@.", userId);
                dispatch_async(dispatch_get_main_queue(), ^{
                });
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:－－%ld", (long)status);
        } tokenIncorrect:^{
            NSLog(@"token 无效 ，请确保生成token 使用的appkey 和初始化时的appkey 一致");
        }];
    }
        /**
     * 推送处理1
     */
    
    if ([application
         
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        //注册推送, iOS 8
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  
                                                                  UIUserNotificationTypeSound |
                                                                  
                                                                  UIUserNotificationTypeAlert)
                                                
                                                categories:nil];
        
        [application registerUserNotificationSettings:settings];
        
    } else {
        
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        
        UIRemoteNotificationTypeAlert |
        
        UIRemoteNotificationTypeSound;
        
        [application registerForRemoteNotificationTypes:myTypes];
        
    }
    
    //融云即时通讯
    
    [[NSNotificationCenter defaultCenter]
     
     addObserver:self
     
     selector:@selector(didReceiveMessageNotification:)
     
     name:RCKitDispatchMessageNotification
     
     object:nil];
    
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    /**
     *  将得到的devicetoken 传给融云用于离线状态接收push ，您的app后台要上传推送证书
     *
     *  @param application <#application description#>
     *  @param deviceToken <#deviceToken description#>
     */
    [self.window makeKeyAndVisible];
    [self share];
    return YES;
}

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
{
    
    NSMutableArray * array=[DataPersistenceManager readFriendInfo];
    NSString *userID =[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    NSString *nick =[[NSUserDefaults standardUserDefaults]objectForKey:@"nickname"];
    NSString *imag =[[NSUserDefaults standardUserDefaults]objectForKey:@"hdimg"];
    if ([userID isEqual:userId])
    {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = userID;
        user.name = nick;
        user.portraitUri = [NSString stringWithFormat:@"%@%@",URL_Key,imag];
        return completion(user);
    }
    else
    {
        for (FriendInfoModel * friendModel in array)
        {
            NSLog(@"%@",friendModel.Friend);
            RCUserInfo *user = [[RCUserInfo alloc]init];
            
            if ([friendModel.Friend isEqualToString:userId])
            {
                user.userId = friendModel.Friend;
                user.name = friendModel.nickname;
                user.portraitUri = [NSString stringWithFormat:@"%@%@",URL_Key,friendModel.hdimg];
                return completion(user);

            }
       }
        return completion(nil);
    }
    return completion(nil);
}

- (void)application:(UIApplication *)application

didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *token =
    
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
       
                                                           withString:@""]
      
      stringByReplacingOccurrencesOfString:@">"
      
      withString:@""]
     
     stringByReplacingOccurrencesOfString:@" "
     
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    
}

/**
 
 *  网络状态变化。
 *
 
 *  @param status 网络状态。
 
 */

- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_Unconnected) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"您"
                              @"的帐号在别的设备上登录，您被迫下线！"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
        //注意这里下面的4行，根据自己需要修改  也可以注释了，但是只能注释这4行，网络状态变化这个方法一定要实现
//
        
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"username"];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"nickname"];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"pwd"];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"hdimg"];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"sex"];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"sign"];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"isSaved"];

//        UIStoryboard *profileSB = [UIStoryboard storyboardWithName:@"profile" bundle:nil];
//        LoginViewController *loginVC = [profileSB instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        UINavigationController *_navi =
//        [[UINavigationController alloc] initWithRootViewController:loginVC];
//        [_navi.navigationBar setBackgroundColor:[UIColor blackColor]];
        
        MainController *mainVC = [[MainController alloc]init];
        self.window.rootViewController = mainVC;
        
 }
  
}
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber =
    
    [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    
}
- (void)share {
    
    [ShareSDK registerApp:@"8176130fd3ed"];
    
    // 分享到新浪微博
    [ShareSDK connectSinaWeiboWithAppKey:@"2301331763" appSecret:@"211bbaa23524b422ed2c1ab01d9756c9" redirectUri:@"http://www.xs.com"];
 
    //添加QQ空间应用
    [ShareSDK connectQZoneWithAppKey:@"1104636121" appSecret:@"esVdIwzUdNiaxrDK" qqApiInterfaceCls:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用
    [ShareSDK connectQQWithQZoneAppKey:@"1104636121"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    [ShareSDK connectWeChatWithAppId:@"wx5a1a0b8ae407ffda"
                           appSecret:@"a61691c20c91237975f39c860538e017"
                           wechatCls:[WXApi class]];
}
// 自动登录
- (void)autoLogin
{
    NSString * userName=[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    NSString *pwd = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
     if (userName.length !=0 && pwd.length != 0 ){
        UIStoryboard *profileSB = [UIStoryboard storyboardWithName:@"profile" bundle:nil];
        LoginViewController *loginVC = [profileSB instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [loginVC loginWithUserName:userName pwd:pwd];
   }
}
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}
- (void)applicationWillResignActive:(UIApplication *)application {
   }

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSInteger ToatalunreadMsgCount = (NSInteger)[[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM)]];
    [UIApplication sharedApplication].applicationIconBadgeNumber = ToatalunreadMsgCount;}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
