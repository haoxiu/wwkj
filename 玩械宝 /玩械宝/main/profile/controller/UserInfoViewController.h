//
//  UserInfoViewController.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/15.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "BaseViewController.h"
#import "DetailInfoModel.h"
@interface UserInfoViewController : BaseViewController<UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
- (IBAction)headImgAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *nickName;
- (IBAction)confirmAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *userName_1;
@property (weak, nonatomic) IBOutlet UILabel *userName_2;
@property (weak, nonatomic) IBOutlet UILabel *userName_3;

@property (weak, nonatomic) IBOutlet UIButton *sexT;
@property (weak, nonatomic) IBOutlet UILabel *sexL;
@property (weak, nonatomic) IBOutlet UITextField *sign;
@property(nonatomic,strong) DetailInfoModel *model;

@property(nonatomic,assign)BOOL fromOtherController;
@property(nonatomic,strong)UIImage *headimg;
@end
