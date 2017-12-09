//
//  WQPhotoCell.h
//  RenRenhua2.0
//
//  Created by peterwon on 2016/10/31.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQAlbumModel.h"

@interface WQPhotoCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *photo;

/**照片 model*/
@property(nonatomic,strong)WQAlbumModel *model;

@end
