//
//  WQMessageCenter.h
//  RenRenhua2.0
//
//  Created by peterwon on 2016/11/15.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQMessageCenter : NSObject

/* size = 0;
 time = "\U6682\U65e0\U8ba2\U5355\U6d88\U606f";
 type = 2;*/

@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *size;
@property(nonatomic,copy)NSString *type;

@end
