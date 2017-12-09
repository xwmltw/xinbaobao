//
//  WQModifyPasswordViewController.m
//  RenrenCost
//
//  Created by peterwon on 16/8/31.
//  Copyright © 2016年 ChuanxiChen. All rights reserved.
//

#import "WQModifyPasswordViewController.h"
#import "WQLogViewController.h"
#import "WQRedrawTextfield.h"
#import "ZQGraphValidateCode.h"
#import "WQVerCodeImageView.h"
#import "WQNextModifyPassWordViewController.h"

typedef NS_ENUM(NSInteger,WQModifyPasswordRequest){
    WQModifyPwdGetValiCodeFromPhone,
};


@interface WQModifyPasswordViewController ()<UITextFieldDelegate>

/**手机号*/
@property(nonatomic,strong)WQRedrawTextfield *phoneText;
/**验证码*/
@property(nonatomic,strong)WQRedrawTextfield *validateCodeText;
/**验证码按钮*/
@property(nonatomic,strong)UIButton *vericationRightBtn;

@end

@implementation WQModifyPasswordViewController{
    NSInteger    _timer;
    NSTimer      *_timerCode;
    NSTimer      *_timerClose;
    NSDictionary *_dict;
    WQVerCodeImageView  *_validateCodeImageV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTextfield];
    [self createButton];
}


/**
  tag:(手机号码输入框) 3 （图形验证码）4
 */
-(void)createTextfield{
    UIView *modifiedView = [[UIView alloc]initWithFrame:CCXRectMake(0, 30, 750, 510)];
    [self.view addSubview:modifiedView];
    
    _phoneText = [[WQRedrawTextfield alloc]initWithFrame:CCXRectMake(40, 0, 670, 86)];
    _phoneText.backgroundColor = CCXBackColor;
    _phoneText.borderStyle = UITextBorderStyleRoundedRect;
    _phoneText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入您的手机号" attributes:@{}];
    if (_phontString.length > 0 ) {
        _phoneText.text = _phontString;
    }
    _phoneText.clearButtonMode = UITextFieldViewModeAlways;
    _phoneText.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
    _phoneText.tag = 3;
    _phoneText.delegate = self;
    _phoneText.keyboardType = UIKeyboardTypeNumberPad;
    _phoneText.leftOffset = 10;
    _phoneText.leftOffset = 10;
    [_phoneText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    //电话号码左图片
    UIImageView *imageV1 = [[UIImageView alloc]
                            initWithImage:[UIImage imageNamed:@"number"]];
    imageV1.frame = CCXRectMake(0, 0, 30, 40);
    _phoneText.leftView = imageV1;
    _phoneText.leftViewMode = UITextFieldViewModeAlways;
    
    _validateCodeText = [[WQRedrawTextfield alloc]initWithFrame:CCXRectMake(40, 106, 473, 86)];
    _validateCodeText.tag = 4;
    _validateCodeText.backgroundColor = CCXBackColor;
    _validateCodeText.keyboardType = UIKeyboardTypeASCIICapable;
    _validateCodeText.borderStyle = UITextBorderStyleRoundedRect;
    _validateCodeText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入右侧验证码" attributes:@{}];
    _validateCodeText.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
    _validateCodeText.delegate = self;
     [_validateCodeText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _validateCodeText.leftOffset = 10;
    _validateCodeText.rightOffset = 10;
    
    //验证码左图片
    UIImageView *imageV2 =
    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"code"]];
    imageV2.frame = CCXRectMake(0, 0, 30, 40);
    _validateCodeText.leftView = imageV2;
    _validateCodeText.leftViewMode = UITextFieldViewModeAlways;

    
    //图形验证码
    _validateCodeImageV = [[WQVerCodeImageView alloc]initWithFrame:CCXRectMake(522, 106, 188, 86)];
    _validateCodeImageV.backgroundColor = [UIColor redColor];
    _validateCodeImageV.bolck = ^(NSString *imageCodeStr){
    //看情况是否需要
        MyLog(@"imageCodeStr = %@",imageCodeStr);
    };
    _validateCodeImageV.isRotation = NO;
    [_validateCodeImageV  freshVerCode];
    
    //点击刷新
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [_validateCodeImageV addGestureRecognizer:tap];
    [modifiedView addSubview:_validateCodeImageV];
    
    [modifiedView addSubview:_vericationRightBtn];
    [modifiedView addSubview:_phoneText];
    [modifiedView addSubview:_validateCodeText];
}

- (void)tapClick:(UITapGestureRecognizer *)tap{
    [_validateCodeImageV freshVerCode];
}




/**
 设置网络请求的params cmd
 */
-(void)setRequestParams{
    if (self.requestCount == WQModifyPwdGetValiCodeFromPhone) {
        self.cmd = WQGetValiCodeFromPhone;
        self.dict = @{@"phone":_phontString,
                      @"userId":@"",
                      @"type":@"2"};
    }
}

/**
 网络请求成功之后的结果
 
 @param dict 网络请求成功之后返回的detail
 */
-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
    MyLog(@"+++++++++++++%@",dict);
    if (self.requestCount == 0) {
        [self setHudWithName:@"验证码获取成功" Time:1 andType:0];
        [self PushToControllerNeedCountDown:YES];
    }
}

-(void)requestFaildWithDictionary:(NSDictionary *)dict{
    [super requestFaildWithDictionary:dict];
    if ([dict[@"resultNote"] isEqualToString:@"验证码1分钟之内有效，勿重复发送"]) {
        [self PushToControllerNeedCountDown:NO];
    }
}
/**
 tag (下一步)20
 */
-(void)createButton{
    UIButton *confirmModifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmModifyButton.frame = CCXRectMake(40, 272, 670, 100);
    confirmModifyButton.layer.cornerRadius = 20*CCXSCREENSCALE;
    confirmModifyButton.clipsToBounds = YES;
    confirmModifyButton.backgroundColor = CCXColorWithRGB(78, 142, 220);
    [confirmModifyButton setTitle:@"下一步" forState:UIControlStateNormal];
    [confirmModifyButton setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
    confirmModifyButton.titleLabel.font = [UIFont systemFontOfSize:36*CCXSCREENSCALE];
    confirmModifyButton.tag = 20;
    [confirmModifyButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmModifyButton];
}

-(void)onButtonClick:(UIButton *)btn{
    if (btn.tag == 10) {//获取验证码
        [self prepareDataWithCount:WQModifyPwdGetValiCodeFromPhone];
    }else if (btn.tag == 20){//确认修改
        [self.view endEditing:YES];
        if (_phoneText.text == 0) {
            [self setHudWithName:@"请输入手机号" Time:1 andType:1];
            return;
        }
        if (_phoneText.text.length != 11) {
            [self setHudWithName:@"请输入正确的手机号" Time:1 andType:1];
            return;
        }
        if (_validateCodeText.text.length == 0) {
            [self setHudWithName:@"请输入右侧验证码" Time:1 andType:3];
            return;
        }
        if (!([_validateCodeText.text compare:_validateCodeImageV.imageCodeStr options:NSCaseInsensitiveSearch|NSNumericSearch] == NSOrderedSame)) {
            [self setHudWithName:@"请输入正确的验证码" Time:1 andType:3];
            [_validateCodeImageV freshVerCode];
            return;
        }else{
            _phontString = _phoneText.text;
            [self prepareDataWithCount:WQModifyPwdGetValiCodeFromPhone];
        }
    }
}

-(void)PushToControllerNeedCountDown:(BOOL)needCountDown
{
    WQNextModifyPassWordViewController *controller = [[WQNextModifyPassWordViewController alloc]init];
    controller.title = @"找回密码";
    controller.phontString = _phoneText.text;
    controller.needCountDown = needCountDown;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark -- textFieldDelegate
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    if (textField.tag == 3) {
        textField.text = @"";
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == _phoneText) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
    
    if (textField == _validateCodeText){
        if (textField.text.length > 4) {
            textField.text = [textField.text substringToIndex:4];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
