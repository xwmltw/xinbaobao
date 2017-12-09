//
//  CCXSlider.h
//  RenrenCost
//
//  Created by 陈传熙 on 16/9/1.
//  Copyright © 2016年 ChuanxiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCXSlider : UISlider<NSCoding>

-(instancetype)initWithMaxImageName:(NSString *)maxName minImageName:(NSString *)minName thumbImageName:(UIImage *)thubImage;

@property(nonatomic,copy)NSString *leftImage;
@property(nonatomic,copy)NSString *rightImage;

@end
