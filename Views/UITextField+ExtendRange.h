//
//  UITextField+ExtendRange.h
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2017/1/5.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ExtendRange)

- (NSRange)selectedRange;

- (void)setSelectedRange:(NSRange)range;

@end
