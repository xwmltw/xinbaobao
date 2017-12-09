//
//  WQMessageDetail.h
//  RenRenhua2.0
//
//  Created by peterwon on 2016/11/21.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQMessageDetail : NSObject

/*"h5Url": "",
 "publishTime": "2016-11-18 03:06",
 "comtent": "中心内容0记得我煤球给雪人装上当眼睛。一个活灵活现的雪人诞生了：戴着高.....",
 "picUrl": "",
 "mesId": "3",
 "title": "中心标题0"*/

@property(nonatomic,copy)NSString *publishTime;
@property(nonatomic,copy)NSString *comtent;
@property(nonatomic,copy)NSString *title;

@end
