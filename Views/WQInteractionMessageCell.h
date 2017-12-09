//
//  WQInteractionMessageCell.h
//  RenRenhua2.0
//
//  Created by peterwon on 2016/11/16.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQInteractionMessage.h"

@protocol WQInteractionMessageCellDelegate <NSObject>

-(void)WQInteractionCustomBtnClicked:(UIButton *)button;

@end

@interface WQInteractionMessageCell : UITableViewCell

@property(nonatomic,strong)WQInteractionMessage *model;
@property(nonatomic,weak)id <WQInteractionMessageCellDelegate> delegate;
@property(nonatomic,assign)NSInteger cellRow;
@property(nonatomic,strong)UIButton *btn;

@end
