//
//  QRView.h
//  iyouliaNew
//
//  Created by David on 16/4/26.
//  Copyright © 2016年 曾维崧. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRView : UIView
/**
*  透明的区域 size
*/
@property (nonatomic, assign) CGSize transparentArea;

//开始 移动
- (void)startMove;

//停止 移动
- (void)stopMove;
@end
