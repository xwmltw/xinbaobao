//
//  WQPhotoCell.m
//  RenRenhua2.0
//
//  Created by peterwon on 2016/10/31.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "WQPhotoCell.h"

@implementation WQPhotoCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.photo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
//        self.photo.layer.cornerRadius  = 10;
//        self.photo.layer.masksToBounds = YES;
        [self.contentView addSubview:self.photo];
    }
    return self;
}

-(void)setModel:(WQAlbumModel *)model{
    _model = model;
    _photo.image = [UIImage imageNamed:model.icon];
}

@end
