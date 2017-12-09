//
//  WQRedrawLabel.m
//  MQVerCodeView
//
//  Created by peterwon on 2016/12/27.
//  Copyright © 2016年 林美齐. All rights reserved.
//

#import "WQRedrawLabel.h"
#define WQColor CCXColorWithHex(@"#5c8cd3")//验证码颜色

@implementation WQRedrawLabel

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.5);
    CGContextSetLineWidth(context, kCGLineJoinRound);
    CGContextSetTextDrawingMode(context, kCGTextStroke);
    self.textColor = [UIColor blackColor];
    //蓝色空心字
    [super drawRect:rect];
    CGContextSetTextDrawingMode(context, kCGTextFill);
    self.textColor = [UIColor blackColor];
    //白色实心字
    [super drawRect:rect];
}


@end



















