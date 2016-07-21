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
    UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"扫一扫" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sysAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)sysAction{
    ZHZCaptureViewController * reader=[[ZHZCaptureViewController alloc]init];
    UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:reader];
    [self presentViewController:nav animated:YES completion:nil];
    reader.myBlock=^(NSString * str){
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAlert=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAlert];
        [self presentViewController:alert animated:YES completion:nil];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
