//
//  WQOrderMessageCell.h
//  RenRenhua2.0
//
//  Created by peterwon on 2017/1/13.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQOrderMessage.h"

@protocol WQSystemMessageCellDelegate <NSObject>

-(void)WQOrderCustomBtnClicked:(UIButton *)button;

@end

@interface WQOrderMessageCell : UITableViewCell

@property (nonatomic, strong)WQOrderMessage *model;
@property (nonatomic, weak)id <WQSystemMessageCellDelegate> delegate;
@property (nonatomic, assign)NSInteger cellRow;
@property (nonatomic, strong)UIButton *btn;

@end
