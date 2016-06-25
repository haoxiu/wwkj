//
//  MachineDetailViewController.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/17.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "BaseViewController.h"
#import "MachineModel.h"
@interface MachineDetailViewController : BaseViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *picturesCollectionView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel1;
@property (weak, nonatomic) IBOutlet UILabel *madetimeLabel1;
@property (weak, nonatomic) IBOutlet UILabel *appLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height6;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height7;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height8;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height9;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height10;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height11;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height12;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height13;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height14;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height15;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height16;


@property (weak, nonatomic) IBOutlet UILabel *priceLabel1;

@property (weak, nonatomic) IBOutlet UIView *descView;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *workTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *inputTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *madeTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *applicationLabel;
@property (weak, nonatomic) IBOutlet UITextView *descTV;

@property (weak, nonatomic) IBOutlet UIButton *showUser;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
- (IBAction)userAction:(UIButton *)sender;
- (IBAction)callAction:(UIButton *)sender;
@property(nonatomic,strong)MachineModel *model;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,assign)BOOL hideSth;        // 是否是求租和买车
@end
