//
//  WQMessageDetailViewController.h
//  RenRenhua2.0
//
//  Created by peterwon on 2016/11/16.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXNeedBackViewController.h"

//@class WQSystemMessage;

@interface WQMessageDetailViewController : CCXNeedBackViewController

//定义block
//@property(nonatomic,copy)void(^blockMesId)(NSString *popWithMesId);

@property(nonatomic,copy)NSString *messageId;
//@property(nonatomic,strong)WQSystemMessage *model;


@end
