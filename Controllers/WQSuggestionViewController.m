//
//  WQSuggestionViewController.m
//  RenRenhua2.0
//
//  Created by peterwon on 2016/11/7.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "WQSuggestionViewController.h"

@interface WQSuggestionViewController ()<UITextViewDelegate>

/**发表意见或建议*/
@property(nonatomic,strong)UITextView *suggestionTextView;
/**textView中的文字*/
@property(nonatomic,strong)UILabel *decLabel;
/**textView中提示输入的文字*/
@property(nonatomic,strong)UILabel *stringLengthLabel;

@end

@implementation WQSuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //talkingdata
    [TalkingData trackEvent:@"我要反馈"];
    
    [self createTextView];
    [self createButton];
}

- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}

#pragma mark -- 网络请求
/**
 设置网络请求的params cmd
 */
-(void)setRequestParams{
    //提交意见
    CCXUser *secession = [self getSeccsion];
    if (self.requestCount == 0) {
        self.cmd = WQAdviceOrback;
        self.dict = @{@"userId" :secession.userId,
                      @"advice" :_suggestionTextView.text};
    }
}

/**
 网络请求成功之后的结果
 
 @param dict 网络请求成功之后返回的detail
 */
-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
    [self setHudWithName:@"谢谢您的反馈" Time:1 andType:0];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onButtonClick:(UIButton *)btn{
    if (btn.tag == 10){
        if (_suggestionTextView.text.length>0) {
              [self prepareDataWithCount:0];
        }else{
            [self setHudWithName:@"反馈意见不能为空" Time:1 andType:3];
        }
    }
}

-(void)createTextView{
    UIView *titleView = [[UIView alloc]initWithFrame:CCXRectMake(0, 20, 750, 80)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CCXRectMake(70, 20, 670, 40)];
    titleLabel.text = @"意见或建议";
    [titleView addSubview:titleLabel];
    
    UIImageView *SuggestionImageView = [[UIImageView alloc]initWithFrame:CCXRectMake(20, 20, 40, 40)];
    SuggestionImageView.image = [UIImage imageNamed:@"mine_feedback_img"];
    [titleView addSubview:SuggestionImageView];
    
    _suggestionTextView = [[UITextView alloc]initWithFrame:CCXRectMake(0, 90, 750, 300)];
    _suggestionTextView.backgroundColor = [UIColor blueColor];
    _suggestionTextView.font = [UIFont systemFontOfSize:30*CCXSCREENSCALE];
    _suggestionTextView.backgroundColor = [UIColor whiteColor];
    _suggestionTextView.showsVerticalScrollIndicator = YES;
    _suggestionTextView.delegate = self;
    [self.view addSubview:_suggestionTextView];
    
    UILabel *horizontalLine = [[UILabel alloc]initWithFrame:CCXRectMake(20, 0, 710, 1)];
    horizontalLine.backgroundColor = CCXBackColor;
    [_suggestionTextView addSubview:horizontalLine];
    
    _decLabel = [[UILabel alloc]initWithFrame:CCXRectMake(30, 20, 720, 30)];
    _decLabel.text = @"如果有什么问题或建议，就请告诉我们吧";
    _decLabel.font = [UIFont systemFontOfSize:30*CCXSCREENSCALE];
    _decLabel.textColor = [UIColor lightGrayColor];
    [_suggestionTextView addSubview:_decLabel];
    
    _stringLengthLabel = [[UILabel alloc]initWithFrame:CCXRectMake(650, 250, 100, 50)];
    _stringLengthLabel.text = @"0/200";
    _stringLengthLabel.textAlignment = NSTextAlignmentCenter;
    _stringLengthLabel.font = [UIFont systemFontOfSize:23*CCXSCREENSCALE];
    _stringLengthLabel.textColor = [UIColor lightGrayColor];
    [_suggestionTextView addSubview:_stringLengthLabel];
    
    [self drawDashLine:horizontalLine lineLength:3 lineSpacing:1 lineColor:[UIColor lightGrayColor]];
}

/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

-(void)createButton{
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CCXRectMake(40, 450, 670, 100);
    commitBtn.layer.cornerRadius = 5;
    commitBtn.clipsToBounds = YES;
    commitBtn.backgroundColor = CCXColorWithRGB(78, 142, 220);
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:36*CCXSCREENSCALE];
    commitBtn.tag = 10;
    [commitBtn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    
}


-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        _decLabel.hidden = NO;
    }else {
        _decLabel.hidden = YES;
    }
    if (textView.markedTextRange == nil&&textView.text.length >= 200) {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 200)];
    }
    _stringLengthLabel.text = [NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
}

//隐藏键盘，实现UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text.length >= 200 && text.length > range.length) {
        [self setHudWithName:@"超过字数限制了" Time:0.5 andType:3];
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
}

- (void)BarbuttonClick:(UIButton *)button
{
    [self.view endEditing:YES];
    if (_suggestionTextView.text.length == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前信息未提交，确定返回？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
