//
//  XWMRegisterViewController.h
//  XianJinDaiSystem
//
//  Created by yanqb on 2017/10/23.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "CCXSuperViewController.h"
#import "CCXNeedBackViewController.h"

@interface XWMRegisterViewController : CCXNeedBackViewController
@property (nonatomic, strong) UIViewController *popViewController;
@property (nonatomic,copy) NSString *phontString;
@property (nonatomic,assign) BOOL needCountDown;

@end
