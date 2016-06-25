//
//  CollectWithMeTableViewCell.h
//  玩械宝
//
//  Created by huangyangqing on 15/9/29.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectWithMeTableViewCellMode.h"

@interface CollectWithMeTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIButton *icon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
//@property (weak, nonatomic) IBOutlet UILabel *aboutClassLableText;
@property (weak, nonatomic) IBOutlet UILabel *esayPresent;

- (IBAction)ProflieAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//求租、买车 隐藏他们
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *pricehide1;
@property (weak, nonatomic) IBOutlet UILabel *pricehide2;
@property (weak, nonatomic) IBOutlet UILabel *timehide;


@property (weak, nonatomic) IBOutlet UILabel *detailPresent;
- (IBAction)mapButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *useTime;

@property (weak, nonatomic) IBOutlet UILabel *mapText;
@property (weak, nonatomic) IBOutlet UIView *cellContentView;
@property (nonatomic)CGFloat cellHeight;

@property (weak, nonatomic) IBOutlet UILabel *xinghao;
@property (weak, nonatomic) IBOutlet UILabel *leixing;
@property (weak, nonatomic) IBOutlet UIView *imgBackView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nslayouconstraintR;

@property (strong,nonatomic) CollectWithMeTableViewCellMode *mode;
@property (nonatomic, strong) NSArray *imgArr; //图片数组



@end
