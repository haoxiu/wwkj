//
//  SGLocationPickerView.m
//  LocationPicker(地区选择)
//
//  Created by Hanymore on 16/6/28.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "SGLocationPickerView.h"
#import "SGLocationPickerSheetView.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface SGLocationPickerView()<UIPickerViewDelegate, UIPickerViewDataSource>
/** SGLocationPickerSheetView对象 */
@property (nonatomic, strong) SGLocationPickerSheetView *SGLPSheetView;
/** 遮盖 */
@property (nonatomic, strong) UIButton *coverView;

// data
@property (strong, nonatomic) NSDictionary *pickerDic;
/** 省份 */
@property (strong, nonatomic) NSArray *provinceArr;
/** 城市 */
@property (strong, nonatomic) NSArray *cityArr;
/** 区，县 */
@property (strong, nonatomic) NSArray *areaArr;
/** 选择的数据 */
@property (strong, nonatomic) NSArray *selectedArr;

@end

@implementation SGLocationPickerView

static int const SGLocationPickerSheetViewHeight = 250;

- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, screenWidth, screenHeight); // 设置self的frame， 若没有设置button的点击事件不响应（想要响应button的点击事件， 其父视图必须有frame且大于button）
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        
        // 遮盖
        self.coverView = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0.0;
        [_coverView addTarget:self action:@selector(disApperCouponSheetView) forControlEvents:UIControlEventTouchUpInside];
        _coverView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        [self addSubview:self.coverView];
        
        // 获取数据
        [self getDateSourse];
        
        // SGLocationPickerSheetViewHeight
        self.SGLPSheetView = [[[NSBundle mainBundle] loadNibNamed:@"SGLocationPickerSheetView" owner:nil options:nil] firstObject];
        _SGLPSheetView.frame = CGRectMake(0, screenHeight, screenWidth, SGLocationPickerSheetViewHeight);
        _SGLPSheetView.pickerView.delegate = self;
        _SGLPSheetView.pickerView.dataSource = self;
        [_SGLPSheetView addCancelTarget:self action:@selector(disApperCouponSheetView)];
        [_SGLPSheetView addSureTarget:self action:@selector(sureButtonClick:)];
        [self addSubview:self.SGLPSheetView];
        
        // 出现
        [self appearCouponSheetView];
        
    }
    return self;
}

#pragma mark - - - 按钮的点击事件
- (void)sureButtonClick:(UIButton *)sender{
    NSString *province = [NSString stringWithFormat:@"%@", [self.provinceArr objectAtIndex:[self.SGLPSheetView.pickerView selectedRowInComponent:0]]];
    NSString *city = [NSString stringWithFormat:@"%@", [self.cityArr objectAtIndex:[self.SGLPSheetView.pickerView selectedRowInComponent:1]]];
    NSString *area = [NSString stringWithFormat:@"%@", [self.areaArr objectAtIndex:[self.SGLPSheetView.pickerView selectedRowInComponent:2]]];
    
    NSString *location = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:location,@"text", nil];
    //创建通知
    
    NSNotification *notification =[NSNotification notificationWithName:@"NickNotification" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];

//    self.locationMessage(location);
    
    [self disApperCouponSheetView];
}

// 出现
- (void)appearCouponSheetView{
    [UIView animateWithDuration:0.2 animations:^{
        self.SGLPSheetView.transform = CGAffineTransformMakeTranslation(0, - SGLocationPickerSheetViewHeight);
        self.coverView.alpha = 0.2;
    }];
}
// 消失
- (void)disApperCouponSheetView{
    [UIView animateWithDuration:0.2 animations:^{
        self.SGLPSheetView.transform = CGAffineTransformMakeTranslation(0, SGLocationPickerSheetViewHeight);
        self.coverView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.SGLPSheetView removeFromSuperview];
        [self.coverView removeFromSuperview];
        [self removeFromSuperview];
    }];
}


#pragma mark - 获取数据
- (void)getDateSourse {
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Address.plist" withExtension:nil];
//    
//    NSString *path = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.provinceArr = [self.pickerDic allKeys];
    self.selectedArr = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:0]];
    
    if (self.selectedArr.count > 0) {
        self.cityArr = [[self.selectedArr objectAtIndex:0] allKeys];
    }
    
    if (self.cityArr.count > 0) {
        self.areaArr = [[self.selectedArr objectAtIndex:0] objectForKey:[self.cityArr objectAtIndex:0]];
    }
}

#pragma mark - UIPicker UIPickerViewDataSource
// 返回列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}
// 每列多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArr.count;
    } else if (component == 1) {
        return self.cityArr.count;
    } else {
        return self.areaArr.count;
    }
}
#pragma mark - UIPicker UIPickerViewDelegate
// 返回当前行的内容, 此处是将数组中数值添加到滚动的那个显示栏上
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArr[row];
    } else if (component == 1) {
        return self.cityArr[row];
    } else {
        return self.areaArr[row];
    }
}
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 110;
    } else if (component == 1) {
        return 100;
    } else {
        return 110;
    }
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedArr = self.pickerDic[self.provinceArr[row]];
        
        if (self.selectedArr.count > 0) {
            self.cityArr = [self.selectedArr[0] allKeys];
//            [[self.selectedArr objectAtIndex:0] allKeys];
        } else {
            self.cityArr = nil;
        }
        if (self.cityArr.count > 0) {
            self.areaArr = self.selectedArr[0][self.cityArr[0]];
//            [[self.selectedArr objectAtIndex:0] objectForKey:[self.cityArr objectAtIndex:0]];
        } else {
            self.areaArr = nil;
        }
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1]; // 刷新列数
    [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
        if (self.selectedArr.count > 0 && self.cityArr.count > 0) {
            self.areaArr = [[self.selectedArr objectAtIndex:0] objectForKey:[self.cityArr objectAtIndex:row]];
        } else {
            self.areaArr = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    
    [pickerView reloadComponent:2];
}


@end
