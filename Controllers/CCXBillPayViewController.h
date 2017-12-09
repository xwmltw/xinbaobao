//
//  CCXBillPayViewController.h
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/11/4.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXNeedBackViewController.h"
#import <WebKit/WebKit.h>

@interface CCXBillPayViewController : CCXNeedBackViewController
@property(nonatomic,copy)NSString *billId;
@property(nonatomic,copy)NSString *status;

@end
