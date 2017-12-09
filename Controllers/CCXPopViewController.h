//
//  CCXPopViewController.h
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/11/5.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCXPopViewController;

@protocol CCXPopViewControllerDelegate <NSObject>

- (void)popViewController:(CCXPopViewController*)con didSelectAtIndex:(int)index;

@end

@interface CCXPopViewController : UIViewController

@property (nonatomic,weak)id<CCXPopViewControllerDelegate>delegate;

@property (nonatomic,strong)NSArray *listsArr;

/**
 *soureceV和item二者选一
 */
- (instancetype)initWithPopView:(UIView*)soureceV orBaritem:(UIBarButtonItem*)item;

@end
