//
//  UIView+XWMExtension.m
//  XianJinDaiSystem
//
//  Created by yanqb on 2017/10/25.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "UIView+XWMExtension.h"

@implementation UIView (XWMExtension)

#pragma mark - ***** 圆角 ******
- (void)setCornerValue:(CGFloat)value{
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:value];
}

- (void)setCorner{
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:2.0];
}

- (void)setToCircle{
//    [self setCornerWithCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake((self.width)/2, 0)];
}

- (void)setCornerWithCorners:(UIRectCorner)corners cornerRadii:(CGSize)size{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    self.layer.cornerRadius = size.width;
    self.layer.masksToBounds = YES;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

#pragma mark - ***** 边框 ******
- (void)setBorderWidth:(CGFloat)width andColor:(UIColor*)color{
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

- (void)setBorderColor:(UIColor*)color{
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 0.7;
    self.layer.borderColor = color.CGColor;
}

- (void)removeAllSubviews{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
@end
