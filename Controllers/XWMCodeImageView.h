//
//  XWMCodeImageView.h
//  XianJinDaiSystem
//
//  Created by yanqb on 2017/10/25.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQVerCodeImageView.h"
@interface XWMCodeImageView : UIView

@property (weak, nonatomic) IBOutlet UITextField *ImageTextField;
@property (nonatomic ,strong) WQVerCodeImageView *codeImage;
@property (copy ,nonatomic) XBlock block;

- (instancetype)initWithFrame:(CGRect)frame;
@end
