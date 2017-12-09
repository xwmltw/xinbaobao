//
//  WQDashLineView.h
//  RenRenhua2.0
//
//  Created by peterwon on 2016/11/4.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCXSuperViewController.h"

@interface WQDashLineView : UIView

/**虚线起点*/
@property (nonatomic,assign)CGPoint startPoint;
/**虚线终点*/
@property (nonatomic,assign)CGPoint endPoint;
/**虚线颜色*/
@property (nonatomic,strong)UIColor *lineColor;


- (id)initWithFrame:(CGRect)frame;
- (void)drawRect:(CGRect)rect;

@end


















