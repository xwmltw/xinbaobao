//  WQLoanSuperMarketModel.h
//  RenRenhua2.0
//
//  Created by peterwon on 2016/10/26.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQLoanSuperMarketModel : NSObject

/*
 "org_pic_url": "http://115.28.242.125:8080/rrhcore/img/org/hwq.png",
 "loan_org_id": 1,
 "loan_org_name": "花无缺",
 "org_interface_url": "",
 "org_desc": "百种贷款 低门槛 快速放贷",
 "org_pic_url_log": "http://115.28.242.125:8080/rrhcore/img/org/hwqlog.png"
 */

/**商家大图*/
@property (nonatomic,copy)NSString *org_pic_url;
/**商家名字*/
@property (nonatomic,copy)NSString *loan_org_name;
/**商家公司描述*/
@property (nonatomic,copy)NSString *org_desc;
/**公司logo*/
@property (nonatomic,copy)NSString *org_pic_url_log;

@end
