//
//  WQPicAnnounce.h
//  RenRenhua2.0
//
//  Created by peterwon on 2017/1/6.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQPicAnnounce : NSObject
/*
 "h5Url": "http://115.28.242.125:8085/api/share.html?154",
 "picUrl": "https://wanzao2.b0.upaiyun.com/system/pictures/26764101/original/1438222990_650x405.png",
 "messageId": "1",
 "title": "活动一"
*/
@property (nonatomic, copy) NSString *h5Url;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *shareStatus;

@end
