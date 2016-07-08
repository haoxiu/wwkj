//
//  PersonInfoViewController.m
//  玩械宝
//
//  Created by 刘昊 on 16/6/29.
//  Copyright © 2016年 zgcainiao. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "AppDelegate.h"

#import "userSexLableText.h"
#import "Header.h"
#import "MBProgressHUD+NJ.h"
#import "CYNetworkTool.h"
#import "UIImage+KIAdditions.h"
#import "PhotoViewController.h"
#import "SGLocationPickerView.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface PersonInfoViewController ()<UIAlertViewDelegate,UITextViewDelegate>{
    UITableViewCell *cell;
    UITextView *_textView;
    AppDelegate *_delegate;
    UIImage *img;
    NSString *username;
    
    
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIImageView *headImg;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *sexL;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *lacation;
@property (nonatomic) SGLocationPickerView *pickerView;


@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    _titles = @[@"头像",@"昵称",@"账号",@"性别",@"地区"];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PublishCell"];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isSaved"] isEqualToString:@"1"]) {
        
        [self refreshViewsWithDefult];
    }else {
        
        MBProgressHUD *hub = [MBProgressHUD showMessage:@"正在加载"];
        hub.dimBackground = NO;
        [self _loadData];
    }
       //地区通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"NickNotification" object:nil];
    
}
- (void)tongzhi:(NSNotification *)text{
    NSLog(@"%@",text.userInfo[@"text"]);
    NSLog(@"－－－－－接收到通知------");
    self.lacation.text = text.userInfo[@"text"];
    
}


- (void)setModel:(DetailInfoModel *)model {
    
    if (_model != model) {
        
        _model = model;
        
        [self refreshViews];
    }
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
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *str = [userDefaults stringForKey:@"hdimg"];
        _headImg.image = [UIImage imageNamed:str];
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
    //    _userName_1.text =[_model.username substringWithRange:NSMakeRange(0, 3)];
    //    _userName_2.text =[_model.username substringWithRange:NSMakeRange(3, 4)];
    _userName.text = [_model.username substringWithRange:NSMakeRange(7, 4)];
    _lacation.text = _model.sign;
    _sexL.text = _model.sex;
}
- (void)refreshViewsWithDefult {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"hdimg"] != nil) {
        
        NSData *imgData = [[NSData alloc]initWithBase64EncodedString:[[NSUserDefaults standardUserDefaults] objectForKey:@"hdimg"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *headImg = [UIImage imageWithData:imgData];
        if (headImg != nil) {
            _headImg.image = headImg;
            
        }
    }
    //    _nickName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
    
    //    _userName_1.text =[username substringWithRange:NSMakeRange(0, 3)];
    //    _userName_2.text =[username substringWithRange:NSMakeRange(3, 4)];
    //    _userName.text = [username substringWithRange:NSMakeRange(0, 7)];
    //
        username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
//        _lacation.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"sign"];
//        _sexL.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"sex"];
        NSString *imgStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"hdimg"];
        NSData *imgData = [[NSData alloc]initWithBase64EncodedString:imgStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        img = [UIImage imageWithData:imgData];
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _titles.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cell = [tableView dequeueReusableCellWithIdentifier:@"PublishCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        _headImg = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width*0.85, 2, 40, 40)];
        _headImg.image = img;
        _headImg.layer.cornerRadius = 5;
        _headImg.clipsToBounds = YES;
        [cell addSubview:_headImg];
        
    }if (indexPath.row == 1) {
        _nickName = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width*0.5, 0, 150, 44)];
        _nickName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
        _nickName.textAlignment = NSTextAlignmentRight;
        [cell addSubview:_nickName];
    }if (indexPath.row == 2) {
        _userName = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width*0.5, 0, 150, 44)];
        _userName.text = [username substringWithRange:NSMakeRange(0, 11)];
        _userName.textAlignment = NSTextAlignmentRight;
        [cell addSubview:_userName];
    }if (indexPath.row == 3) {
        _sexL = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width*0.5, 0, 150, 44)];
        _sexL.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"sex"];
        _sexL.textAlignment = NSTextAlignmentRight;
        [cell addSubview:_sexL];
    } if (indexPath.row == 4) {
        _lacation = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width*0.45, 0, 200, 44)];
        _lacation.textAlignment = NSTextAlignmentLeft;
        _lacation.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"sign"];
        //         _lacation.text = _pickerView.locationMessage(location);
        [cell addSubview:_lacation];
    } //添加 字典，将label的值通过key值设置传递
   
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}


//- (void)blockls:(MyBlock )locationMessage
//{
//        locationMessage = ^(NSString *str){
//        _lacation.text = str;
//    };
//}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return CGFLOAT_MIN;
    return tableView.sectionHeaderHeight;
}
#pragma mark 单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}
#pragma mark 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //取消单元格选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
        
        [sheet showInView:self.view];
    }if (indexPath.row == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改昵称" message:@"请输入" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
        
    }if (indexPath.row == 2) {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"账号" message:@"账号无法修改" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alert1 show];
    }if (indexPath.row == 3) {
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"性别选择" message:@" " delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"男",@"女", nil];
        [alertV show];
        
    }if (indexPath.row == 4) {
        _pickerView = [[SGLocationPickerView alloc] init];
        
        [_pickerView appearCouponSheetView];
        
    }
//    NSDictionary *param = @{@"sign":_lacation.text};
//    
//    [CYNetworkTool post:URL_ChangeInfo params:param success:^(id json) {
//        if ([json[@"state"] isEqualToNumber:@1]) {
//            
//            //                [MBProgressHUD showSuccess:@"修改成功"];
//            
//            [[NSUserDefaults standardUserDefaults] setObject:_lacation.text forKey:@"sign"];
//        }else {
//            
//            [MBProgressHUD showError:@"修改失败"];
//        }
//    }failure:^(NSError *error) {
//        
//        [MBProgressHUD showError:@"网络异常"];
//    }];

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
    
//    //添加 字典，将label的值通过key值设置传递
//    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:image,@"img", nil];
//    //创建通知
//    
//    NSNotification *notification =[NSNotification notificationWithName:@"NickNotifica" object:nil userInfo:dict];
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_headImg.image,@"img", nil];
    //创建通知
    
    NSNotification *notification =[NSNotification notificationWithName:@"NickNotifica" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    
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

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([alertView.title isEqualToString:@"修改昵称"]) {
        if ([buttonTitle isEqualToString:@"确定"]){
            UITextField *tf=[alertView textFieldAtIndex:0];//获得输入框
            NSString * requestedURL = tf.text;//获得值
            _nickName.text = requestedURL;
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_nickName.text,@"name", nil];
            //创建通知
            
            NSNotification *nottion =[NSNotification notificationWithName:@"NickNotificas" object:nil userInfo:dict];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:nottion];

           
        }
    }else if ([alertView.title isEqualToString:@"性别选择"]){
        if ([buttonTitle isEqualToString:@"男"]) {
            _sexL.text = @"男";
        }if ([buttonTitle isEqualToString:@"女"]) {
            _sexL.text = @"女";
        }
    }
    
    NSDictionary *params = @{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"nickname":_nickName.text,@"sex":_sexL.text,@"sign":_lacation.text};
    
    [CYNetworkTool post:URL_ChangeInfo params:params success:^(id json) {
        if ([json[@"state"] isEqualToNumber:@1]) {
            if ([buttonTitle isEqualToString:@"确定"]) {
                
                [MBProgressHUD showSuccess:@"修改成功"];
                
                [[NSUserDefaults standardUserDefaults] setObject:_lacation.text forKey:@"sign"];
                [[NSUserDefaults standardUserDefaults] setObject:_sexL.text forKey:@"sex"];
                [[NSUserDefaults standardUserDefaults] setObject:_nickName.text forKey:@"nickname"];
                
                //            [self.navigationController popViewControllerAnimated:YES];
            }
        }else {
            
            [MBProgressHUD showError:@"修改失败"];
        }
    }failure:^(NSError *error) {
        
        [MBProgressHUD showError:@"网络异常"];
    }];
    
}


@end
