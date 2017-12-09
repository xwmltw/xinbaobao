//
//  ZLShowBigImage.m
//  点击图片放大
//
//  Created by qianfeng on 15-1-9.
//  Copyright (c) 2015年 张龙. All rights reserved.
//

#import "ZLShowBigImage.h"
#import "CCXSuperViewController.h"

static CGRect oldframe;
static CGRect originalFrame;

@implementation ZLShowBigImage

+ (void)showBigImage:(UIImageView *)selectedImageView
{
    UIImage *image=selectedImageView.image;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CCXSIZE_W, CCXSIZE_H)];
    backgroundView.tag = 100;
    //存储旧的frame
    oldframe = [selectedImageView convertRect:selectedImageView.bounds toView:window];
    
    originalFrame = oldframe;
    
    //创建灰色背景
    backgroundView.backgroundColor = CCXBackColor;
    
    backgroundView.alpha = 0;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:oldframe];
    
    //设置圆角
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 3.0f;
    
    imageView.image = image;
    imageView.tag = 1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotateAction:)];
    [backgroundView addGestureRecognizer:rotation];

    //添加拖拽和缩放手势
    imageView.userInteractionEnabled = YES;
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    [imageView addGestureRecognizer:pinch];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = CGRectMake(0,(CCXSIZE_H-image.size.height*CCXSIZE_W/image.size.width)/2, CCXSIZE_W, image.size.height*CCXSIZE_W/image.size.width);
        backgroundView.alpha = 1;
        originalFrame = oldframe = imageView.frame;
    }];
}

+ (void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = originalFrame;
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

//缩放效果
+ (void)pinchAction:(UIPinchGestureRecognizer *)pinch
{
    UIImageView *imageView = (UIImageView *)pinch.view;
    CGFloat width = oldframe.size.width*pinch.scale;
    CGFloat height = oldframe.size.height*pinch.scale;
    imageView.frame = CGRectMake(CGRectGetMidX(oldframe)-width/2, CGRectGetMidY(oldframe)-height/2, width, height);
    if (pinch.state == UIGestureRecognizerStateEnded) {
        oldframe = imageView.frame;
    }
}
//拖拽效果
+ (void)panAction:(UIPanGestureRecognizer *)pan
{
    UIImageView *imageView = (UIImageView *)pan.view;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [window viewWithTag:100];
    
    CGPoint oldPoint = imageView.center;
    CGPoint newPoint = [pan translationInView:backgroundView];
    imageView.center = CGPointMake(oldPoint.x+newPoint.x, oldPoint.y+newPoint.y);
    [pan setTranslation:CGPointZero inView:backgroundView];
    oldframe = imageView.frame;
}

////旋转效果
+ (void)rotateAction:(UIRotationGestureRecognizer *)rotationGuestureR{
    UIImageView *imageView = (UIImageView *)rotationGuestureR.view;
    static CGFloat rotation = 0;
    if (rotationGuestureR.state == UIGestureRecognizerStateChanged) {
        imageView.transform = CGAffineTransformMakeRotation(rotation+rotationGuestureR.rotation);
    }
    if (rotationGuestureR.state == UIGestureRecognizerStateEnded) {
        rotation += rotationGuestureR.rotation;
    }
}


@end
