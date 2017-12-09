//
//  WQMessageCenterCell.m
//  RenRenhua2.0
//
//  Created by peterwon on 2016/11/15.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "WQMessageCenterCell.h"
#import "CCXSuperViewController.h"

@implementation WQMessageCenterCell{
    UILabel *_timeLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self customView];
    }
    return self;
}

-(void)customView{
    _timeLabel = [[UILabel alloc]initWithFrame:CCXRectMake(550, 25, 200, 30)];
    _timeLabel.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.textColor = [UIColor grayColor];
//    self.centerImageView = [[UIImageView alloc]initWithFrame:CCXRectMake(10, 10, 110, 110)];
//    [self addSubview:self.centerImageView];
    [self addSubview:_timeLabel];
}

-(void)setModel:(WQMessageCenter *)model{
   _timeLabel.text = model.time;
}

@end
