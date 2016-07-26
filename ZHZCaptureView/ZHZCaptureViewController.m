//
//  ZHZCaptureViewController.m
//  iyouliaNew
//
//  Created by David on 16/4/26.
//  Copyright © 2016年 曾维崧. All rights reserved.
//

#import "ZHZCaptureViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRView.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface ZHZCaptureViewController ()<AVCaptureMetadataOutputObjectsDelegate>{
    QRView *scanView;
}
@property (nonatomic, copy) NSString *stringValue;

@property (strong, nonatomic)AVCaptureDevice *device;
@property (strong, nonatomic)AVCaptureDeviceInput *input;
@property (strong, nonatomic)AVCaptureMetadataOutput *output;
@property (strong, nonatomic)AVCaptureSession *session;
@property (strong, nonatomic)AVCaptureVideoPreviewLayer *preView;

@end

@implementation ZHZCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    self.view.backgroundColor = [UIColor whiteColor];
    scanView = [[QRView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scanView.backgroundColor = [UIColor clearColor];
    scanView.transparentArea = CGSizeMake(kScreenW - 20, kScreenW - 80);
    [self.view addSubview:scanView];
    [scanView startMove];
    if (TARGET_OS_SIMULATOR) {
//        self.stringValue =@"http://www.ebwing.com/wap/download/index.do?mobile=14759163407";//5578
        self.stringValue =@"请在真机中运行！";//1004
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.myBlock) {
                self.myBlock(self.stringValue);
            }
        }];
    }else{
        [self setUpAboutCapture];
        if (![self.device hasTorch]) {
            NSLog(@"没有闪光灯功能");
        }else {
            [self setUpWidget];
        }
        [self.session startRunning];
        [self checkAVAuthorizationStatus];
    }
}

- (void)setRectOfScan {
    
    CGRect cropRect = CGRectMake((kScreenW - scanView.transparentArea.width) / 2,
                                 (kScreenH - scanView.transparentArea.height) / 2,
                                 scanView.transparentArea.width,
                                 scanView.transparentArea.height);
    [_output setRectOfInterest:CGRectMake(cropRect.origin.y / kScreenH,
                                          cropRect.origin.x / kScreenW,
                                          cropRect.size.height / kScreenH,
                                          cropRect.size.width / kScreenW)];
}

-(void)leftAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)setUpWidget {
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"闪光灯" style:UIBarButtonItemStylePlain target:self action:@selector(flashlight)];
}

- (void)flashlight {
    if (self.device.torchMode == AVCaptureTorchModeOn) {
        [self.device lockForConfiguration:nil];
        [self.device setTorchMode:AVCaptureTorchModeOff];
        [self.device unlockForConfiguration];
        
    }else if (self.device.torchMode == AVCaptureTorchModeOff){
        [self.device lockForConfiguration:nil];
        [self.device setTorchMode:AVCaptureTorchModeOn];
        [self.device unlockForConfiguration];
    }
}

- (void)checkAVAuthorizationStatus {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    NSLog(@"%ld", (long)status);
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
            //do somethings
            NSLog(@"用户尚未做出了选择这个应用程序的问候");
            break;
        case AVAuthorizationStatusRestricted:
            //do somethings
            NSLog(@"此应用程序没有被授权访问的照片数据。可能是家长控制权限");
            break;
        case AVAuthorizationStatusDenied:
            //do somethings
            NSLog(@"用户已经明确否认了这一照片数据的应用程序访问");
            break;
        case AVAuthorizationStatusAuthorized:
            //do somethings
            NSLog(@"用户已授权应用访问照片数据");
            break;
        default:
            break;
    }
    
        if(status == AVAuthorizationStatusAuthorized) {
    
        } else {
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请开启相机权限!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
}

- (void)setUpAboutCapture {
    /*
     AVMediaTypeVideo,
     AVMediaTypeAudio,
     AVMediaTypeMuxed
     */
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self setRectOfScan];
    
    
    self.session = [[AVCaptureSession alloc] init];
    /**
     *  AVCaptureSessionPresetPhoto
     *  AVCaptureSessionPresetHigh
     *  AVCaptureSessionPresetMedium
     *  AVCaptureSessionPresetLow
     *  AVCaptureSessionPreset352x288
     *  AVCaptureSessionPreset640x480
     *  AVCaptureSessionPreset960x540
     *  AVCaptureSessionPreset1280x720
     *  AVCaptureSessionPreset1920x1080
     *  AVCaptureSessionPreset3840x2160
     *  AVCaptureSessionPresetiFrame960x540
     *  AVCaptureSessionPresetiFrame1280x720
     *  AVCaptureSessionPresetInputPriority
     */
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }else {
        NSLog(@"输入失败");
    }
    
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }else {
        NSLog(@"输出失败");
    }
    
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code];
    
    self.preView = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.preView.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preView.frame = [UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:self.preView atIndex:0];
    
    
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if ([metadataObjects count] > 0) {
        [self.session stopRunning];
        [scanView stopMove];
        
        AVMetadataMachineReadableCodeObject *metadataObjet = metadataObjects[0];
        self.stringValue = metadataObjet.stringValue;
        [self dismissViewControllerAnimated:YES completion:^{
            self.myBlock(self.stringValue);
        }];
    }
    
}

//传递参数
- (void)showBlock:(MyBlock)block {
    self.myBlock = block;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
