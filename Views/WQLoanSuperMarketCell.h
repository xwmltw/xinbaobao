//
//  WQLoanSuperMarketCell.h
//  RenRenhua2.0
//
//  Created by peterwon on 2016/10/26.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQLoanSuperMarketModel.h"

@interface WQLoanSuperMarketCell : UITableViewCell

/*
 "org_pic_url": "http://115.28.242.125:8080/rrhcore/img/org/hwq.png",
 "loan_org_id": 1,
 "loan_org_name": "花无缺",
 "org_interface_url": "",
 "org_desc": "百种贷款 低门槛 快速放贷",
 "org_pic_url_log": "http://115.28.242.125:8080/rrhcore/img/org/hwqlog.png"
 */

/**商家的imageView*/
@property (nonatomic,strong)UIImageView *org_pic_urlImageV;
/**商家的log imageView*/
@property (nonatomic,strong)UIImageView *org_pic_url_logImageV;
/**商家名 label*/
@property (nonatomic,strong)UILabel *loan_org_nameLabel;
/**商家描述 label*/
@property (nonatomic,strong)UILabel *org_descLabel;


@property (nonatomic,strong)WQLoanSuperMarketModel *model;

@end
