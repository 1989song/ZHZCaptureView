//
//  ZHZCaptureViewController.h
//  iyouliaNew
//
//  Created by David on 16/4/26.
//  Copyright © 2016年 曾维崧. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBlock)(NSString *);

@interface ZHZCaptureViewController : UIViewController

@property (nonatomic, copy) MyBlock myBlock;
- (void)showBlock:(MyBlock)block;

@end
