//
//  CCXSlider.m
//  RenrenCost
//
//  Created by 陈传熙 on 16/9/1.
//  Copyright © 2016年 ChuanxiChen. All rights reserved.
//

#import "CCXSlider.h"

@implementation CCXSlider


-(instancetype)initWithMaxImageName:(NSString *)maxName minImageName:(NSString *)minName thumbImageName:(UIImage *)thumbImage{
    if (self = [super init]) {
//        [self setMinimumTrackTintColor:[UIColor colorWithHexString:@"ffc81c"]];
//        [self setMaximumTrackTintColor:[UIColor colorWithHexString:@"e1e2e4"]];
//        [self setBackgroundColor:[UIColor colorWithHexString:@"e1e2e4"]];
        [self setMaximumTrackImage:[UIImage imageNamed:maxName] forState:UIControlStateNormal];
        [self setMinimumTrackImage:[UIImage imageNamed:minName] forState:UIControlStateNormal];
        [self setThumbImage:thumbImage forState:UIControlStateNormal];
        [self setThumbImage:thumbImage forState:UIControlStateHighlighted];
    }
    return self;
}

//// 改变滑条的宽度
//- (CGRect)trackRectForBounds:(CGRect)bounds {
//    return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, 20);
//}

-(void)setLeftImage:(NSString *)leftImage{
    
}

-(void)setRightImage:(NSString *)rightImage{
    
}

@end
