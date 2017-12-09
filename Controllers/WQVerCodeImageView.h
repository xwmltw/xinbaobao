//
//  WQVerCodeImageView.h
//  RenRenhua2.0
//
//  Created by peterwon on 2016/12/27.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WQCodeImageBlock)(NSString *codeStr);
@interface WQVerCodeImageView : UIView

@property (nonatomic, strong) NSString *imageCodeStr;
@property (nonatomic, assign) BOOL isRotation;
@property (nonatomic, copy) WQCodeImageBlock bolck;

-(void)freshVerCode;


@end
