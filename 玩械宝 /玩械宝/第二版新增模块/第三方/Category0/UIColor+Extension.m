//
//  UIColor+Extension.m
//  EnVonFramework
//
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

//  将RGB值直接转换为颜色
+(UIColor *) _colorWithRGB:(NSString *)hex
{
    // Remove `#` and `0x`
	if ([hex hasPrefix:@"#"]) {
		hex = [hex substringFromIndex:1];
	} else if ([hex hasPrefix:@"0x"]) {
		hex = [hex substringFromIndex:2];
	}
	// Invalid if not 3, 6, or 8 characters
	NSUInteger length = [hex length];
	if (length != 3 && length != 6 && length != 8) {
		return nil;
	}
	// Make the string 8 characters long for easier parsing
	if (length == 3) {
		NSString *r = [hex substringWithRange:NSMakeRange(0, 1)];
		NSString *g = [hex substringWithRange:NSMakeRange(1, 1)];
		NSString *b = [hex substringWithRange:NSMakeRange(2, 1)];
		hex = [NSString stringWithFormat:@"%@%@%@%@%@%@ff",
			   r, r, g, g, b, b];
	} else if (length == 6) {
		hex = [hex stringByAppendingString:@"ff"];
	}
    //分别取RGB的值
    NSRange range;
    range.length = 2;
    range.location = 0;
    NSString *rString = [hex substringWithRange:range];
    range.location = 2;
    NSString *gString = [hex substringWithRange:range];
    range.location = 4;
    NSString *bString = [hex substringWithRange:range];
    range.location = 6;
    NSString *aString = [hex substringWithRange:range];
    unsigned int r, g, b, a;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    [[NSScanner scannerWithString:aString] scanHexInt:&a];
    //转换为UIColor
    float red = (float) r / 255.0f;
    float green = (float) g / 255.0f;
    float blue = (float) b / 255.0f;
    float alpha = (float) a / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *) _r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b
{
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0];
}

//+(CGColorRef)colorWithRgbToCGColorRef:(NSString *)hex
//{
//    return [[self _colorWithRGB:hex] CGColor];
//}

+(UIColor *)colorRandom:(CGFloat)alpha
{
    static BOOL seeded = NO;
    if (!seeded) {
        seeded = YES;
        srandom((unsigned)time(NULL));
    }
    CGFloat red =  (CGFloat) random()/ (CGFloat) RAND_MAX;
    CGFloat green =  (CGFloat) random()/ (CGFloat) RAND_MAX;
    CGFloat blue =  (CGFloat) random()/ (CGFloat) RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

-(BOOL)getRGBValue:(CGFloat *)R G:(CGFloat *)G B:(CGFloat *)B
{
    //CGFloat A;
    CGColorRef color = [self CGColor];
    int numComponents = (unsigned)CGColorGetNumberOfComponents(color);
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(color);
        *R = components[0];
        *G = components[1];
        *B = components[2];
        //A = components[3];
        return YES;
    }
    return NO;
}



@end
