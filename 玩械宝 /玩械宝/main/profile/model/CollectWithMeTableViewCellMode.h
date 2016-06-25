//
//  CollectWithMeTableViewCellMode.h
//  玩械宝
//
//  Created by huangyangqing on 15/10/17.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectWithMeTableViewCellMode : NSObject

/**头像*/
@property (strong, nonatomic) NSString *icon;


/**账号*/
@property (strong, nonatomic) NSString *userName;

/**昵称*/
@property (strong, nonatomic) NSString *aboutClassLableText;

@property (strong, nonatomic) NSString *esayPresent;

/**类型*/
@property (strong, nonatomic) NSString *cartype;

@property (strong, nonatomic) NSString *collect;
@property (strong, nonatomic) NSString *share;

/**Inputtime */
@property (strong, nonatomic) NSString *time;

@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *image_1;
@property (strong, nonatomic) NSString *image_2;
@property (strong, nonatomic) NSString *image_3;
@property (strong, nonatomic) NSString *image_4;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSString *detailPresent;
@property (strong, nonatomic) NSString *useTime;
@property (strong, nonatomic) NSString *mapButton;

/**所在地*/
@property (strong, nonatomic) NSString *mapText;

/**生产年份*/
@property (strong, nonatomic) NSString * madetime;
 
@property (strong, nonatomic) NSString * conditions;
@property (strong, nonatomic) NSString * application;
@property (strong, nonatomic) NSString * contacts;

/**电话*/
@property (strong, nonatomic) NSString * phone;

@property (strong, nonatomic) NSString *ID;

@property (strong, nonatomic) NSString *colid;

@property (strong, nonatomic) NSString * inputtime;


@property (strong, nonatomic) NSString * type;

/**父级id,在 我的发布 辨别 发布类型*/
@property (strong, nonatomic) NSString * parentid;

/**账号*/
@property (strong, nonatomic) NSString *phoneName;

- (instancetype)initWithDict:(NSDictionary *)mode;
@end




/*
 userName = (NSString *)少阳
	aboutClassLableText = (NSString *)20
	esayPresent = (NSString *)小松
	cartype = (NSString *)大型挖掘机
	collect = nil
	share = nil
	time = (NSString *)15-09-25
	price = (NSString *)20
	image_1 = nil
	image_2 = nil
	image_3 = nil
	image_4 = nil
	images = (NSArray *)[
 {
 image:(NSString *)uploadfile/2015/0925/2015925144316381720.jpg
 }
	]
	detailPresent = (NSString *)嘻嘻
	useTime = (NSString *)250
	mapButton = nil
	mapText = (NSString *)北京市县密云县
	madetime = (NSString *)2012-9-25
	conditions = (NSString *)燕子
	application = (NSString *)用途不确定
	contacts = nil
	phone = (NSString *)15574965074
	ID = (NSString *)767
	colid = (int)0
	inputtime = nil
	type = nil
	parentid = nil
	phoneName = (NSString *)13017292474
 }(CollectWithMeTableViewCellMode *)
 
 */
