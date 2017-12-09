//
//  GJJQueryServiceUrlModel.h
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/11/10.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJJQueryServiceUrlModel : NSObject

@property (nonatomic, copy) NSString *updateStatus;

@property (nonatomic, copy) NSString *serviceUrl;

@property (nonatomic, copy) NSString *versionNew;

@property (nonatomic, copy) NSString *comtent;

@property (nonatomic, copy) NSString *size;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, strong) NSArray *dataList;

@property (nonatomic, copy) NSString *updateUrl;

@property (nonatomic, copy) NSNumber *switch_on_off_1; /*!< 审核流程开关*/

@property (nonatomic, copy) NSNumber *switch_on_off_2; /*!< 咨询 计算器开关*/

//新增功能开关2个：用户登录后弹窗引导用户跳出应用下载/调起第三方应用（贷款超市）
//用户提交申请失败/被拒弹窗引导下载/调起第三方应用（贷款超市）
//1开0关
@property (nonatomic, copy) NSNumber *switch_on_off_3;

@property (nonatomic, copy) NSString *switch_on_off_3_url;
+ (instancetype)sharedInstance;
@end
