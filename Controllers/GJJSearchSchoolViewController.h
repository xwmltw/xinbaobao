//
//  GJJSearchSchoolViewController.h
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/11/1.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXNeedBackViewController.h"

@class GJJSearchSchoolModel;

typedef void (^ReturnTextValue)(GJJSearchSchoolModel *schoolModel);

@interface GJJSearchSchoolViewController : CCXNeedBackViewController

@property(nonatomic,copy)ReturnTextValue returnTextBlock;

@end
