//
//  STMessageCenterCell.h
//  XianJinDaiSystem
//
//  Created by 孙涛 on 2017/9/23.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQInteractionMessage.h"
@interface STMessageCenterCell : UITableViewCell

@property (nonatomic, strong) UIImageView *infoImageView;

@property (nonatomic,strong)UILabel *typeLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic,strong) UILabel *seperatorLabel;

@property (nonatomic,strong)WQInteractionMessage *messageModel;
@end
