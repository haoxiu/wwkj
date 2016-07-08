//
//  BuyCarViewController.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/23.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "BuyCarViewController.h"

#import "MBProgressHUD+NJ.h"
#import "CYNetworkTool.h"
#import "Header.h"

#include "DataService.h"
#import "XSAddressPicker.h"

@interface BuyCarViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIPickerView *_picker;
    NSArray *_provinces;
    NSArray *_cities;
    NSArray *_areas;
    NSString *province;
    NSString *city;
    NSString *area;
    UIView *locationView;
    UIView *dateView;
    NSMutableArray *_brands;
    NSArray *_types;
    NSArray *_conditions;
    NSArray *_applications;
    UITableView *_brandTable;
    UITableView *_typeTableView;
    UITableView *_conditionTableView;
    UITableView *_applicationTableView;
}
@property (nonatomic,strong) UITableView *smallTableView;
@property (nonatomic,strong) UIButton *cilckButton;
@end

@implementation BuyCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    if (_isBuyCar) {
        self.title = @"发布买车";
    }
    else {
        self.title = @"发布求租信息";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadBrandData];
    [self loadData];
    
    _smallTableView =[[UITableView alloc]initWithFrame:CGRectMake(0,self.view.height , self.view.width, 1/3.0*self.view.height) style:UITableViewStyleGrouped];
    _smallTableView.dataSource =self;
    _smallTableView.delegate =self;
    UIView *footView =[[UIView alloc]init];
    footView.backgroundColor =[UIColor whiteColor];
    _smallTableView.tableFooterView =footView;
    
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    
    [self setLeft:_smallTableView];
    [self.view addSubview:_smallTableView];
}
- (void)loadData {
    _types =  @[@"大型挖掘机",@"小型挖掘机",@"装载机",@"推土机",@"起重机",@"混凝土设备",@"压路机",@"其他"];
    
    _conditions = @[@"很好",@"较好",@"一般",@"较差",@"很差"];
    _applications = @[@"开挖建筑物基础",@"装载作业",@"开发渠道"];
    
    _provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    _cities = [[_provinces objectAtIndex:0] objectForKey:@"cities"];
    _areas = [[_cities objectAtIndex:0] objectForKey:@"areas"];
    
    province = @"北京";
    city = @"通州";
    area = @"";
}

// 选择品牌
- (IBAction)brandAction:(UIButton *)sender {
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
- (IBAction)typeAction:(UIButton *)sender {
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

// 选择所在地
- (IBAction)locationAction:(UIButton *)sender {
    [UIView animateWithDuration:0.1 animations:^{
        self.view .transform = CGAffineTransformIdentity;
    }];
    [self clear];
    locationView = [[UIView alloc]init];
    locationView.frame = CGRectMake(0, self.view.height, self.view.width, 200);
    [self.view addSubview:locationView];
    _picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 150)];
    _picker.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    _picker.tag = 3;
    _picker.dataSource = self;
    _picker.delegate = self;
    [locationView addSubview:_picker];
    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    confirm.frame = CGRectMake(20, 5, locationView.width - 40, 30);
    confirm.layer.cornerRadius = 7;
    confirm.backgroundColor = CYNavColor;
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(confirmLocation:) forControlEvents:UIControlEventTouchUpInside];
    [locationView addSubview:confirm];
    [UIView animateWithDuration:0.2 animations:^{
        
        locationView.transform = CGAffineTransformMakeTranslation(0, -150);
    }];
}
// 确定选择地点
- (void)confirmLocation:(UIButton *)button
{
    _locationL.text =[NSString stringWithFormat:@"%@%@%@",province,city,area];
    [UIView animateWithDuration:0.2 animations:^{
        button.superview.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [button.superview removeFromSuperview];
    }];
}




// 车况
- (IBAction)conditionAction:(UIButton *)sender {
 
    
    [self clear];
    _conditionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width *0.7, 135)];
    _conditionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _conditionTableView.delegate = self;
    _conditionTableView.dataSource = self;
    _conditionTableView.bounces = NO;
    _conditionTableView.layer.cornerRadius = 7;
    _conditionTableView.clipsToBounds = YES;
    _conditionTableView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    _conditionTableView.center = self.view.center;
    [_conditionTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"typeCell"];
    [self.view addSubview:_conditionTableView];
    [UIView animateWithDuration:0.3 animations:^{
        _conditionTableView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _conditionTableView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }];

}
// 用途
- (IBAction)applicationAction:(UIButton *)sender {
    
    [self clear];
    _applicationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width *0.7, 135)];
    _applicationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _applicationTableView.delegate = self;
    _applicationTableView.dataSource = self;
    _applicationTableView.bounces = NO;
    _applicationTableView.layer.cornerRadius = 7;
    _applicationTableView.clipsToBounds = YES;
    _applicationTableView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    _applicationTableView.center = self.view.center;
    [_applicationTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"typeCell"];
    [self.view addSubview:_applicationTableView];
    [UIView animateWithDuration:0.3 animations:^{
        _applicationTableView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            _applicationTableView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }];

}
// 发布
- (IBAction)publishAction:(UIButton *)sender {
    
    // 买车
    if (_isBuyCar) {
        
        if (_modelTF.text.length == 0  || _phoneTF.text.length == 0 || _contactTF.text.length == 0 || [_brandL.text isEqualToString:@"请选择"]||
            [_typeL.text isEqualToString:@"请选择"]||
            [_locationL.text isEqualToString:@"请选择"]) {
            
            [MBProgressHUD showError:@"请将信息填写完整"];
            return;
        }
    }
    // 求租
    else {
        if (_modelTF.text.length == 0 || _phoneTF.text.length == 0 || _contactTF.text.length == 0 ||[_brandBtn.currentTitle isEqualToString:@"请选择"]||
            [_typeL.text isEqualToString:@"请选择"]||
            [_locationL.text isEqualToString:@"请选择"]) {
    
            [MBProgressHUD showError:@"请将信息填写完整"];
            return;
        }

    }
    self.view.transform = CGAffineTransformIdentity;
    sender.enabled = NO;
    NSDictionary *params;
    if (_isBuyCar) {
        
        params = @{@"condition":@"",
                   @"worktime":@"",
                   @"cartype":_typeL.text,
                   @"price":@"",
                   @"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],
                   @"version":_modelTF.text,
                   @"place":_locationL.text,
                   @"catid":@19,
                   @"application":@"",
                   @"madetime":@"",
                   @"phone":_phoneTF.text,
                   @"contacts":_contactTF.text,
                   @"brand":_brandL.text,
                   @"descripion":_textView_1.text};
    }
    else {
        params = @{@"worktime":@"",
                   @"cartype":_typeL.text,
                   @"price":@"",
                   @"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],
                   @"version":_modelTF.text,
                   @"place":_locationL.text,
                   @"catid":@16,
                   @"madetime":@"",
                   @"phone":_phoneTF.text,
                   @"contacts":_contactTF.text,
                   @"brand":_brandL.text,
                   @"descripion":_textView_1.text
                   };
    }
    
    MBProgressHUD *hd = [MBProgressHUD showMessage:@"正在发布"];
    hd.dimBackground = NO;
    
    
    [CYNetworkTool post:URL_PublishAll params:params success:^(id json) {
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
    
    if (textField == _phoneTF) {
        
        if (![Utility isValidateMobile:textField.text] && textField.text.length != 0) {
            
            [MBProgressHUD showError:@"手机号格式不正确"];
            textField.text = nil;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.1 animations:^{
        self.view .transform = CGAffineTransformIdentity;
    }];
    return YES;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 35;
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

// 判断手机号是否合法
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
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

#pragma mark UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_cilckButton) {
        if (_cilckButton ==_brandBtn) {
            return _brands.count;
        }else{
            return _types.count;
        }
    }else{
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID =@"samll";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (_cilckButton ==_brandBtn) {
        cell.textLabel.text =_brands[indexPath.row];
    }else{
        cell.textLabel.text =_types[indexPath.row];
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
        if (cell.textLabel.text ==_brands[indexPath.row]){
            _brandL.text =cell.textLabel.text;
        }else{
            _typeL.text =cell.textLabel.text;
        }
        
    }];
    
}

- (void)loadBrandData{
    NSString *catid;
    if (_isBuyCar) {
        catid = @"13";
    }
    else {
        catid = @"14";
    }
    [DataService requestURL:@"http://eswjdg.com/index.php?m=mmapi&c=index&a=get_cat" httpMethod:@"POST" params:@{@"catid":catid} completion:^(id result) {
        _brands = [NSMutableArray array];
//        NSLog(@"%@",result);
        for (NSDictionary *dic in result) {
            [_brands addObject:dic[@"catname"]];
        }
        [_brandTable reloadData];
    }];
}
@end
