//
//  GJJChoosePickerView.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/11/14.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJChoosePickerView.h"
#import "UIColor+Hex.h"

@interface GJJChoosePickerView ()
<UIPickerViewDelegate,
UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pick;

@end

@implementation GJJChoosePickerView
{
    NSString *_chooseThing;
    NSInteger _row;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    return self;
}

- (void)setChooseThings:(NSArray *)chooseThings
{
    _chooseThings = chooseThings;
    _chooseThing = _chooseThings[0];
    [self setupView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_delegate && [_delegate respondsToSelector:@selector(userCancelPick:)]) {
        [_delegate userCancelPick:self];
    }
    [self removeFromSuperview];
}

#pragma mark - view
- (void)setupView
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    _pick = [[UIPickerView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 216, ScreenWidth, 216)];
    _pick.delegate = self;
    _pick.dataSource = self;
    _pick.backgroundColor = [UIColor whiteColor];
    [self addSubview:_pick];
    
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-216-50, ScreenWidth, 50)];
    buttonView.backgroundColor = [UIColor whiteColor];
    [self addSubview:buttonView];
    
    UIButton *cancleButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, 60, 40)];
    cancleButton.backgroundColor = [UIColor whiteColor];
    [cancleButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancleButton addTarget: self action:@selector(cancleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    
    [buttonView addSubview:cancleButton];
    
    UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-10-60, 5, 60, 40)];
    [sureButton addTarget: self action:@selector(sureButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    
    [buttonView addSubview:sureButton];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _chooseThings.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _chooseThings[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _chooseThing = _chooseThings[row];
    _row = row;;
}

- (void)showView
{
    [[[UIApplication sharedApplication]keyWindow] addSubview:self];
}

- (void)cancleButtonPressed
{
    if (_delegate && [_delegate respondsToSelector:@selector(userCancelPick:)]) {
        [_delegate userCancelPick:self];
    }
    [self removeFromSuperview];
}

- (void)sureButtonPressed
{
    [self removeFromSuperview];
    if (_delegate && [_delegate respondsToSelector:@selector(chooseThing:pickView:row:)]) {
        [_delegate chooseThing:_chooseThing pickView:self row:_row];
    }
}

@end
