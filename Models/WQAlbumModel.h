//
//  WQAlbumModel.h
//  RenRenhua2.0
//
//  Created by peterwon on 2016/11/1.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQAlbumModel : NSObject


/** icon 图片 */
@property (copy, nonatomic) NSString *icon;


+(instancetype)WQAlbumModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
