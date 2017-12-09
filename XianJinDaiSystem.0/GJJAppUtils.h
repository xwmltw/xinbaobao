//
//  GJJAppUtils.h
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/10/31.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJJAppUtils : NSObject

///获取服务器地址
UIKIT_EXTERN NSString *CCXSERVR;

///签订合同成功
UIKIT_EXTERN NSString *GJJSIGNCONTRACTSUCCESS;

///APP名
UIKIT_EXTERN NSString* const APPDEFAULTNAME;
///支付宝跳转scheme
UIKIT_EXTERN NSString* const ZFBSCHEME;
//芝麻信用id
UIKIT_EXTERN NSString* const ALZMAPPID;

//我的资料默认箭头名称
UIKIT_EXTERN NSString* const MYINFOARROWDEFAULT;

UIKIT_EXTERN NSString* const MYINFOARROWSELECTED;

///关闭广告页的H5
UIKIT_EXTERN NSString *GJJCloseADImageH5;

/// 获取文本的高度
+ (CGFloat)calculateTextHeight:(UIFont *)font givenText:(NSString *)text givenWidth:(CGFloat)width;

/// 获取文本的宽度
+ (CGFloat)calculateTextWidth:(UIFont *)font givenText:(NSString *)text givenHeight:(CGFloat)height;

///计算一个字符串数组中最大的长度
+ (CGFloat)calculatorMaxWidthWithString:(NSArray *)stringArray givenFont:(UIFont *)font;

/// 判断电话号码是否正确
+ (BOOL)isPhoneNumberClassification:(NSString *)phone;

+ (BOOL)validateIdentityCard:(NSString *)identityCard;

///根据颜色生成图片
+ (UIImage *)createImageWithColor:(UIColor*)color;

///生成圆角图片
+ (UIImage *)imageWithColor:(UIColor *)color
               cornerRadius:(CGFloat)cornerRadius;

@end
