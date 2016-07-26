//
//  ViewController.m
//  ZHZCaptureViewDemo
//
//  Created by David on 16/7/19.
//  Copyright © 2016年 曾维崧. All rights reserved.
//

#import "ViewController.h"
#import <ZHZCaptureView/ZHZCaptureViewController.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)senderSysAction:(id)sender {
    ZHZCaptureViewController * reader=[[ZHZCaptureViewController alloc]init];
    UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:reader];
    [self presentViewController:nav animated:YES completion:nil];
    reader.myBlock=^(NSString * str){
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAlert=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAlert];
        [self presentViewController:alert animated:YES completion:nil];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
