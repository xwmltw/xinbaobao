//
//  GJJQueryServiceUrlModel.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/11/10.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJQueryServiceUrlModel.h"

@implementation GJJQueryServiceUrlModel

MJCodingImplementation
XSharedInstance(GJJQueryServiceUrlModel);
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"versionNew" : @"newVersion"};
}

@end
