//
//  WQAlbumModel.m
//  RenRenhua2.0
//
//  Created by peterwon on 2016/11/1.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "WQAlbumModel.h"

@implementation WQAlbumModel

+(instancetype)WQAlbumModelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
