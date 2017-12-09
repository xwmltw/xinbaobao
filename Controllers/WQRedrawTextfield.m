//
//  WQRedrawTextfield.m
//  RenRenhua2.0
//
//  Created by peterwon on 2016/11/4.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "WQRedrawTextfield.h"

@implementation WQRedrawTextfield

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += _leftOffset; //向右边偏10
    return iconRect;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    CGRect rightRect = [super rightViewRectForBounds:bounds];
    rightRect.origin.x -= _rightOffset; //左边偏10
    return rightRect;
}

//UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds{
    if (self.leftView) {
        return CGRectInset(bounds, 45, 0);
    }
    return CGRectInset(bounds, 15, 0);
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds{
    
    if (self.leftView) {
        return CGRectInset(bounds, 45, 0);
    }
    return CGRectInset(bounds, 15, 0);
}



@end
