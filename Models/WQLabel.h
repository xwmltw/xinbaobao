//
//  WQLabel.h
//  RenRenhua2.0
//
//  Created by peterwon on 2016/11/22.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface WQLabel : UILabel

{
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

@end
