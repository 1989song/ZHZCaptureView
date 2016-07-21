//
//  QRView.m
//  iyouliaNew
//
//  Created by David on 16/4/26.
//  Copyright © 2016年 曾维崧. All rights reserved.
//

#import "QRView.h"

#define kQrLineanimateDuration 0.01
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface QRView (){
    NSTimer *timer;
}

@property (nonatomic, assign) NSInteger qrLineY;
@property (nonatomic, strong) UIImageView *qrLine;

@end

@implementation QRView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)initQRLine {
    self.qrLine  = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW / 2 - self.transparentArea.width / 2, kScreenH / 2 - self.transparentArea.height / 2, self.transparentArea.width, 2)];
    self.qrLine.image = [UIImage imageNamed:@"qr_scan_line"];
    self.qrLine.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.qrLine];
    self.qrLineY = self.qrLine.frame.origin.y;
    
    self.qrLine.backgroundColor = [UIColor redColor];
    CGFloat labelX = 20;
    CGFloat labelY = self.transparentArea.height / 2 + kScreenH / 2 + 20;
    UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, kScreenW - 20*2, 30)];
    showLabel.text = @"请将条形码 或 二维码放到扫描框中";
    showLabel.textColor = [UIColor blueColor];
    showLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:showLabel];
}
- (void)show {
    
    [UIView animateWithDuration:kQrLineanimateDuration animations:^{
        
        CGRect rect = self.qrLine.frame;
        rect.origin.y = self.qrLineY;
        self.qrLine.frame = rect;
        
    } completion:^(BOOL finished) {
        CGFloat maxBorder = kScreenH / 2 + self.transparentArea.height / 2 - 4;
        if (self.qrLineY > maxBorder) {
            self.qrLineY = kScreenH / 2 - self.transparentArea.height /2;
        }
        self.qrLineY++;
    }];
}

- (void)drawRect:(CGRect)rect {
    CGSize screenSize =self.bounds.size;
    CGRect screenDrawRect =CGRectMake(0, 0, screenSize.width, screenSize.height);
    CGRect clearDrawRect = CGRectMake(screenDrawRect.size.width / 2 - self.transparentArea.width / 2,
                                      screenDrawRect.size.height / 2 - self.transparentArea.height / 2,
                                      self.transparentArea.width,self.transparentArea.height);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self addScreenFillRect:ctx rect:screenDrawRect];
    [self addCenterClearRect:ctx rect:clearDrawRect];
    
    [self addWhiteRect:ctx rect:clearDrawRect];
    
    [self addCornerLineWithContext:ctx rect:clearDrawRect];
}

- (void)addScreenFillRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextSetRGBFillColor(ctx, 40 / 255.0,40 / 255.0,40 / 255.0,0.5);
    CGContextFillRect(ctx, rect);   //draw the transparent layer
}

- (void)addCenterClearRect :(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextClearRect(ctx, rect);  //clear the center rect  of the layer
}

- (void)addWhiteRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextStrokeRect(ctx, rect);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, 0.8);
    CGContextAddRect(ctx, rect);
    CGContextStrokePath(ctx);
}

- (void)addCornerLineWithContext:(CGContextRef)ctx rect:(CGRect)rect{
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBStrokeColor(ctx, 83 /255.0, 239/255.0, 111/255.0, 1);
    
    CGPoint poinsTopLeftA[] = {
        CGPointMake(rect.origin.x+0.7, rect.origin.y),
        CGPointMake(rect.origin.x+0.7 , rect.origin.y + 15)
    };
    
    CGPoint poinsTopLeftB[] = {CGPointMake(rect.origin.x, rect.origin.y +0.7),CGPointMake(rect.origin.x + 15, rect.origin.y+0.7)};
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:ctx];
    
    CGPoint poinsBottomLeftA[] = {CGPointMake(rect.origin.x+ 0.7, rect.origin.y + rect.size.height - 15),CGPointMake(rect.origin.x +0.7,rect.origin.y + rect.size.height)};
    CGPoint poinsBottomLeftB[] = {CGPointMake(rect.origin.x , rect.origin.y + rect.size.height - 0.7) ,CGPointMake(rect.origin.x+0.7 +15, rect.origin.y + rect.size.height - 0.7)};
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:ctx];
    
    CGPoint poinsTopRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - 15, rect.origin.y+0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y +0.7 )};
    CGPoint poinsTopRightB[] = {CGPointMake(rect.origin.x+ rect.size.width-0.7, rect.origin.y),CGPointMake(rect.origin.x + rect.size.width-0.7,rect.origin.y + 15 +0.7 )};
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:ctx];
    
    CGPoint poinsBottomRightA[] = {CGPointMake(rect.origin.x+ rect.size.width -0.7 , rect.origin.y+rect.size.height+ -15),CGPointMake(rect.origin.x-0.7 + rect.size.width,rect.origin.y +rect.size.height )};
    CGPoint poinsBottomRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - 15 , rect.origin.y + rect.size.height-0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y + rect.size.height - 0.7 )};
    [self addLine:poinsBottomRightA pointB:poinsBottomRightB ctx:ctx];
    CGContextStrokePath(ctx);
}

- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)ctx {
    CGContextAddLines(ctx, pointA, 2);
    CGContextAddLines(ctx, pointB, 2);
}

#pragma mark -moveLine
- (void)startMove {
    if (!self.qrLine) {
        [self initQRLine];
    }
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:kQrLineanimateDuration target:self selector:@selector(show) userInfo:nil repeats:YES];
    }
}

- (void)stopMove {
    if (timer) {
        [timer invalidate];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
