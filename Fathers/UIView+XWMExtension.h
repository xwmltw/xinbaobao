//
//  UIView+XWMExtension.h
//  XianJinDaiSystem
//
//  Created by yanqb on 2017/10/25.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XWMExtension)


- (void)setCornerValue:(CGFloat)value;
- (void)setCorner;
- (void)setToCircle;
- (void)setCornerWithCorners:(UIRectCorner)corners cornerRadii:(CGSize)size;

- (void)setBorderWidth:(CGFloat)width andColor:(UIColor*)color;
- (void)setBorderColor:(UIColor*)color;

- (void)removeAllSubviews;
@end
