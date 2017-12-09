//
//  GJJNeedOCRViewController.h
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2017/3/9.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "CCXNeedBackViewController.h"
//#import "OliveappLivenessDetectionViewController.h"
#import "Globaltypedef.h"
//真机和模拟器判断

#import "SCCaptureCameraController.h"

#import <AVFoundation/AVFoundation.h>

@interface GJJNeedOCRViewController : CCXNeedBackViewController

#pragma mark - 活体识别 and OCR
/**开始活体识别*/
//-(void)startLivenessDetection;
//-(void)livenessDetectionSuccess:(OliveappDetectedFrame*)detectedFrame;
//- (void)livenessDetectionFail: (int)sessionState withDetectedFrame: (OliveappDetectedFrame*)detectedFrame;
//-(void)livenessDetectionCancel;

///**开始身份证正面扫描*/
-(void)startIDCardOCR;
///**开始身份证反面扫描*/
-(void)startIDCardBackOCR;
////全部正面信息
//- (void)sendAllValue:(NSString *)text;
///**
// 身份证全图
// @param iCardType 20:反面 17：正面
// @param cardImage 图片
// */
//-(void)sendTakeImage:(TCARD_TYPE)iCardType image:(UIImage *)cardImage;
//// 获取身份证反面信息
//- (void)sendIDCBackValue:(NSString *)issue PERIOD:(NSString *) period;
//// 获取身份证正面信息
//- (void)sendIDCValue:(NSString *)name SEX:(NSString *)sex FOLK:(NSString *)folk BIRTHDAY:(NSString *)birthday ADDRESS:(NSString *)address NUM:(NSString *)num;
////获取身份证人脸照片
//-(void)sendCardFaceImage:(UIImage *)image;
//
///**
// 开始银行卡扫描
// */
-(void)startBankCardOCR;
/**
 银行卡回调
 @param bank_num 银行卡号码
 @param bank_name 银行姓名
 @param bank_orgcode 银行编码
 @param bank_class  银行卡类型(借记卡)
 @param card_name 卡名字
 */
-(void)sendBankCardInfo:(NSString *)bank_num BANK_NAME:(NSString *)bank_name BANK_ORGCODE:(NSString *)bank_orgcode BANK_CLASS:(NSString *)bank_class CARD_NAME:(NSString *)card_name;
/**
 @param BankCardImage 银行卡卡号扫描图片
 */
-(void)sendBankCardImage:(UIImage *)BankCardImage;

@end
