//
//  SellViewController.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/24.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "SellViewController.h"
#import "DoImagePickerController.h"
#import "DataService.h"

#import "MBProgressHUD+NJ.h"
#import "CYNetworkTool.h"
#import "Header.h"

#import "LcPrint+LLDB.h"
#import "LcPrint.h"
#import "AroundViewController.h"
@interface SellViewController ()<UITableViewDelegate,UITableViewDataSource,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate>
{
    NSMutableArray *_imgs;
    UIPickerView *_picker;
    NSArray *_provinces;
    NSArray *_cities;
    NSArray *_areas;
    NSString *province;
    NSString *city;
    NSString *area;
    UIView *locationView;
    UIView *dateView;
    NSArray *_brands;
    NSArray *_types;
    NSArray *_conditions;
    NSArray *_applications;
    UITableView *_brandTable;
    UITableView *_typeTableView;
    UITableView *_conditionTableView;
    UITableView *_applicationTableView;
    int catid1;    //?
    
}
@property (nonatomic,strong)UIButton *cilckButton;
@property (nonatomic,strong)UITableView *smallTableView;
@end

@implementation SellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_isSell) {
        self.title = @"发布卖车信息";
    }
    else {
        self.title = @"发布出租信息";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    _backScrollView.contentOffset =CGPointZero;
    _backScrollView.contentSize =CGSizeMake(self.view.width, _backView.height);
    
    [_picCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"picCell"];
    _imgs = [NSMutableArray array];
    
    _time.keyboardType = UIKeyboardTypeNumberPad;
    _jiage.keyboardType = UIKeyboardTypeNumberPad;
    _phone.keyboardType = UIKeyboardTypeNumberPad;

    [self loadData];
    
    _smallTableView =[[UITableView alloc]initWithFrame:CGRectMake(0,self.view.height , self.view.width, 1/3.0*self.view.height) style:UITableViewStyleGrouped];
    _smallTableView.dataSource =self;
    _smallTableView.delegate =self;
    UIView *footView =[[UIView alloc]init];
    footView.backgroundColor =[UIColor whiteColor];
    _smallTableView.tableFooterView =footView;
    [self setLeft:_smallTableView];
    [self.view addSubview:_smallTableView];
}

- (void)loadData {
    
    _types =  @[@"大型挖掘机",@"小型挖掘机",@"装载机",@"推土机",@"起重机",@"混凝土设备",@"压路机",@"其他"];
    _conditions = @[@"一般",@"良好",@"较好"];
    _applications = @[@"用途不确定",@"租赁设备",@"自用设备",@"矿山设备",@"其他"];
    _brands = @[@"小松",@"卡特",@"加藤",@"神钢",@"佳友",@"现代",@"斗山",@"三一",@"其他",@"沃尔沃",@"日立",@"柳工",@"龙工"];
    
    _provinces = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"]];
    _cities = _provinces[0][@"cities"];
    _areas = _cities[0][@"areas"];
    province = @"北京";
    city = @"通州";
    area = @"";

}
// 添加图片
- (void)addPic {
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
    [sheet showInView:self.view];
}
// 删除图片
- (void)delPic:(UILongPressGestureRecognizer *)press {
    
    if (press.state == UIGestureRecognizerStateBegan) {
        
        [_imgs removeObjectAtIndex:press.view.superview.superview.tag];
        [UIView animateWithDuration:.3 animations:^{
            
            press.view.transform = CGAffineTransformMakeScale(0.2, 0.2);
        } completion:^(BOOL finished) {
            [_picCollectionView reloadData];
        }];
    }
}
// 选择所在地
- (IBAction)locationAction:(UIButton *)sender {
    
    AroundViewController*vc=[[AroundViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
     NSString * addressStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"addressStr"];
    _place.text = addressStr;
 }

- (IBAction)brandBtnClick:(id)sender {
    
    UIView *shadeView =[[UIView alloc]initWithFrame:self.view.frame];
    shadeView.backgroundColor =[UIColor colorWithWhite:0.5 alpha:0.5];
    shadeView.tag =20;
    [self.view insertSubview:shadeView belowSubview:_smallTableView];
    _cilckButton =sender;
    [_smallTableView reloadData];
    [UIView animateWithDuration:.5 animations:^{
        _smallTableView.transform =CGAffineTransformMakeTranslation(0, -1/3.0 *self.view.height);
    } completion:^(BOOL finished) {
    }];
}
// 选择类型
- (IBAction)cilckButtonChange:(UIButton *)sender {
    
    UIView *shadeView =[[UIView alloc]initWithFrame:self.view.frame];
    shadeView.backgroundColor =[UIColor colorWithWhite:0.5 alpha:0.5];
    shadeView.tag =20;
    [self.view insertSubview:shadeView belowSubview:_smallTableView];
    _cilckButton =sender;
    [_smallTableView reloadData];
    [UIView animateWithDuration:.5 animations:^{
        _smallTableView.transform =CGAffineTransformMakeTranslation(0, -1/3.0 *self.view.height);
    } completion:^(BOOL finished) {
        
    }];
}

// 选择生成年份
- (IBAction)madetimeAction:(UIButton *)sender {

    [UIView animateWithDuration:0.1 animations:^{
        self.view .transform = CGAffineTransformIdentity;
    }];
    [self clear];
    dateView = [[UIView alloc]init];
    dateView.frame = CGRectMake(0, self.view.height, self.view.width, 150);
    [self.view addSubview:dateView];
    UIDatePicker *picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    picker.date = [NSDate dateWithTimeIntervalSince1970:725328000+567648000];
    
    //
    [picker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    
    picker.datePickerMode = UIDatePickerModeDate;
    picker.maximumDate = [NSDate date];
    picker.backgroundColor = [UIColor lightGrayColor];
    picker.tag = 3;
    [dateView addSubview:picker];
    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    confirm.frame = CGRectMake(20, 5, dateView.width - 40, 30);
    confirm.layer.cornerRadius = 7;
    confirm.backgroundColor = CYNavColor;
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(confirmTime:) forControlEvents:UIControlEventTouchUpInside];
    [dateView addSubview:confirm];
    [UIView animateWithDuration:0.2 animations:^{
        
        dateView.transform = CGAffineTransformMakeTranslation(0, -150);
    }];

}

// 确定选择日期
- (void)confirmTime:(UIButton *)button {
    UIDatePicker *picker = (UIDatePicker *)[button.superview viewWithTag:3];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:picker.date];
    _nianfenL.text =dateString;
    [UIView animateWithDuration:0.2 animations:^{
        button.superview.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
        [button.superview removeFromSuperview];
    }];
    
}

// 发布
- (IBAction)publishAction:(UIButton *)sender {

    if (_lianxiren.text.length ==0||_phone.text.length ==0 || [_brandL.text isEqualToString:@"请选择"]|| _xiaobiaoti.text.length ==0 ||[_leixingL.text isEqualToString:@"请选择"] ||
        [_place.text isEqualToString:@"我的位置"]) {
        [MBProgressHUD showError:@"请将信息填写完整"];
        return;
    }
    else if (_imgs.count == 0 || _imgs == nil) {
         [MBProgressHUD showError:@"请添加图片"];
        return;
    }
    sender.enabled = NO;
    NSString *catid;
    if (_isSell) {
        catid = @"28";
    }
    else {
        catid = @"21";
    }
 //    [mParams setObject:catid forKey:@"catid"];
//    NSLog(@"%@",mParams);
    float jiage = [_jiage.text floatValue];
    NSString *jiage1 = [NSString stringWithFormat:@"%.2f",(jiage /10000)];
    
    NSDictionary *params = @{@"condition":_chekuangL.text,
                @"worktime":_time.text,
                @"cartype":_leixingL.text,
                @"price":jiage1,
                @"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],
                @"version":_xiaobiaoti.text,
                @"place":_place.text,
                @"catid":catid,
                @"application":_yongtuL.text,
                @"madetime":_nianfenL.text,
                @"phone":_phone.text,
                @"contacts":_lianxiren.text,
                @"brand":_brandL.text,
                @"description":_miaoshu.text};

    NSMutableDictionary *mParams = [NSMutableDictionary dictionaryWithDictionary:params];
    NSMutableArray *_imgArr = [NSMutableArray array];
    for (int i = 0; i < _imgs.count; i++) {
        NSData *imgData = UIImageJPEGRepresentation(_imgs[i], 1.0f);
        //      NSLog(@"%.2f",imgData.length/1000000.0);
        CGFloat size = imgData.length/1000000.0;
        //计算图片多少M，如果大于2M，就压缩成0.2倍
        if (size>2) {
            imgData = UIImageJPEGRepresentation(_imgs[i], 0.2f);
        }
        else if (size>1) {
            imgData = UIImageJPEGRepresentation(_imgs[i], 0.4);
        }
        
        //        NSLog(@"data--------%.2f",imgData.length/1000000.0);
        NSString *imgString = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [mParams setObject:imgString forKey:[NSString stringWithFormat:@"picture[%d]",i]];
        [_imgArr addObject:imgString];
    }
//    NSLog(@"%@",mParams);
    MBProgressHUD *hd = [MBProgressHUD showMessage:@"正在发布"];
    hd.dimBackground = NO;
    
    [CYNetworkTool post:URL_PublishAll params:mParams success:^(id json) {
        [MBProgressHUD hideHUD];
        
//        LcPrint(mParams);
        
        if ([json[@"state"] isEqualToString:@"1"]) {
            
            [MBProgressHUD showSuccess:@"发布成功,正在等待审核"];
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:nil afterDelay:.5];
        }
        else {
            
            [MBProgressHUD showError:@"发布失败"];
            sender.enabled = YES;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常"];
    }];
}

// 移除弹窗
- (void)clear {
    
    [locationView removeFromSuperview];
    locationView = nil;
    
    [dateView removeFromSuperview];
    dateView = nil;
    
    [_typeTableView removeFromSuperview];
    _typeTableView = nil;
    
    [_conditionTableView removeFromSuperview];
    _conditionTableView = nil;
    
    [_applicationTableView removeFromSuperview];
    _applicationTableView = nil;
    
    [_brandTable removeFromSuperview];
    _brandTable = nil;
    
    self.view.transform = CGAffineTransformIdentity;
    
    [self.view endEditing:YES];
}

#pragma mark - DoImagePickerControllerDelegate
// 取消
- (void)didCancelDoImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 选中照片
- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [_imgs addObjectsFromArray:aSelected];
    
    [_picCollectionView reloadData];
    
}

#pragma - mark UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:{
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:NULL];
            }
            else {
                [MBProgressHUD showError:@"此设备不支持相机"];
            }
        }
            break;
        case 1://相冊
        {
            DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
            cont.delegate = self;
            cont.nResultType = DO_PICKER_RESULT_UIIMAGE;
            cont.nMaxCount = 9-_imgs.count;
            cont.nColumnCount = 4;
            [self presentViewController:cont animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    [_imgs addObject:img];
    [_picCollectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
}


#pragma mark - UICollectionView delegate
// 单元格大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(collectionView.width/3 - 10, collectionView.height);
}

// 单元格数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_imgs.count == 0) {
        return 1;
    }
    else {
        if (_imgs.count == 9) {
            return 9;
        }
        else{
            return _imgs.count+1;
        }
    }
}

// 返回单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"picCell" forIndexPath:indexPath];
    cell.tag = indexPath.item;
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 11, cell.contentView.width-30, cell.contentView.height-22)];
//    imageview.layer.cornerRadius = 5;
    
    imageview.clipsToBounds = YES;
    imageview.userInteractionEnabled = YES;
    
    if (_imgs.count == 0) {
        
        imageview.image = [UIImage imageNamed:@"add_img"];
        UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPic)];
        [imageview addGestureRecognizer:tap];
    }
    else {
        
        if (indexPath.item == _imgs.count) {
            
            imageview.image = [UIImage imageNamed:@"add_img"];
            UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPic)];
            [imageview addGestureRecognizer:tap];
        }
        else {
            [imageview setImage:_imgs[indexPath.item]];
            UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(delPic:)];
            [imageview addGestureRecognizer:press];
        }
        
    }
    [cell.contentView addSubview:imageview];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *subView = [cell.contentView subviews];
    [subView makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark - UIPickerView delegate
// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;
}
// 每列行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
            return _provinces.count;
            break;
        case 1:
            return _cities.count;
            break;
        case 2:
            return _areas.count;
            break;
        default:
            return 0;
            break;
    }
}
// 标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
            return [[_provinces objectAtIndex:row] objectForKey:@"state"];
            break;
        case 1:
            return [[_cities objectAtIndex:row] objectForKey:@"city"];
            break;
        case 2:
            if ([_areas count] > 0) {
                return [_areas objectAtIndex:row];
                break;
            }
        default:
            return  @"";
            break;
    }
}
// 选中行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
            _cities = [[_provinces objectAtIndex:row] objectForKey:@"cities"];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView reloadComponent:1];
            
            _areas = [[_cities objectAtIndex:0] objectForKey:@"areas"];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
            
            province = [[_provinces objectAtIndex:row] objectForKey:@"state"];
            city = [[_cities objectAtIndex:0] objectForKey:@"city"];
            if ([_areas count] > 0) {
                area = [_areas objectAtIndex:0];
            } else{
                area = @"";
            }
            break;
        case 1:
            _areas = [[_cities objectAtIndex:row] objectForKey:@"areas"];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
            
            city = [[_cities objectAtIndex:row] objectForKey:@"city"];
            if ([_areas count] > 0) {
                area = [_areas objectAtIndex:0];
            } else{
                area = @"";
            }
            break;
        case 2:
            if ([_areas count] > 0) {
                area = [_areas objectAtIndex:row];
            } else{
                area = @"";
            }
            break;
        default:
            break;
    }
    
}

#pragma mark UITextField - delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
    [UIView animateWithDuration:0.2 animations:^{
        dateView.transform = CGAffineTransformIdentity;
        locationView.transform = CGAffineTransformIdentity;
        _brandTable.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
        
        [locationView removeFromSuperview];
        locationView = nil;
        
        [dateView removeFromSuperview];
        dateView = nil;
        
        [_typeTableView removeFromSuperview];
        _typeTableView = nil;
        
        [_conditionTableView removeFromSuperview];
        _conditionTableView = nil;
        
        [_applicationTableView removeFromSuperview];
        _applicationTableView = nil;
        
        [_brandTable removeFromSuperview];
        _brandTable = nil;

    }];
    
//    if (textField == _contactTF || textField == _phoneTF) {
//        
//        [UIView animateWithDuration:0.3 animations:^{
//            CGRect frame = textField.frame;
//            int offset = frame.origin.y -52 - (self.view.frame.size.height - 216.0);//键盘高度216
//            //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
//            if(offset > 0)
//                //                self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
//                self.view.transform = CGAffineTransformMakeTranslation(0, -offset);
//        }];
//        
//
//    }
//    else {
//    [UIView animateWithDuration:0.3 animations:^{
//        CGRect frame = textField.frame;
//        int offset = frame.origin.y + 97 - (self.view.frame.size.height - 216.0);//键盘高度216
//        //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
//        if(offset > 0)
//            //                self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
//            self.view.transform = CGAffineTransformMakeTranslation(0, -offset);
//    }];
//    }
    
}

// 输入框回车
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.1 animations:^{
        self.view .transform = CGAffineTransformIdentity;
    }];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _phone) {
        
        if (![self isValidateMobile:textField.text]) {
            
            [MBProgressHUD showError:@"手机号格式不正确"];
            textField.text = nil;
        }
    }
}

#pragma mark - UITextView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    [UIView animateWithDuration:0.15 animations:^{
        
        self.view .transform = CGAffineTransformMakeTranslation(0, -fabs(textView.y+20-(self.view.height - 216)));
    }];
    
    [locationView removeFromSuperview];
    locationView = nil;
    
    [dateView removeFromSuperview];
    dateView = nil;
    
    [_typeTableView removeFromSuperview];
    _typeTableView = nil;
    
    [_conditionTableView removeFromSuperview];
    _conditionTableView = nil;
    
    [_applicationTableView removeFromSuperview];
    _applicationTableView = nil;
    
    [_brandTable removeFromSuperview];
    _brandTable = nil;

}

// 监听return键
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        [UIView animateWithDuration:0.1 animations:^{
            self.view .transform = CGAffineTransformIdentity;
        }];
        return NO;
    }
    
    return YES;
}

// 判断手机号是否合法
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_cilckButton ==_leixingBtn) {
        return _types.count;
    }else if (_cilckButton ==_chekuangBtn){
        return _conditions.count;
    }else if (_cilckButton ==_brandBtn) {
        return _brands.count;
    }
    else{
        return _applications.count;
    }

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID =@"samll";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (_cilckButton ==_leixingBtn) {
        cell.textLabel.text =_types[indexPath.row];
    }else if (_cilckButton ==_chekuangBtn){
        cell.textLabel.text =_conditions[indexPath.row];
    }else if (_cilckButton ==_brandBtn) {
        cell.textLabel.text =_brands[indexPath.row];
    }
    else{
        cell.textLabel.text =_applications[indexPath.row];
    }
    [self setLeftCell:cell];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _cilckButton =nil;
    [UIView animateWithDuration:0.5 animations:^{
        _smallTableView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [[self.view viewWithTag:20] removeFromSuperview];
        
        UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.textLabel.text == _brands[indexPath.row]){
            
            _brandL.text =cell.textLabel.text;

        }else if (cell.textLabel.text ==_types[indexPath.row]){
            
            _leixingL.text =cell.textLabel.text;
            
        }else if (cell.textLabel.text ==_applications[indexPath.row]){
            
            _yongtuL.text =cell.textLabel.text;
            
        }else {
            
            _chekuangL.text =cell.textLabel.text;
        }
    }];
}

- (void)setLeft:(UITableView *)tab{
    if ([tab respondsToSelector:@selector(setSeparatorInset:)]) {
        [tab setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([tab respondsToSelector:@selector(setLayoutMargins:)]) {
        [tab setLayoutMargins: UIEdgeInsetsZero];
    }
}

- (void)setLeftCell:(UITableViewCell *)cell{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins: UIEdgeInsetsZero];
    }
}

@end
