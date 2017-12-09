//
//  ProgressView.m
//  XianJinDaiSystem
//
//  Created by yanqb on 2017/10/26.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"ProgressView" owner:nil options:nil].lastObject;
    }
    return self;
}
@end
