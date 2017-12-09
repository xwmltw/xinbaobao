//
//  GJJCountDownButton.h
//  MoChouHua
//
//  Created by 葛佳佳 on 2017/8/13.
//  Copyright © 2017年 葛佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GJJCountDownButton;
typedef NSString* (^CountDownChanging)(GJJCountDownButton *countDownButton,NSUInteger second);
typedef NSString* (^CountDownFinished)(GJJCountDownButton *countDownButton,NSUInteger second);
typedef void (^TouchedCountDownButtonHandler)(GJJCountDownButton *countDownButton,NSInteger tag);

@interface GJJCountDownButton : UIButton

@property(nonatomic,strong) id userInfo;
///倒计时按钮点击回调
- (void)countDownButtonHandler:(TouchedCountDownButtonHandler)touchedCountDownButtonHandler;
//倒计时时间改变回调
- (void)countDownChanging:(CountDownChanging)countDownChanging;
//倒计时结束回调
- (void)countDownFinished:(CountDownFinished)countDownFinished;
///开始倒计时
- (void)startCountDownWithSecond:(NSUInteger)second;
///停止倒计时
- (void)stopCountDown;

@end
