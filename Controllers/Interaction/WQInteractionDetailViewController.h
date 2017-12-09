//
//  WQInteractionDetailViewController.h
//  RenRenhua2.0
//
//  Created by peterwon on 2017/1/12.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "CCXRootWebViewController.h"

@class WQInteractionMessage;

@interface WQInteractionDetailViewController : CCXRootWebViewController

@property (nonatomic ,strong) WQInteractionMessage *model;

@property (nonatomic, copy) NSString *mesId;

@end
