//
//  CalculatorVC.m
//  XianJinDaiSystem
//
//  Created by yanqb on 2017/11/9.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "CalculatorVC.h"

@interface CalculatorVC ()
{
    
    UITextField *textField;
    UITextField *textField2;
    UITextField *textField4;
    UITextField *textField5;
}
@end

@implementation CalculatorVC
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
}
- (void)setUI{
    UILabel *lab = [[UILabel alloc]init];
    [lab setText:@"收益计算器"];
    [lab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:36]];
    [lab setTextColor:CCXColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(40));
    }];
    UILabel *lab2 = [[UILabel alloc]init];
    [lab2 setText:@"借出金额:(元)"];
    [lab2 setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18]];
    [lab2 setTextColor:CCXColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:lab2];
    
    
    UILabel *text = [[UILabel alloc]init];
    [text setText:@"元"];
    [text setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18]];
    [text setTextColor:CCXColorWithRBBA(34, 58, 80, 0.8)];
    
    textField = [[UITextField alloc]init];
    textField.clearButtonMode = UITextFieldViewModeAlways;
//    textField.backgroundColor = CCXBackColor;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:18*XWMSCREENSCALE];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:textField];
    
    UILabel *lab3 = [[UILabel alloc]init];
    [lab3 setText:@"借款期限:(月)"];
    [lab3 setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18]];
    [lab3 setTextColor:CCXColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:lab3];
    
    textField2 = [[UITextField alloc]init];
    textField2.clearButtonMode = UITextFieldViewModeAlways;
    //    textField.backgroundColor = CCXBackColor;
    textField2.borderStyle = UITextBorderStyleRoundedRect;
    textField2.font = [UIFont systemFontOfSize:18*XWMSCREENSCALE];
    textField2.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:textField2];
    
    UILabel *lab4 = [[UILabel alloc]init];
    [lab4 setText:@"年化利率:(%)"];
    [lab4 setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18]];
    [lab4 setTextColor:CCXColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:lab4];
    
    textField4 = [[UITextField alloc]init];
    textField4.clearButtonMode = UITextFieldViewModeAlways;
    //    textField.backgroundColor = CCXBackColor;
    textField4.borderStyle = UITextBorderStyleRoundedRect;
    textField4.font = [UIFont systemFontOfSize:18*XWMSCREENSCALE];
    textField4.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:textField4];
    
    UILabel *lab5 = [[UILabel alloc]init];
    [lab5 setText:@"还款方式:"];
    [lab5 setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18]];
    [lab5 setTextColor:CCXColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:lab5];
    
    textField5 = [[UITextField alloc]init];
    [textField5 setText:@"一次性还款"];
    textField5.userInteractionEnabled = NO;
//    textField5.clearButtonMode = UITextFieldViewModeAlways;
    //    textField.backgroundColor = CCXBackColor;
    textField5.borderStyle = UITextBorderStyleRoundedRect;
    textField5.font = [UIFont systemFontOfSize:18*XWMSCREENSCALE];
    textField5.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:textField5];
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"开始计算" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 10*XWMSCREENSCALE;
    btn.clipsToBounds = YES;
    btn.backgroundColor = CCXColorWithRGB(255, 97, 142);
    [btn setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:36*CCXSCREENSCALE];
    [btn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(lab.mas_bottom).offset(AdaptationWidth(12));
    }];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(lab2.mas_bottom).offset(AdaptationWidth(8));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(37);
    }];
    [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(textField.mas_bottom).offset(AdaptationWidth(12));
    }];
    [textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(lab3.mas_bottom).offset(AdaptationWidth(8));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(37);
    }];
    [lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(textField2.mas_bottom).offset(AdaptationWidth(12));
    }];
    [textField4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(lab4.mas_bottom).offset(AdaptationWidth(8));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(37);
    }];
    [lab5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(textField4.mas_bottom).offset(AdaptationWidth(12));
    }];
    [textField5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(lab5.mas_bottom).offset(AdaptationWidth(8));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(37);
    }];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(40));
        make.top.mas_equalTo(textField5.mas_bottom).offset(AdaptationWidth(20));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(40));
        make.height.mas_equalTo(50);
    }];
}
- (void)onButtonClick:(UIButton *)btn{
    double a = textField.text.doubleValue;
    double b = textField2.text.doubleValue;
    double c = textField4.text.doubleValue;
    double d = a + a*(c*0.01*(b/12));
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"计算结果" message:[NSString stringWithFormat:@"到期需还款:%.2f元",d] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [vc addAction:ok];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
