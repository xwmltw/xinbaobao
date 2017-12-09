//
//  GJJPaddingLabel.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/11/2.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJPaddingLabel.h"

@implementation GJJPaddingLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 15, 0, 0};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
