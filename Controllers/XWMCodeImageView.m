//
//  XWMCodeImageView.m
//  XianJinDaiSystem
//
//  Created by yanqb on 2017/10/25.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "XWMCodeImageView.h"
#import "CCXSuperViewController.h"


@implementation XWMCodeImageView
{
    CCXSuperViewController *controller;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self  = [[NSBundle mainBundle]loadNibNamed:@"XWMCodeImage" owner:nil options:nil].firstObject;
        
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:10];
        
        //图形验证码
        self.codeImage = [[WQVerCodeImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        _codeImage.bolck = ^(NSString *imageCodeStr){
            //看情况是否需要
            MyLog(@"imageCodeStr = %@",imageCodeStr);
        };
        _codeImage.isRotation = NO;
        [_codeImage  freshVerCode];
        
//        [self addSubview:_codeImage];
        [self.ImageTextField.layer setMasksToBounds:YES];
        [self.ImageTextField.layer setBorderWidth:0.5];
        [self.ImageTextField.layer setBorderColor:CCXColorWithRGB(233, 233, 235).CGColor];
        self.ImageTextField.rightView = _codeImage;
        self.ImageTextField.rightViewMode = UITextFieldViewModeAlways;
        
        //点击刷新
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [_codeImage addGestureRecognizer:tap];
        
    }
    return self;
}
- (IBAction)OnBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 100:{
            if(!([self.ImageTextField.text compare:_codeImage.imageCodeStr options:NSCaseInsensitiveSearch|NSNumericSearch] == NSOrderedSame)){
                [controller setHudWithName:@"请输入正确的验证码" Time:1 andType:3];
                [_codeImage  freshVerCode];
                return;
            }
            XBlockExec(self.block,sender);
        }
            break;
        case 101:
            XBlockExec(self.block,sender);
            break;
            
        default:
            break;
    }
}
- (void)tapClick:(UITapGestureRecognizer *)tap{
    [_codeImage  freshVerCode];
}
@end
