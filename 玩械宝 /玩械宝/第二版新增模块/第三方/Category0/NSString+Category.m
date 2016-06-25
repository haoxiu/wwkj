//
//  NSString+Category.m
//  AFN
//
//  Created by toocmstoocms on 15/5/15.
//  Copyright (c) 2015年 toocmstoocms. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


//车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    
    return [carTest evaluateWithObject:carNo];
}


//车型
+ (BOOL) validateCarType:(NSString *)CarType
{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:CarType];
}


//用户名
+ (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}


//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}


//昵称
+ (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}


//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

+ (BOOL)checkString:(NSString *)str checkType:(NSString *)typeStr {
    
    if ([typeStr isEqualToString:@"email"]) {
        
        BOOL isRight = [NSString validateEmail:str];
        
        if (!isRight) {
            
            return NO;
        }
        
    }
    
    if ([typeStr isEqualToString:@"mobile"]) {
        
        BOOL isRight = [NSString validateMobile:str];
        
        if (!isRight) {
            
            return NO;
        }
        
    }
    
    if ([typeStr isEqualToString:@"carNo"]) {
        
        BOOL isRight = [NSString validateCarNo:str];
        
        if (!isRight) {
            
            return NO;
        }
        
    }
    
    if ([typeStr isEqualToString:@"CarType"]) {
        
        BOOL isRight = [NSString validateCarType:str];
        
        if (!isRight) {
            
            return NO;
        }
        
    }
    
    if ([typeStr isEqualToString:@"userName"]) {
        
        BOOL isRight = [NSString validateUserName:str];
        
        if (!isRight) {
            
            return NO;
        }
        
    }
    
    if ([typeStr isEqualToString:@"password"]) {
        
        BOOL isRight = [NSString validatePassword:str];
        
        if (!isRight) {
            
            return NO;
        }
        
    }
    
    if ([typeStr isEqualToString:@"nickname"]) {
        
        BOOL isRight = [NSString validateNickname:str];
        
        if (!isRight) {
            
            return NO;
        }
        
    }
    
    if ([typeStr isEqualToString:@"identityCard"]) {
        
        BOOL isRight = [NSString validateIdentityCard:str];
        
        if (!isRight) {
            
            return NO;
        }
        
    }
    
    
    return YES;
}

//获取字符串高度
+ (CGSize)getStringRect:(NSString*)aString fontSize:(CGFloat)fontSize width:(int)stringWidth
{
    
    CGSize size;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSDictionary* dic = @{NSFontAttributeName:font};
    size = [aString boundingRectWithSize:CGSizeMake(stringWidth, 2000)  options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return  size;
    
}

//设置UIlabel行间距
+ (void)setLabellineSpacing:(UILabel *)label aString:(NSString *)content setLineSpacing:(CGFloat)LineSpacing {
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:15];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    
    [label setAttributedText:attributedString];
    
    [label sizeToFit];
}


@end
