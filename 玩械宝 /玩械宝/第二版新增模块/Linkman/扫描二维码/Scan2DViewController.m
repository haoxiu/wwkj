//
//  Scan2DViewController.m
//  玩械宝
//
//  Created by wawa on 16/5/12.
//  Copyright © 2016年 zgcainiao. All rights reserved.
//

#import "Scan2DViewController.h"
#import "seachViewController.h"

@interface Scan2DViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *session;//输入输出中的中间桥梁
    NSString *url;
    UIImagePickerController * _picker;
}

@end

@implementation Scan2DViewController
//隐藏tableBar
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}
- (void)viewDidLoad
{
   self.title=@"扫描二维码／条码";
    
    UIBarButtonItem *photoButon=[[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(ThephotoAlbum)];
    [photoButon setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem=photoButon;
    [super viewDidLoad];
    [self setupDevice];
}
//调用本地相册
-(void)ThephotoAlbum
{
    _picker=[[UIImagePickerController alloc]init];
    _picker.allowsEditing = YES;
    _picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:_picker animated:YES completion:nil];

}

- (void)setupDevice
{
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [session addInput:input];
    [session addOutput:output];
    //设置扫码支持的编码格式（如下设置条形码和二维码兼容
    [output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, nil]];
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    //添加扫描框
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = self.view.frame.size.height;
    
    UIView *boxView = [[UIView alloc]initWithFrame:CGRectMake(viewWidth/2 - 100, viewHeight/2 - 100, 200, 200)];
    boxView.backgroundColor = [UIColor clearColor];
    boxView.layer.borderColor = [UIColor greenColor].CGColor;
    boxView.layer.borderWidth = 1.0f;
    [self.view addSubview:boxView];
    
    //设置扫描区域
    CGFloat x = boxView.frame.origin.y/viewHeight;
    CGFloat y = boxView.frame.origin.x/viewWidth;
    CGFloat width = 200/viewHeight;
    CGFloat height = 200/viewWidth;
    [output setRectOfInterest:CGRectMake(x, y, width, height)];
    
    UILabel*label=[[UILabel alloc]initWithFrame:[FlexBile frameIPONE5Frame:CGRectMake(55,568/2-240+200+150, 320-80,30)]];
    label.text=@"将二维码放入框中，即可自动扫描";
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=[UIColor lightGrayColor];
    [self.view addSubview:label];

    
}

//扫描代理方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        [session stopRunning];
        AVMetadataMachineReadableCodeObject *metadataobject = [metadataObjects objectAtIndex:0];
         url = [NSString stringWithFormat:@"%@", metadataobject.stringValue];
         NSLog(@"%@", metadataobject.stringValue);
        [self playVideo];
    }
}
- (void)playVideo
{
    if (url) {
        NSURL *movieUrl = [NSURL URLWithString:url];
        //直接跳转🔍界面
        seachViewController*vc=[[seachViewController alloc]init];
        vc.url = movieUrl;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (session) {
        [session startRunning];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
