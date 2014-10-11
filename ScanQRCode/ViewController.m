//
//  ViewController.m
//  ScanQRCode
//
//  Created by cen on 11/10/14.
//  Copyright (c) 2014 cen. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property(strong,nonatomic) AVCaptureSession *session;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self readQRCode];
}

-(void)readQRCode{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (error) {
        NSLog(@"no camera-%@", error.localizedDescription);
        return;
    }
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    [session addInput:input];
    [session addOutput:output];
    
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [preview setFrame:self.view.frame];
    [self.view.layer insertSublayer:preview atIndex:0];
    
    [session startRunning];
    self.session = session;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // 1. stop scanning
    [self.session stopRunning];
    // 2. remove preview
//    [self.previewLayerremoveFromSuperlayer];
    
    NSLog(@"%@", metadataObjects);
    // 3. result
    
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        NSLog(@"%@",obj.stringValue);
    }
}

@end
