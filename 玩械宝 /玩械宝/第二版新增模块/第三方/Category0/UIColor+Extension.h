//
//  UIColor+Extension.h
//  EnVonFramework
//
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

//把RGB颜色值转换为UIColor
+ (UIColor *) _colorWithRGB:(NSString *)hex;

//把RGB颜色值转换为UIColor
+ (UIColor *) _r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b;

////把RGB颜色值转换为CGColorRef
//+(CGColorRef) colorWithRgbToCGColorRef:(NSString *)hex;

//随机颜色
+(UIColor*) colorRandom:(CGFloat) alpha;

//取rgb颜色值
-(BOOL)getRGBValue:(CGFloat *)R G:(CGFloat *)G B:(CGFloat *)B;


@end
