
//
//  UserInfoViewController.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/15.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "UserInfoViewController.h"

#import "AppDelegate.h"

#import "userSexLableText.h"

#import "Header.h"
#import "MBProgressHUD+NJ.h"
#import "CYNetworkTool.h"

#import "UIImage+KIAdditions.h"
#import "PhotoViewController.h"

@interface UserInfoViewController ()<userSexLableTextDelegate>
{
    AppDelegate *_delegate;
}

@property (nonatomic,strong)userSexLableText *userView;
@property (weak, nonatomic) IBOutlet UIButton *changehdImgBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

//@property (nonatomic, strong) UIImage *headImg;


@end

@implementation UserInfoViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //_delegate = [UIApplication sharedApplication].delegate;
    
    self.navigationController.navigationBarHidden =NO;
    self.title = @"个人信息";
    
    // 判断是否是从求职信息等页面点击“个人信息”跳转过来
    if (_fromOtherController) {
        _nickName.userInteractionEnabled = NO;
        _confirmBtn.hidden = YES;
        
        _sexT.enabled = NO;
        _imgIcon.hidden = YES;
        _changehdImgBtn.hidden = YES;
        if (_model.sign.length == 0) {
            _model.sign = @"    ";
        }
        _sign.userInteractionEnabled = NO;
        
        
        [self refreshViews];
    }
    else {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isSaved"] isEqualToString:@"1"]) {
            
            [self refreshViewsWithDefult];
        }else {
            
            MBProgressHUD *hub = [MBProgressHUD showMessage:@"正在加载"];
            hub.dimBackground = NO;
            [self _loadData];
        }
    }
    
    [self _loadViews];
    _userView =[[NSBundle mainBundle] loadNibNamed:@"userSexLableText" owner:nil options:nil][0];
    _userView.delegate =self;
    [self.view addSubview:_userView];
    
}

- (void)setModel:(DetailInfoModel *)model {
    
    if (_model != model) {
        
        _model = model;
        
        [self refreshViews];
    }
}

- (void)_loadViews {
    //个性签名的textfild设置
    //编辑时候出现一键清除
    _sign.clearButtonMode =UITextFieldViewModeWhileEditing;
    _confirmBtn.layer.cornerRadius = 5;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeHeader)];
    if (_fromOtherController) {
        
        _headImg.userInteractionEnabled = NO;
    }
    else {
        
        _headImg.userInteractionEnabled = YES;
    }
    [_headImg addGestureRecognizer:tap];
    _headImg.layer.cornerRadius = _headImg.width/2;
    _headImg.clipsToBounds = YES;
}

// 加载数据
- (void)_loadData {

    [CYNetworkTool post:URL_UserInfo params:@{@"username":[DataCenter defaultCenter].account.username} success:^(id json) {
        
        _model = [[DetailInfoModel alloc]initContentWithDic:json];
        
        //把 性别、个人签名 添加到偏好设置中持久化
        [[NSUserDefaults standardUserDefaults]setObject:_model.sex forKey:@"sex"];
        [[NSUserDefaults standardUserDefaults]setObject:_model.sign forKey:@"sign"];
        [[NSUserDefaults standardUserDefaults]setObject:_model.hdimg forKey:@"hdimg"];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"isSaved"];
         
        [self refreshViews];
        
        [MBProgressHUD hideHUD];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self.navigationController popViewControllerAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [MBProgressHUD showError:@"网络异常"];
        });
    }];
}

// 填充数据
- (void)refreshViews {
    
    if (_model.hdimg != nil) {
        
        NSData *imgData = [[NSData alloc]initWithBase64EncodedString:_model.hdimg options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *headImg = [UIImage imageWithData:imgData];

        if (headImg != nil) {
            _headImg.image = headImg;
        }
    }
    _nickName.text = _model.nickname;
    _userName_1.text =[_model.username substringWithRange:NSMakeRange(0, 3)];
    _userName_2.text =[_model.username substringWithRange:NSMakeRange(3, 4)];
    _userName_3.text =[_model.username substringWithRange:NSMakeRange(7, 4)];
    
    _sign.text =_model.sign;
    _sexL.text =_model.sex;
}

- (void)refreshViewsWithDefult {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"hdimg"] != nil) {
        
        NSData *imgData = [[NSData alloc]initWithBase64EncodedString:[[NSUserDefaults standardUserDefaults] objectForKey:@"hdimg"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *headImg = [UIImage imageWithData:imgData];
        if (headImg != nil) {
            _headImg.image = headImg;
            
        }
    }
    _nickName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    _userName_1.text =[username substringWithRange:NSMakeRange(0, 3)];
    _userName_2.text =[username substringWithRange:NSMakeRange(3, 4)];
    _userName_3.text =[username substringWithRange:NSMakeRange(7, 4)];
    
    _sign.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"sign"];;
    _sexL.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"sex"];;
    NSString *imgStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"hdimg"];
    NSData *imgData = [[NSData alloc]initWithBase64EncodedString:imgStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *img = [UIImage imageWithData:imgData];
    _headImg.image = img;
    
}

#warning 测试
//性别
- (IBAction)sexT:(id)sender {
    _userView.hidden =NO;
    
}

- (void)selectedSexText:(NSString *)sex{
    _sexL.text =sex;
    _sexL.textColor =[UIColor blackColor];
    _sexL.font =[UIFont systemFontOfSize:14];
}


// 修改按钮事件
- (IBAction)confirmAction:(UIButton *)sender {
    if  (_nickName.text.length ==0){
        _nickName.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    }
    NSDictionary *params = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"sign":_sign.text,@"nickname":_nickName.text,@"sex":_sexL.text};
    
    [CYNetworkTool post:URL_ChangeInfo params:params success:^(id json) {
        if ([json[@"state"] isEqualToNumber:@1]) {
            
            [MBProgressHUD showSuccess:@"修改成功"];
            
            [[NSUserDefaults standardUserDefaults] setObject:_sign.text forKey:@"sign"];
            [[NSUserDefaults standardUserDefaults] setObject:_sexL.text forKey:@"sex"];
            [[NSUserDefaults standardUserDefaults] setObject:_nickName.text forKey:@"nickname"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {

            [MBProgressHUD showError:@"修改失败"];
        }
    }failure:^(NSError *error) {

        [MBProgressHUD showError:@"网络异常"];
    }];
}

#pragma mark - CY封装，改变头像

/**
 *  MARK:--------------------修改头像 --------------------
 */

- (IBAction)cilckChangeImageBtn:(id)sender {
    
    [self changeHeader];
}

- (void)changeHeader {
    
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
    
    [sheet showInView:self.view];
    
}

#pragma mark UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    // 相机
    if (buttonIndex == 1) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum | UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    // 相册
    else if(buttonIndex == 0) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        else {
            [MBProgressHUD showError:@"此设备不支持相机"];
            actionSheet.hidden = YES;
        }
    }
}

#pragma mark UIImagePickerController delegate
// 选取图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
//    NSLog(@"%@",info);
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
    
    MBProgressHUD *hub = [MBProgressHUD showMessage:@"正在更改头像"];
    hub.dimBackground = NO;
    
    //另一种压缩图片方法
    UIImage *newImg = [self imageCompressForWidth:image targetWidth:400];
    
    
    NSData *imgData = UIImageJPEGRepresentation(newImg, 0.0);
    
                 NSLog(@"%.2f",imgData.length/1.0);
    NSString *imgString = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary *params = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"headimg":imgString};
    /*
     [DataService requestURL:@"http://waji.zgcainiao.com/index.php?m=mmapi&c=member&a=get_hd" httpMethod:@"POST" params:params completion:^(id result) {
     
     NSLog(@"%@",result);
     if ([result[@"state"] isEqualToNumber:@1]) {
     
     [SVProgressHUD showSuccessWithStatus:@"更换头像成功"];
     _delegate.model.hdimg = imgString;
     [[NSUserDefaults standardUserDefaults]setObject:imgString forKey:@"hdimg"];
     }
     }];
     */
    _headImg.image = image;
    
    _delegate.model.hdimg = imgString;
    
    [[NSUserDefaults standardUserDefaults]setObject:imgString forKey:@"hdimg"];
    
    [CYNetworkTool post:URL_ChangeHdImg params:params success:^(id json) {
        if ([json[@"state"] isEqualToNumber:@1]) {
            
            [MBProgressHUD hideHUD];
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showError:@"网络异常"];
    }];
}

#pragma mark 图片等比例压缩
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSLog(@"%@",error);
}


//点击头像放大

- (IBAction)headImgAction:(UIButton *)sender {
    
    PhotoViewController *photoCtr = [[PhotoViewController alloc]init];
    if (_fromOtherController) {
    
        if (_model.hdimg != nil) {
            
            NSData *imgData = [[NSData alloc]initWithBase64EncodedString:_model.hdimg options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *headImg = [UIImage imageWithData:imgData];
            
            if (headImg != nil) {
                _headImg.image = headImg;
                
                photoCtr.img = headImg;
            }
        }
    
    }else{
    
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"hdimg"] != nil) {
            
            NSData *imgData = [[NSData alloc]initWithBase64EncodedString:[[NSUserDefaults standardUserDefaults] objectForKey:@"hdimg"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *headImg = [UIImage imageWithData:imgData];
            if (headImg != nil) {
                _headImg.image = headImg;
                photoCtr.img = headImg;

            }
        }
    
    }
    if (photoCtr.img) {
        
        [self.navigationController pushViewController:photoCtr animated:YES];
    }else{
        
        [MBProgressHUD showError:@"还没有上传头像"];
    
    }
    
    
}
@end
