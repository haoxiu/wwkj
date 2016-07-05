//
//  QiuZhiViewController.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/19.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "QiuZhiViewController.h"

#import "MBProgressHUD+NJ.h"
#import "CYNetworkTool.h"
#import "Header.h"

@interface QiuZhiViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *_provinces;
    NSArray *_cities;
    NSArray *_areas;
    NSString *province;
    NSString *city;
    NSString *area;
}
@property (nonatomic,strong)UITableView *smallTableView;
@property (nonatomic,strong)UIButton *cilckButton;

@property (nonatomic,strong)NSArray *sexArr;
@property (nonatomic,strong)NSArray *exlArr;
@property (nonatomic,strong)NSArray *education;
@property (nonatomic,strong) UIView *locationView;
@property (nonatomic,strong) UIPickerView *picker;

@end

@implementation QiuZhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布求职";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self _loadViews];
    
    _qiwang.keyboardType = UIKeyboardTypeNumberPad;
    _phone.keyboardType = UIKeyboardTypeNumberPad;
    
    _picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height, self.view.width, 100 +64)];
    _picker.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    _picker.tag = 3;
    _picker.dataSource = self;
    _picker.delegate = self;
    _provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    _cities = [[_provinces objectAtIndex:0] objectForKey:@"cities"];
    _areas = [[_cities objectAtIndex:0] objectForKey:@"areas"];
    province = @"北京";
    city = @"通州";
    area = @"";
    [self.view addSubview:_picker];
}

- (void)_loadViews {
    _exlArr =@[@"一年以下",@"一年",@"两年",@"三年",@"四年",@"五年",@"五年以上"];
    _education = @[@"初高中以下",@"大专",@"本科",@"硕士",@"博士"];
    _sexArr =@[@"男",@"女"];
    _publishBtn.layer.cornerRadius = 4;
    _smallTableView =[[UITableView alloc]initWithFrame:CGRectMake(0,self.view.height , self.view.width, 1/3.0 *[UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    _smallTableView.dataSource =self;
    _smallTableView.delegate =self;
    UIView *footView =[[UIView alloc]init];
    footView.backgroundColor =[UIColor whiteColor];
    _smallTableView.tableFooterView =footView;
    [self setLeft:_smallTableView];
    [self.view addSubview:_smallTableView];
}

// 选择出生日期
- (IBAction)birthdayAction:(UIButton *)sender {
    [UIView animateWithDuration:0.1 animations:^{
        self.view .transform = CGAffineTransformIdentity;
    }];
    for (int i = 10; i <= 30; i+=20) {
        UIView *view = [self.view viewWithTag:i];
        [UIView animateWithDuration:0.2 animations:^{
            view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    [self.view endEditing:YES];
    if ([self.view viewWithTag:20] != nil) {
        return;
    }
    UIView *dateView = [[UIView alloc]init];
    dateView.frame = CGRectMake(0, self.view.height, self.view.width, 150);
    dateView.tag = 20;
    [self.view addSubview:dateView];
    UIDatePicker *picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    picker.date = [NSDate dateWithTimeIntervalSince1970:725328000];
    picker.datePickerMode = UIDatePickerModeDate;
    picker.maximumDate = [NSDate date];
    picker.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
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
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:picker.date];
    _yearL.text =dateString;
    [UIView animateWithDuration:0.2 animations:^{
        button.superview.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [button.superview removeFromSuperview];
    }];

}

// 发布
- (IBAction)publishAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    if (_name.text.length == 0 ||
        _workbackL.text.length ==0||
        _phone.text.length ==0) {
        [MBProgressHUD showError:@"请将信息填写完整"];
        return;
    }
    
    sender.enabled = NO;
    NSDictionary *params = @{@"name":_name.text,
                             @"sex":_sexL.text,
                             @"brithday":_yearL.text,
                             @"jobback":_workbackL.text,
                             @"education":_xueliL.text,
                             @"salary":_qiwang.text,
                             @"workplace":_placeL.text,
                             @"jobtype":_classT.text,
                             @"phone":_phone.text,
                             @"content":_textView.text,
                             @"catid":@10,
                             @"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]};
    
    MBProgressHUD *hd = [MBProgressHUD showMessage:@"正在发布"];
    hd.dimBackground = NO;
    
    [CYNetworkTool post:URL_PublishQz params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        
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


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == _phone) {
        
        if (![self isValidateMobile:textField.text] && textField.text.length != 0) {
            
            [MBProgressHUD showError:@"手机号格式不正确"];
            textField.text = nil;
        }
    }
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

#pragma mark UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_cilckButton) {
        if (_cilckButton ==_workbackBtn) {
            return _exlArr.count;
        }else if (_cilckButton ==_xueliBtn){
            return _education.count;
        }else {
            return _sexArr.count;
        }
    }else{
        return 1;
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
    if (_cilckButton ==_workbackBtn) {
        cell.textLabel.text =_exlArr[indexPath.row];
    }else if (_cilckButton ==_xueliBtn){
        cell.textLabel.text =_education[indexPath.row];
    }else{
        cell.textLabel.text =_sexArr[indexPath.row];
    }
    [self setLeftCell:cell];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _cilckButton =nil;
    [UIView animateWithDuration:0.5 animations:^{
        _smallTableView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [[self.view viewWithTag:40] removeFromSuperview];
        UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
        if (cell.textLabel.text ==_exlArr[indexPath.row]){
            _workbackL.text =cell.textLabel.text;
        }else if(cell.textLabel.text ==_education[indexPath.row]){
            _xueliL.text =cell.textLabel.text;
        }else{
            _sexL.text =cell.textLabel.text;
        }
    }];
}

- (IBAction)cilckButtonChange:(UIButton *)sender {
    UIView *shadeView =[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    shadeView.backgroundColor =[UIColor colorWithWhite:0.5 alpha:0.5];
    shadeView.tag =40;
    [self.view insertSubview:shadeView belowSubview:_smallTableView];
    _cilckButton =sender;
    [_smallTableView reloadData];
    [UIView animateWithDuration:.5 animations:^{
        _smallTableView.transform =CGAffineTransformMakeTranslation(0, -(1/3.0 *self.view.height +64));
    } completion:^(BOOL finished) {
        
    }];
}
- (IBAction)place:(UIButton *)sender {
    UIView *locationView = [[UIView alloc]init];
    locationView.frame =[UIScreen mainScreen].bounds;
    [self.view insertSubview:locationView belowSubview:_picker];
    locationView.backgroundColor =[UIColor colorWithWhite:0.5 alpha:0.5];
    locationView.tag =30;
    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    confirm.frame = CGRectMake(20, self.view.height, self.view.width - 40, 30);
    confirm.layer.cornerRadius = 7;
    confirm.backgroundColor = kNaviColor;
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(confirmLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirm];
    [UIView animateWithDuration:.5 animations:^{
        _picker.transform =CGAffineTransformMakeTranslation(0, -(_picker.height +64));
        confirm.transform =CGAffineTransformMakeTranslation(0, -_picker.height +30);
    }];
}

- (void)confirmLocation:(UIButton *)button {
    _placeL.text =[NSString stringWithFormat:@"%@%@%@",province,city,area];
    [UIView animateWithDuration:0.2 animations:^{
        button.transform = CGAffineTransformIdentity;
        _picker.transform =button.transform;
    } completion:^(BOOL finished) {
        [[self.view viewWithTag:30] removeFromSuperview];
    }];
    
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
