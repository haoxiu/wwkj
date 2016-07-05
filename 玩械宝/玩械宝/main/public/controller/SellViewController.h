//
//  SellViewController.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/24.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "BaseViewController.h"

@interface SellViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UICollectionView *picCollectionView;

- (IBAction)locationAction:(UIButton *)sender;

- (IBAction)madetimeAction:(UIButton *)sender;
- (IBAction)publishAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *leixingL;
@property (weak, nonatomic) IBOutlet UIButton *leixingBtn;

@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UIButton *placeBtn;

@property (weak, nonatomic) IBOutlet UILabel *nianfenL;
@property (weak, nonatomic) IBOutlet UIButton *nianfenBtn;
@property (weak, nonatomic) IBOutlet UITextField *jiage;
@property (weak, nonatomic) IBOutlet UILabel *chekuangL;
@property (weak, nonatomic) IBOutlet UIButton *chekuangBtn;
@property (weak, nonatomic) IBOutlet UILabel *yongtuL;
@property (weak, nonatomic) IBOutlet UIButton *yongtuBtn;
@property (weak, nonatomic) IBOutlet UITextField *lianxiren;
@property (weak, nonatomic) IBOutlet UITextField *phone;
//@property (weak, nonatomic) IBOutlet UITextField *jieshao;

@property (weak, nonatomic) IBOutlet UIButton *brandBtn;
@property (weak, nonatomic) IBOutlet UILabel *brandL;


@property (weak, nonatomic) IBOutlet UITextField *xiaobiaoti;
@property (weak, nonatomic) IBOutlet UITextView *miaoshu;
@property (weak, nonatomic) IBOutlet UIButton *publicBtn;

@property(nonatomic,strong)NSString * centerlongitude;//当前经度


@property(nonatomic,assign)BOOL isSell;

@end
