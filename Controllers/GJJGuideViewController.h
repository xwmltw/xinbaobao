//
//  GJJGuideViewController.h
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/11/9.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GJJGuideViewController;

@protocol GJJGuideViewControllerDelegate <NSObject>

@optional
-(void)guideDidFinished:(GJJGuideViewController *)guideView;

@end

@interface GJJGuideViewController : UIViewController

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, weak) id <GJJGuideViewControllerDelegate> delegate;

@end
