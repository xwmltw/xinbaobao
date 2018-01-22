//
//  GJJAppUtils.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/10/31.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJAppUtils.h"

@implementation GJJAppUtils

NSString *CCXSERVR = @"";
NSString *GJJSIGNCONTRACTSUCCESS = @"signContractSuccess";
NSString *GJJCloseADImageH5 = @"closeADImageH5";
NSString* const APPDEFAULTNAME = @"优时贷";
NSString* const ALZMAPPID = @"300000041";//2017021705712966
NSString* const ZFBSCHEME = @"youshidaiPay";//

NSString* const MYINFOARROWDEFAULT = @"我的资料箭头";
NSString* const MYINFOARROWSELECTED = @"ziliao_arrow_right";


// 获取文本的高度
+ (CGFloat)calculateTextHeight:(UIFont *)font givenText:(NSString *)text givenWidth:(CGFloat)width {
    CGSize size = CGSizeMake(width, MAXFLOAT);
    if ([text length] == 0) {
        return 0.0f;
    }
    size = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
    
    CGFloat delta = size.height;
    
    return delta;
}

// 获取文本的宽度
+ (CGFloat)calculateTextWidth:(UIFont *)font givenText:(NSString *)text givenHeight:(CGFloat)height {
    CGSize size = CGSizeMake(MAXFLOAT, height);
    
    size = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
    
    CGFloat delta = size.width;
    
    return delta;
}

// 计算一个字符串数组中最大的长度
+ (CGFloat)calculatorMaxWidthWithString:(NSArray *)stringArray givenFont:(UIFont *)font
{
    NSMutableArray *widthArray = [NSMutableArray array];
    for (NSString *str in stringArray) {
        CGFloat labelWidth = ceil([GJJAppUtils calculateTextWidth:font givenText:str givenHeight:20]);
        [widthArray addObject:@(labelWidth)];
    }
    
    CGFloat maxLabelWidth = [[widthArray valueForKeyPath:@"@max.doubleValue"] doubleValue];
    return maxLabelWidth;
}

// 获取 手机号码 是否正确
+ (BOOL)isPhoneNumberClassification:(NSString *)phone{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     * 联通：130,131,132,152,155,156,185,186,1709
     * 电信：133,1349,153,180,189,1700
     */
    //    NSString * MOBILE = @"^1((3//d|5[0-35-9]|8[025-9])//d|70[059])\\d{7}$";//总况
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，1705
     12         */
    NSString * CM = @"^((13[5-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|^((134[0-8])|(170[3,5,6]))\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186,1709
     17         */
    NSString * CU = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(170[4,7-9])\\d{7}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,1700
     22         */
    NSString * CT = @"^((133)|(149)|(153)|(17[3,7])|(18[0,1,9]))\\d{8}|^((1349)|(170[0-2]))\\d{7}$";
    
    
    //    /**
    //     25         * 大陆地区固话及小灵通
    //     26         * 区号：010,020,021,022,023,024,025,027,028,029
    //     27         * 号码：七位或八位
    //     28         */
    //    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    
    //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestcm evaluateWithObject:phone] == YES)
        || ([regextestct evaluateWithObject:phone] == YES)
        || ([regextestcu evaluateWithObject:phone] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//验证身份证
+ (BOOL)validateIdentityCard:(NSString *)identityCard{
    
    BOOL flag;
    
    if (identityCard.length <= 0) {
        
        flag = NO;
        
        return flag;
        
    }
    
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    
    return [identityCardPredicate evaluateWithObject:identityCard];
    
}

//根据颜色生成图片
+ (UIImage *)createImageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//最小尺寸---1px
static CGFloat edgeSizeWithRadius(CGFloat cornerRadius) {
    return cornerRadius * 2 + 1;
}

+ (UIImage *)imageWithColor:(UIColor *)color
               cornerRadius:(CGFloat)cornerRadius {
    CGFloat minEdgeSize = edgeSizeWithRadius(cornerRadius);
    CGRect rect = CGRectMake(0, 0, minEdgeSize, minEdgeSize);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomRight|UIRectCornerTopRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
//    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth = 0;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [color setFill];
    [roundedRect fill];
    [roundedRect stroke];
    [roundedRect addClip];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}


@end
