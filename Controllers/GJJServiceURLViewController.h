//
//  GJJServiceURLViewController.h
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/11/10.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCXSuperViewController.h"

@protocol GJJServiceURLViewControllerDelegate <NSObject>

- (void)doNotForceUpdate;

@end

@interface GJJServiceURLViewController : CCXSuperViewController

@property (nonatomic, weak) id <GJJServiceURLViewControllerDelegate> delegate;

@end
