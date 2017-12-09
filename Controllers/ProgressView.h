//
//  ProgressView.h
//  XianJinDaiSystem
//
//  Created by yanqb on 2017/10/26.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
- (instancetype)initWithFrame:(CGRect)frame;
@end
