//
//  WQSystemMessageCell.h
//  RenRenhua2.0
//
//  Created by peterwon on 2016/11/16.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQSystemMessage.h"

@protocol WQSystemMessageCellDelegate <NSObject>

-(void)WQSystemCustomBtnClicked:(UIButton *)button;

@end

@interface WQSystemMessageCell : UITableViewCell

@property (nonatomic, strong)WQSystemMessage *model;
@property (nonatomic, weak)id <WQSystemMessageCellDelegate> delegate;
@property (nonatomic, assign)NSInteger cellRow;
@property (nonatomic, strong)UIButton *btn;

@end
