//
//  ViewController.m
//  cameraTest
//
//  Created by gouzi on 2016/11/28.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "wjCaptureSelfVideoController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>


#define iOS(version) ([UIDevice currentDevice].systemVersion.doubleValue >= (version))


@interface wjCaptureSelfVideoController ()<AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

/* 视频图层*/
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *CaptureVideoPreviewLayer;
/* 获取回话*/
@property (nonatomic, strong) AVCaptureSession *CaptureSession;


@end

@implementation wjCaptureSelfVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self AVCaptureCameraInit];
}

#pragma mark - AVPlayer
- (void)AVCaptureCameraInit {
    // 创建会话控制对象
    self.CaptureSession = [[AVCaptureSession alloc] init];
    // 设置设备的相机属性,获取视频流
     AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (iOS(10.0)) {
        inputDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
    }
    
    // 添加输入设备到当前会话
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    [self.CaptureSession addInput:deviceInput];
    
    // 设置播放页面
    if (!self.CaptureVideoPreviewLayer) {
        self.CaptureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.CaptureSession];
    }
    // 设置扫描页面大小
    self.CaptureVideoPreviewLayer.frame = self.view.bounds;
    // 适应播放窗口
    self.CaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    // 把layer加上来
    [self.view.layer addSublayer:self.CaptureVideoPreviewLayer];
    // 开始扫描
    [self.CaptureSession startRunning];
    

}


- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position )
            return device;
    return nil;
}


- (BOOL)shouldAutorotate {
    return NO;
}






@end
