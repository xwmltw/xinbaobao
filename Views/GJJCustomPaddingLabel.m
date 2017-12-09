//
//  GJJCustomPaddingLabel.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2017/5/31.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "GJJCustomPaddingLabel.h"

@implementation GJJCustomPaddingLabel

- (void)setInsetsPadding:(UIEdgeInsets)insetsPadding
{
    _insetsPadding = insetsPadding;
    [self setNeedsDisplay];
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _insetsPadding)];
}

@end
