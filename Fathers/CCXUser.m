//
//  CCXSeccsion.m
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/10/25.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXUser.h"
#import "CCXSuperViewController.h"

@implementation CCXUser
-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.name = [CCXSuperViewController getValueWithkey:dict[@"name"]];
        self.phone = [CCXSuperViewController getValueWithkey:dict[@"phone"]];
        self.password = [CCXSuperViewController getValueWithkey:dict[@"password"]];
        self.userId = [CCXSuperViewController getValueWithkey:dict[@"userId"]];
        self.customName = [CCXSuperViewController getValueWithkey:dict[@"customName"]];
        self.orgId = [CCXSuperViewController getValueWithkey:dict[@"orgId"]];
        self.token = [CCXSuperViewController getValueWithkey:dict[@"token"]];
        self.uuid = [CCXSuperViewController getValueWithkey:dict[@"uuid"]];
    }
    return self;
}

#pragma mark -- 解档
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.educational = [aDecoder decodeObjectForKey:@"educational"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.grade = [aDecoder decodeObjectForKey:@"grade"];
        self.shcoolName = [aDecoder decodeObjectForKey:@"shcoolName"];
        self.identityCard = [aDecoder decodeObjectForKey:@"identityCard"];
        self.customName = [aDecoder decodeObjectForKey:@"customName"]?[aDecoder decodeObjectForKey:@"customName"]:APPDEFAULTNAME;
        self.orgId = [aDecoder decodeObjectForKey:@"orgId"];
        self.place = [aDecoder decodeObjectForKey:@"place"];
        self.entraDate = [aDecoder decodeObjectForKey:@"entraDate"];
        self.bdrAddr = [aDecoder decodeObjectForKey:@"bdrAddr"];
        self.isVirtualNetworkOperator = [aDecoder decodeObjectForKey:@"isVirtualNetworkOperator"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
          self.uuid = [aDecoder decodeObjectForKey:@"uuid"];
    }
    return self;
}

#pragma mark -- 归档
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.educational forKey:@"educational"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.grade forKey:@"grade"];
    [aCoder encodeObject:self.shcoolName forKey:@"shcoolName"];
    [aCoder encodeObject:self.identityCard forKey:@"identityCard"];
    [aCoder encodeObject:self.place forKey:@"place"];
    [aCoder encodeObject:self.entraDate forKey:@"entraDate"];
    [aCoder encodeObject:self.bdrAddr forKey:@"bdrAddr"];
    [aCoder encodeObject:self.customName?self.customName:APPDEFAULTNAME forKey:@"customName"];
    [aCoder encodeObject:self.orgId forKey:@"orgId"];
    [aCoder encodeObject:self.isVirtualNetworkOperator forKey:@"isVirtualNetworkOperator"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.uuid forKey:@"uuid"];

}

-(NSString *)description{
    return [NSString stringWithFormat:@"name:%@ userId:%@ phone:%@ password:%@ educational:%@ shcoolName:%@ customName:%@",self.name,self.userId,self.phone,self.password,self.educational,self.shcoolName,self.customName];
}


@end
