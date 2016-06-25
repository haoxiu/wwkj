//
//  Header.h
//  玩械宝
//
//  Created by echo on 11/5/15.
//  Copyright (c) 2015 zgcainiao. All rights reserved.
//

//#define Font(F) [UIFont systemFontOfSize:(F)]

//#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//导航栏的背景色
#define   CYNavColor         [UIColor colorWithRed:18/255.0 green:184/255.0 blue:246/255.0 alpha:1]
//背景的灰色
#define   CYBackgroundGrayColor         [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1]
//Button的红色
#define   CYBtnRedColor         [UIColor colorWithRed:236/255.0 green:107/255.0 blue:79/255.0 alpha:1]

#define CYWindowWidth                        ([[UIScreen mainScreen] bounds].size.width)
#define CYWindowHeight                       ([[UIScreen mainScreen] bounds].size.height)

#define iPhone6                                                                \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
        ? CGSizeEqualToSize(CGSizeMake(750, 1334),                              \
         [[UIScreen mainScreen] currentMode].size)           \
         : NO)
#define iPhone6Plus                                                            \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
     ? CGSizeEqualToSize(CGSizeMake(1242, 2208),                             \
     [[UIScreen mainScreen] currentMode].size)           \
         : NO)


//通讯录
#import "FlexBile.h"
#import "UIView+MHCommon.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "NSMutableArray+FilterElement.h"

#import "UINavigationController+CY.h"
#import "MBProgressHUD+NJ.h"
#import "SVProgressHUD.h"


#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import "CYNetworkTool.h"

#import "FriendsDetailsViewController.h"
#import "YourTestChatViewControlle.h"

#define RONGCLOUD_IM_APPKEY @"uwd1c0sxdb3r1"
#define URL_Key @"http://eswjdg.com"

#define URL_Keys @"http://eswjdg.com/"

//---搜索好友
#define URL_searchFriend @"http://eswjdg.com/index.php?m=mmapi&c=talk&a=use_search"
//---修改备注
#define URL_editFriend @"http://eswjdg.com/index.php?m=mmapi&c=talk&a= edit_remark"
//---添加好友
#define URL_addFriend @"http://eswjdg.com/index.php?m=mmapi&c=talk&a=sq_friend"
//---获取好友列表
#define URL_loadingFriend @"http://eswjdg.com/index.php?m=mmapi&c=talk&a=get_friend"
//---删除好友
#define URL_deleteFriend @"http://eswjdg.com/index.php?m=mmapi&c=talk&a=del_friend"
//---获取token
#define URL_Token @"http://eswjdg.com/index.php?m=mmapi&c=talk&a=getToken"
//-----地图

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件


//－－－－－－－发现

//---获取朋友圈
#define URL_Friendq @"http://eswjdg.com/index.php?m=mmapi&c=talk&a=get_friendq"
//---附近出租求职
#define URL_Aroundq @"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_pub"



/**
 *  主屏的宽
 */
#define DEF_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

/**
 *  主屏的高
 */
#define DEF_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

/**
 *  主屏的size
 */
#define DEF_SCREEN_SIZE   [[UIScreen mainScreen] bounds].size

/**
 *  主屏的frame
 */
#define DEF_SCREEN_FRAME  [UIScreen mainScreen].bounds
/**
 *  判断屏幕尺寸是否为640*1136
 *
 *	@return	判断结果（YES:是 NO:不是）
 */
#define DEF_SCREEN_IS_640_1136 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define DEF_TABBAR_COLOR DEF_RGB_COLOR(52, 162, 249)

#define BUBBLE_RIGHT_LEFT_CAP_WIDTH 5 // 文字在右侧时,bubble用于拉伸点的X坐标
#define BUBBLE_RIGHT_TOP_CAP_HEIGHT 35 // 文字在右侧时,bubble用于拉伸点的Y坐标

#define BUBBLE_LEFT_LEFT_CAP_WIDTH 35 // 文字在左侧时,bubble用于拉伸点的X坐标
#define BUBBLE_LEFT_TOP_CAP_HEIGHT 35 // 文字在左侧时,bubble用于拉伸点的Y坐标
// 文字的字体大小
#define FONT_SIZE(_size_) [UIFont systemFontOfSize:_size_]

//----------------------------------------------------------------------
//接口网址

//用户注册
#define URL_Regin  @"http://eswjdg.com/index.php?m=mmapi&c=member&a=regin"

//个人信息
#define URL_UserInfo  @"http://eswjdg.com/index.php?m=mmapi&c=member&a=userinfo"

//修改个人信息
#define URL_ChangeInfo  @"http://eswjdg.com/index.php?m=mmapi&c=member&a=upd_info"

//修改头像
#define URL_ChangeHdImg  @"http://eswjdg.com/index.php?m=mmapi&c=member&a=get_hd"
//修改密码
#define URL_ChangePwd  @"http://eswjdg.com/index.php?m=mmapi&c=member&a=updpwd"

//账号登录
#define URL_Login  @"http://eswjdg.com/index.php?m=mmapi&c=member&a=login"

//关于我们
#define URL_AboutUs  @"http://eswjdg.com/about.html"

//获取验证码
#define URL_GetMsm  @"http://eswjdg.com/api.php?op=sms"

//找回密码
#define URL_FindPw  @"http://eswjdg.com/index.php?m=mmapi&c=member&a=findpwd"

//-----------------------------发布---------------------------------------------

//出租,求租,卖车,买车
#define URL_PublishAll  @"http://eswjdg.com/index.php?m=mmapi&c=sale&a=sell_publish"

//求职
#define URL_PublishQz  @"http://eswjdg.com/index.php?m=mmapi&c=sale&a=yp_publish"

//招聘
#define URL_PublishZp  @"http://eswjdg.com/index.php?m=mmapi&c=sale&a=zp_publish"

//-----------------------------等待审核-------------------------------------------

//我要买车、卖车、求租、出租
#define URL_WaitCheckAll  @"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_pub"

//我要招聘
#define URL_WaitCheckZp  @"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_zparc"

//我要求职
#define URL_WaitCheckQz  @"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_yp"

//-----------------------------我的发布-------------------------------------------

//全部
#define URL_MyPublishAll  @"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_pub"

//我要招聘
#define URL_MyPublishZp @"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_zparc"

//我要求职
#define URL_MyPublishQz  @"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_yp"

//-----------------------------我的收藏-----------------------------------------

//全部
#define URL_MyCollectAll  @"http://eswjdg.com/index.php?m=mmapi&c=member&a=get_allmm"

//我要招聘,我要求职
#define URL_MyCollectZQ @"http://eswjdg.com/index.php?m=mmapi&c=member&a=getsol"

//-----------------------------首页-----------------------------------------------

//我要求租，我要买车，我要出租，我要卖车
#define URL_MainAll  @"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_pub"

//我要招聘
#define URL_MainZp  @"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_yp"

//我要求职
#define URL_MainQz  @"http://eswjdg.com/index.php?m=mmapi&c=sale&a=get_zparc"

//-----------------------------添加收藏-----------------------------------------------

#define URL_AddCollect  @"http://eswjdg.com/index.php?m=mmapi&c=member&a=suresol"

//-----------------------------判断收藏-----------------------------------------------
//招聘,求职
#define URL_JugeQZCollect  @"http://eswjdg.com/index.php?m=mmapi&c=member&a=getzysol"


#define URL_JugeAllCollect  @"http://eswjdg.com/index.php?m=mmapi&c=member&a=getpubsol"

//-----------------------------删除收藏-----------------------------------------------

#define URL_DeleteCollect  @"http://eswjdg.com/index.php?m=mmapi&c=member&a=del_sol"

///                 删除>> 出租、求租、卖车、买车

#define URL_DeletePub  @"http://eswjdg.com/index.php?m=mmapi&c=sale&a=del_pub"


//                         删除>>招聘

#define URL_DeleteZp  @"http://eswjdg.com/index.php?m=mmapi&c=sale&a=del_zp"

//                        删除>>求职

#define URL_Deleteyp  @"http://eswjdg.com/index.php?m=mmapi&c=sale&a=del_yp"











