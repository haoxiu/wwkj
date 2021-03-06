//
//  Utility.m
//  乐浪
//
//  Created by 肖胜 on 15/8/12.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "Utility.h"
const double a = 6378245.0;
const double ee = 0.00669342162296594323;
const double pi = 3.14159265358979324;


@implementation Utility
//归档
+ (BOOL)archiver:(id)object Path:(NSString *)path forKey:(NSString *)key{
    
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:object forKey:key];
    [archiver finishEncoding];
    BOOL success = [data writeToFile:path atomically:YES];
    return success;
}

// 解档
+ (id)unarchiverWithPath:(NSString *)path forKey:(NSString *)key{
    
    NSData *data = [[NSData alloc]initWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];

    id obj = [unarchiver decodeObjectForKey:key];
    return obj;
}

// 验证手机号
+ (BOOL)isValidateMobile:(NSString *)mobile {
    
       //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(147)|(15[^4,\\D]|(14[0-9])|(17[0-9]))|(18[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];

}

// 验证邮箱号
+ (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 字符串是否包含汉字
+ (BOOL)existChinese:(NSString *)string {

    NSString *phoneRegex = @"^[\u4E00-\u9FA5]*$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:string];
}

// 火星坐标系转换
+ (CLLocationCoordinate2D)covertFromMarsCoordinate:(CLLocationCoordinate2D)coordinate {
    
    if (![self isLocationOutOfChina:coordinate]) {
        
        CLLocationCoordinate2D adjustLoc;
        
            double adjustLat = [self transformLatWithX:coordinate.longitude - 105.0 withY:coordinate.latitude - 35.0];
            double adjustLon = [self transformLonWithX:coordinate.longitude - 105.0 withY:coordinate.latitude - 35.0];
            double radLat = coordinate.latitude / 180.0 * pi;
            double magic = sin(radLat);
            magic = 1 - ee * magic * magic;
            double sqrtMagic = sqrt(magic);
            adjustLat = (adjustLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
            adjustLon = (adjustLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
            adjustLoc.latitude = coordinate.latitude + adjustLat;
            adjustLoc.longitude = coordinate.longitude + adjustLon;
        
            return adjustLoc;
    }
    else {
        return coordinate;
    }
}

//判断是不是在中国
+ (BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location{
    if (location.longitude < 72.004 || location.longitude > 137.8347 || location.latitude < 0.8293 || location.latitude > 55.8271)
        return YES;
    return NO;
}

// 火星坐标纬度转换
+(double)transformLatWithX:(double)x withY:(double)y{
    double lat = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    lat += (20.0 * sin(6.0 * x * pi) + 20.0 *sin(2.0 * x * pi)) * 2.0 / 3.0;
    lat += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    lat += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return lat;
}

// 火星坐标经度转换
+(double)transformLonWithX:(double)x withY:(double)y{
    double lon = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    lon += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    lon += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    lon += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return lon;
}

// 数字突出显示
+ (NSMutableAttributedString *)figureHighlightWithAttribute:(NSDictionary *)attribute String:(NSString *)string{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:string];
    //1.定义正则表达式
    NSString *regex = @"\\d";
    
    //2.创建正则表达式实现对象
    NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    
    //3. expression  查找符合正则表达式的字符串
    NSArray *items = [expression matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    //4.循环遍历查找出来的结果
    for (NSTextCheckingResult *result in items) {
        
        //符合表达的字符串的范围
        NSRange range = [result range];
        [attrString addAttributes:attribute range:range];
    }
   
    return attrString;
}

// iso88951转码
+ (NSString *)changeISO88591StringToUnicodeString:(NSString *)iso88591String {
    NSMutableString *srcString = [[NSMutableString alloc]initWithString:iso88591String];
    
    
    
    
    
    [srcString replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSLiteralSearch range:NSMakeRange(0, [srcString length])];
    
    
    
    [srcString replaceOccurrencesOfString:@"&#x" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [srcString length])];
    
    
    
    
    
    
    
    NSMutableString *desString = [[NSMutableString alloc]init] ;
    
    
    
    
    
    
    
    NSArray *arr = [srcString componentsSeparatedByString:@";"];
    
    
    
    
    
    
    
    for(int i=0;i<[arr count]-1;i++){
        
        
        
        
        
        
        
        NSString *v = [arr objectAtIndex:i];
        
        
        
        char *c = malloc(3);
        
        
        
        int value = [self changeHexStringToDec:v];
        
        
        
        c[1] = value  &0x00FF;
        
        
        
        c[0] = value >>8 &0x00FF;
        
        
        
        c[2] = '\0';
        
        
        
        [desString appendString:[NSString stringWithCString:c encoding:NSUnicodeStringEncoding]];
        
        
        
        free(c);
        
        
        
    }
    
    
    
    return desString;
}

// 逐个字符转码
+ (int) changeHexStringToDec:(NSString *)strHex{
    
    
    
    int hexLength = (int)[strHex length];
    
    
    
    int  ref = 0;
    
    
    
    for (int j = 0,i = hexLength -1; i >= 0 ;i-- )
        
        
        
    {
        
        
        
        char a = [strHex characterAtIndex:i];
        
        
        
        if (a == 'A') {
            
            
            
            ref += 10*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == 'B'){
            
            
            
            ref += 11*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == 'C'){
            
            
            
            ref += 12*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == 'D'){
            
            
            
            ref += 13*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == 'E'){
            
            
            
            ref += 14*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == 'F'){
            
            
            
            ref += 15*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == '0')
            
            
            
        {
            
            
            
            ref += 0;
            
            
            
        }
        
        
        
        else if(a == '1')
            
            
            
        {
            
            
            
            ref += 1*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == '2')
            
            
            
        {
            
            
            
            ref += 2*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == '3')
            
            
            
        {
            
            
            
            ref += 3*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == '4')
            
            
            
        {
            
            
            
            ref += 4*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == '5')
            
            
            
        {
            
            
            
            ref += 5*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == '6')
            
            
            
        {
            
            
            
            ref += 6*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == '7')
            
            
            
        {
            
            
            
            ref += 7*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == '8')
            
            
            
        {
            
            
            
            ref += 8*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == '9')
            
            
            
        {
            
            
            
            ref += 9*pow(16,j);
            
            
            
        }
        
        
        
        j++;
        
        
        
    }
    
    
    
    return ref;
    
    
    
}

// 时间戳转指定格式时间字符串
+ (NSString *)timeintervalToDate:(NSTimeInterval)time Formatter:(NSString *)format {
    
    if (format == nil) {
        
        format = @"YYYY-MM-dd HH:mm:ss";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format];
    
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

// 格式字符串转换成时间
+ (NSDate *)stringToDate:(NSString *)string Formatter:(NSString *)format{
    
    if (format == nil) {
        
        format = @"YYYY-MM-dd HH:mm:ss";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:format];
    NSDate *date=[formatter dateFromString:string];
    return date;
}

// 获取日期中详细信息
+ (NSDateComponents *)getDetailInfoWithDate:(NSDate *)date {
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitWeekday fromDate:date];
    return comps;
}

// 经纬度转换成地理位置
+ (void)locationToAddress:(CLLocation *)location completion:(void (^)(NSArray *, NSError *))block{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        block(placemarks,error);
    }];

}

// 地理位置转换成经纬度
+ (void)addressToLocation:(NSString *)address competion:(void (^)(NSArray *, NSError *))block {
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
       
        block(placemarks,error);
    }];
}

// 根据经纬度计算距离
+ (double)LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2 {
    
    CLLocation *orig = [[CLLocation alloc]initWithLatitude:lat1 longitude:lon1];
    CLLocation *dest = [[CLLocation alloc]initWithLatitude:lat2 longitude:lon2];
    CLLocationDistance distance = [orig distanceFromLocation:dest]/1000.f;
    return distance;
}

//16进制颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

// 将data通过base64转码
+ (NSString *)DataToBase64String:(NSData *)data {
    
    NSString *str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return str;
}

// 字符串转字典
+ (NSDictionary *)covertStringToDictionary:(NSString *)string {
    
    NSError *error;
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        
        return nil;
    }
    return dic;
}

// 获取MP3文件的封面图
+ (UIImage *)getImageFromMp3WithFilePath:(NSString *)filePath {
    
    UIImage *img = [[UIImage alloc]init];
    
    NSURL *fileUrl = [NSURL URLWithString:filePath];
    AVURLAsset *mp3Assent = [AVURLAsset URLAssetWithURL:fileUrl options:nil];
    NSString *format = [mp3Assent availableMetadataFormats][0];
    for (AVMetadataItem *metadataItem in [mp3Assent metadataForFormat:format]) {
        
        id item = metadataItem.value;
        if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
            
            img = [[UIImage alloc]initWithData:item];
        }
    }
    return img;
}
@end


