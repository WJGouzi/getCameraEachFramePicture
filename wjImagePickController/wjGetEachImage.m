//
//  wjGetEachImage.m
//  wjImagePickController
//
//  Created by gouzi on 2017/3/30.
//  Copyright © 2017年 gouzi. All rights reserved.
//  获取本地的摄像头的视频流，取得每一帧的图片

#import "wjGetEachImage.h"
#import <AVFoundation/AVFoundation.h>

@interface wjGetEachImage () <AVCaptureVideoDataOutputSampleBufferDelegate> {
    
    AVCaptureSession *_session;
    
    NSMutableArray *_imageArr;
    
    UIScrollView *_scrollView;
}

@end

@implementation wjGetEachImage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self playerSessionSettings];
    [self UISettings];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_session stopRunning];
    _imageArr = nil;
}


/** session的设置*/
- (void)playerSessionSettings {
    _session = [[AVCaptureSession alloc] init];
    _session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    AVCaptureVideoPreviewLayer *layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    layer.frame = [UIScreen mainScreen].bounds;
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:layer];
    
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //    device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    //    [device unlockForConfiguration];
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
    AVCaptureStillImageOutput *output = [[AVCaptureStillImageOutput alloc] init];
    dispatch_queue_t captureQueue = dispatch_queue_create("com.wangjun.captureQueue", NULL);
    AVCaptureVideoDataOutput *output2 = [[AVCaptureVideoDataOutput alloc] init];
    output2.videoSettings = @{(NSString*)kCVPixelBufferPixelFormatTypeKey: [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]};
    output2.alwaysDiscardsLateVideoFrames = YES;
    [output2 setSampleBufferDelegate:self queue:captureQueue];
    
    if ([_session canAddInput:input]){
        [_session addInput:input];
    }
    
    if ([_session canAddOutput:output]) {
        [_session addOutput:output];
        [_session addOutput:output2];
    }
}


/** 界面的设置*/
- (void)UISettings {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"开启" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.bounds = CGRectMake(0, 0, 100, 40);
    button.center = self.view.center;
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"关闭" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(onClick01) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    button2.bounds = CGRectMake(0, 0, 100, 40);
    button2.center = CGPointMake(self.view.center.x, self.view.center.y+100);
    
    _imageArr = [[NSMutableArray alloc] init];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2-30)];
    _scrollView.backgroundColor = [UIColor redColor];
    _scrollView.alwaysBounceHorizontal = YES;
    _scrollView.contentSize = CGSizeZero;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
}




- (void)onClick{
    [_session startRunning];
}

- (void)onClick01{
    [_session stopRunning];
    for (int i = 0 ; i<_imageArr.count; i++) {
        UIImage *image = _imageArr[i];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width,_scrollView.frame.size.height);
        [_scrollView addSubview:imageView];
        _scrollView.contentSize = CGSizeMake(image.size.width*i, 0);
    }
}




#pragma mark - delegate
/** 拿到图片*/
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    CGRect rect = CGRectMake(0, 0, CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer));
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:ciImage fromRect:rect];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:1.0f orientation:UIImageOrientationRight];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
  //    image = [image rotateInDegrees:90.0f];
        // 添加之前就移除之前的图片，避免了内存的消耗
        [_imageArr removeAllObjects];
        // 添加到数组中是个耗内存的操作
        [_imageArr addObject:image];
    });
    CGImageRelease(imageRef);
}





@end
