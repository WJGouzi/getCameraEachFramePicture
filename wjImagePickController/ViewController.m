//
//  ViewController.m
//  wjImagePickController
//
//  Created by gouzi on 2017/3/30.
//  Copyright © 2017年 gouzi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *imageView;

/** imagePick */
@property (nonatomic, strong) UIImagePickerController *imagePickVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cameraSettings];
}


- (void)cameraSettings {
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imagePickVC = [[UIImagePickerController alloc] init];
    self.imagePickVC.allowsEditing = YES; // 拍摄完毕后的画面的编辑状态
    UILabel *label = [[UILabel alloc] init];
    label.text = @"test";
    label.frame = CGRectMake(self.view.center.x - 35, self.view.center.y, 70, 20);
    [self cameraCoverOnTheImagePickView];
    [self.imagePickVC.view addSubview:label];
    self.imagePickVC.delegate = self;
}

- (void)cameraCoverOnTheImagePickView {
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.alpha = 0.8;
    toolBar.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 165);
    [self.imagePickVC.view addSubview:toolBar];
    
    
    
    UIView *coverView = [[UIView alloc] init];
//    coverView.center = self.imagePickVC.view.center;
//    coverView.bounds = CGRectMake(0, 0, 350, 200);
//    coverView.layer.borderColor = [UIColor redColor].CGColor;
//    coverView.frame = self.imagePickVC.view.frame;
    coverView.backgroundColor = [UIColor redColor];
    [self.imagePickVC.view addSubview:coverView];
}



- (IBAction)takePhotoPicture:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePickVC.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        [self presentViewController:self.imagePickVC animated:YES completion:nil];
        
    } else {
        NSLog(@"没有硬件的支持");
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
//    NSLog(@"editing info is %@", info);
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
        self.imageView.image = info[UIImagePickerControllerEditedImage];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
