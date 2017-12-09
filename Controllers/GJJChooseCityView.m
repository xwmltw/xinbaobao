//
//  GJJChooseCityView.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/11/1.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJChooseCityView.h"
#import "UIColor+Hex.h"

@interface GJJChooseCityView ()
<UIPickerViewDelegate,
UIPickerViewDataSource>

/** 1.数据源数组 */
@property (nonatomic, strong, nullable)NSArray *arrayRoot;
/** 2.当前省数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayProvince;
/** 3.当前城市数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayCity;
/** 4.当前地区数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayArea;

/** 5.当前选中数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arraySelected;

@property (nonatomic, strong) UIPickerView *pick;

/** 6.省份 */
@property (nonatomic, strong, nullable)NSString *province;
/** 7.城市 */
@property (nonatomic, strong, nullable)NSString *city;
/** 8.地区 */
@property (nonatomic, strong, nullable)NSString *area;

@end

@implementation GJJChooseCityView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self setupData];
    [self setupView];
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

#pragma mark - data
- (void)setupData
{
    [self.arrayRoot enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.arrayProvince addObject:obj[@"state"]];
    }];
    
    NSMutableArray *citys = [NSMutableArray arrayWithArray:[self.arrayRoot firstObject][@"cities"]];
    [citys enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.arrayCity addObject:obj[@"city"]];
    }];
    
    self.arrayArea = [citys firstObject][@"area"];
    
    self.province = self.arrayProvince[0];
    self.city = self.arrayCity[0];
    if (self.arrayArea.count != 0) {
        self.area = self.arrayArea[0];
    }else{
        self.area = @"";
    }

}


- (NSArray *)arrayRoot
{
    if (!_arrayRoot) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"plist"];
        _arrayRoot = [[NSArray alloc]initWithContentsOfFile:path];
    }
    return _arrayRoot;
}

- (NSMutableArray *)arrayProvince
{
    if (!_arrayProvince) {
        _arrayProvince = [NSMutableArray array];
    }
    return _arrayProvince;
}

- (NSMutableArray *)arrayCity
{
    if (!_arrayCity) {
        _arrayCity = [NSMutableArray array];
    }
    return _arrayCity;
}

- (NSMutableArray *)arrayArea
{
    if (!_arrayArea) {
        _arrayArea = [NSMutableArray array];
    }
    return _arrayArea;
}

- (NSMutableArray *)arraySelected
{
    if (!_arraySelected) {
        _arraySelected = [NSMutableArray array];
    }
    return _arraySelected;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.arrayProvince.count;
    }else if (component == 1) {
        return self.arrayCity.count;
    }else{
        return self.arrayArea.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *text;
    if (component == 0) {
        text =  self.arrayProvince[row];
    }else if (component == 1){
        text =  self.arrayCity[row];
    }else{
        if (self.arrayArea.count > 0) {
            text = self.arrayArea[row];
        }else{
            text =  @"";
        }
    }
    return text;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.arraySelected = self.arrayRoot[row][@"cities"];
        
        [self.arrayCity removeAllObjects];
        [self.arraySelected enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.arrayCity addObject:obj[@"city"]];
        }];
        
        self.arrayArea = [NSMutableArray arrayWithArray:[self.arraySelected firstObject][@"areas"]];
        
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    }else if (component == 1) {
        if (self.arraySelected.count == 0) {
            self.arraySelected = [self.arrayRoot firstObject][@"cities"];
        }
        
        self.arrayArea = [NSMutableArray arrayWithArray:[self.arraySelected objectAtIndex:row][@"areas"]];
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    }else{
    }
    
    [self reloadData];
    
}

- (void)reloadData
{
    NSInteger index0 = [self.pick selectedRowInComponent:0];
    NSInteger index1 = [self.pick selectedRowInComponent:1];
    NSInteger index2 = [self.pick selectedRowInComponent:2];
    self.province = self.arrayProvince[index0];
    self.city = self.arrayCity[index1];
    if (self.arrayArea.count != 0) {
        self.area = self.arrayArea[index2];
    }else{
        self.area = @"";
    }
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

- (void)cancleButtonPressed
{
    [self removeFromSuperview];
}

- (void)sureButtonPressed
{
    if (_delegate && [_delegate respondsToSelector:@selector(chooseCityWithProvince:city:town:chooseView:)]) {
        [_delegate chooseCityWithProvince:self.province city:self.city town:self.area chooseView:self];
    }
    [self removeFromSuperview];
}

- (void)showView
{
    [[[UIApplication sharedApplication]keyWindow] addSubview:self];
}

@end
