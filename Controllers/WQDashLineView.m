//
//  WQDashLineView.m
//  RenRenhua2.0
//
//  Created by peterwon on 2016/11/4.
//  Copyright © 2016年 chenchuanxi. All rights reserved.

#import "WQDashLineView.h"

@implementation WQDashLineView

- (id)initWithFrame:(CGRect)frame
{
    self= [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];//设置自定义view的背景色
    if(self) {
        _lineColor = [UIColor grayColor];
        _startPoint = CGPointMake(0, 1);
        _endPoint = CGPointMake(CCXSIZE_W, 1);
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    
    CGContextSetLineWidth(context,3);//线宽度
    
    CGContextSetStrokeColorWithColor(context,self.lineColor.CGColor);
    
    CGFloat lengths[] = {2,2};//先画4个点再画2个点
    
    CGContextSetLineDash(context,0, lengths,2);//注意2(count)的值等于lengths数组的长度
    
    CGContextMoveToPoint(context,self.startPoint.x,self.startPoint.y);
    
    CGContextAddLineToPoint(context,self.endPoint.x,self.endPoint.y);
    
    CGContextStrokePath(context);
    
    CGContextClosePath(context);
    
}
@end
