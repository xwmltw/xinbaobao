//
//  CCXBlockWebViewController.h
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/10/25.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXRootWebViewController.h"

typedef void (^ReturnTextValue)(NSString *string);
@interface CCXBlockWebViewController : CCXRootWebViewController
@property(nonatomic,copy)NSString *buttonTitle;
-(void)onButtonClick:(UIButton *)button;
@property(nonatomic,copy)ReturnTextValue returnTextBlock;
-(void)returnTextBlock:(ReturnTextValue )block;

@end
