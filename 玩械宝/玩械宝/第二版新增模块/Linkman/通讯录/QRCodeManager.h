//
//  QRCodeManager.h
//  挖挖
//
//  Created by wawa on 16/5/11.
//  Copyright © 2016年 Wawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^AnalyticQRCodeBlock)(NSString * str);

@interface QRCodeManager : NSObject<AVCaptureMetadataOutputObjectsDelegate>

@property ( strong , nonatomic ) AVCaptureSession * session;

@property(nonatomic) CGRect rectOfInterest;

@property (nonatomic, copy)AnalyticQRCodeBlock analyticQRCodeBlock;

+ (instancetype)sharedManager;

-(void)analyticQRCodeInView:(UIView *)view withCompleteBlock:(AnalyticQRCodeBlock)block;

+(UIImage *)createQRCodeWithString:(NSString *)string;

@end
