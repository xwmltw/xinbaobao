//
//  CCXSeccsion.h
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/10/25.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCXUser: NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *phone;
/**userId  在登录成功后手动标记为1  未登录时标记为-100 退出登录或者被挤下线标记为-100*/
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *password;

/**uuid*/
@property(nonatomic,copy)NSString *uuid;

/**token*/
@property(nonatomic,copy)NSString *token;
/**性别*/
@property(nonatomic,copy)NSString *sex;
/**学历*/
@property(nonatomic,copy)NSString *educational;
/**地址*/
@property(nonatomic,copy)NSString *address;
/**班级*/
@property(nonatomic,copy)NSString *grade;
/**大学名称*/
@property(nonatomic,copy)NSString *shcoolName;
/**身份证号码*/
@property(nonatomic,copy)NSString *identityCard;
/**校区*/
@property(nonatomic,copy)NSString *place;
/**入学时间*/
@property(nonatomic,copy)NSString *entraDate;
/**宿舍地址*/
@property(nonatomic,copy)NSString *bdrAddr;
/**真实姓名*/
@property(nonatomic,copy)NSString *customName;
/**0:学生、1:成人*/
@property(nonatomic,copy)NSString *orgId;
/**0:正常运营商、1:虚拟运营商*/
@property(nonatomic,copy) NSString *isVirtualNetworkOperator;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

@end
