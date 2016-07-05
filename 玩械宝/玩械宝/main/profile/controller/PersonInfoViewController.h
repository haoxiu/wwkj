//
//  PersonInfoViewController.h
//  玩械宝
//
//  Created by 刘昊 on 16/6/29.
//  Copyright © 2016年 zgcainiao. All rights reserved.
//

#import "BaseViewController.h"
#import "DetailInfoModel.h"

@interface PersonInfoViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong) DetailInfoModel *model;

@property(nonatomic,assign)BOOL fromOtherController;
//@property(nonatomic,strong)UIImage *headimg;


@end
