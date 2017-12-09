//
//  CCXRecordViewController.m
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/11/3.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXRecordViewController.h"
#import "VoiceConverter.h"
#import <AVFoundation/AVFoundation.h>

@interface CCXRecordViewController ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>
@property(nonatomic,strong) AVAudioRecorder *audioRecorder;//音频录音机
@property(nonatomic,strong) AVAudioPlayer *audioPlayer;//音频播放器
@property(nonatomic,strong) UIButton *recordBtn;//录音按钮
@property(nonatomic,strong) UIButton *uploadBtn;//上传按钮
@property(nonatomic,strong) UIButton *playBtn;//试听按钮
@property(nonatomic,strong) UIImageView *backImageV;//底部背景
@end

@implementation CCXRecordViewController

#pragma mark - 控制器方法

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareDataWithCount:0];
    // Do any additional setup after loading the view.
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 父类方法

/**
 设置网络请求参数
 */
-(void)setRequestParams{
    CCXUser *seccsion = [self getSeccsion];
    if (0 == self.requestCount) {
        self.cmd = CCXQureyAudioLoan;
        self.dict = @{@"userId":seccsion.userId,
                      @"loanAmt":self.loanMoney,
                      @"loanPerion":self.loanMonth};
    }else if (1 == self.requestCount){
        NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        str = [str stringByAppendingPathComponent:CCXRecordAudioFile];
        NSData *data = [NSData dataWithContentsOfFile:str];
        NSString *url = [data base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
        self.cmd = CCXUpAudioService;
        self.dict = @{@"userId":seccsion.userId,@"audio":url};
    }else if (2 == self.requestCount){
        self.cmd = CCXLoanApply;
        self.dict = @{@"userId":seccsion.userId,
                      @"loanAmt": self.loanMoney,
                      @"loanPerion": self.loanMonth,
                      @"audioUrl": self.detailDict[@"audioUrl"]};
    }
}

/**
 网络请求成功之后执行
 @param dict 请求的参数detail
 */
-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
        self.detailDict = dict;
    if (0 == self.requestCount) {
        [self createTableViewWithFrame:CGRectZero];
        [self.tableV makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        self.tableV.backgroundColor= CCXColorWithHex(@"#F2F2F2");
        [self setHeaser];
        [self setAudioSession];
        [self recordBtn];
        [self playBtn];
        [self uploadBtn];
    }else if (1 == self.requestCount){
        [self setHudWithName:@"上传成功" Time:0.5 andType:0];
        [self prepareDataWithCount:2];
    }else if (2 == self.requestCount){
        [self setHudWithName:@"借款成功" Time:0.5 andType:0];
        [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
    }
}

/**
 下拉刷新之后执行
 */
-(void)headerRefresh{
    _backImageV = nil;
    _playBtn = nil;
    _uploadBtn = nil;
    _recordBtn = nil;
    [self prepareDataWithCount:0];
}

#pragma mark - tableView代理协议方法

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 552*CCXSCREENSCALE;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 422*CCXSCREENSCALE;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CCXRectMake(50, 20, 650, 402)];
    imageV.image = [UIImage imageNamed:@"操作步骤"];
    [self.headerView addSubview:imageV];
    return self.headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CCXRectMake(50, 20, 650, 532)];
    imageV.image = [UIImage imageNamed:@"线框"];
    [view addSubview:imageV];
    UIImageView *TimageV = [[UIImageView alloc]initWithFrame:CCXRectMake(30, 46, 20, 34)];
    TimageV.image = [UIImage imageNamed:@"文字"];
    [imageV addSubview:TimageV];
    UILabel *label = [[UILabel alloc]initWithFrame:CCXRectMake(30, 60, 590, 470)];
    label.text = [NSString stringWithFormat:@"       %@",self.detailDict[@"voiceContract"]];
    label.textColor = CCXColorWithHex(@"#666666");
    label.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    [label sizeToFit];
    [imageV addSubview:label];
    return view;
}

#pragma mark - 录音机代理方法

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *strOr = [str stringByAppendingPathComponent:CCXRecordAudioFile];
    NSString *strSave = [str stringByAppendingPathComponent:CCXSendAudioFile];
    int ret = [VoiceConverter wavToAmr:strOr amrSavePath:strSave];
    if (ret == 0) {
        //后面清除.wav文件
        [self setHudWithName:@"录制成功" Time:0.5 andType:3];
        _uploadBtn.enabled = YES;
        _playBtn.enabled = YES;
    }else{
        [self setHudWithName:@"录制失败，重新录制" Time:0.5 andType:3];
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    _recordBtn.enabled = YES;
    _uploadBtn.enabled = YES;
}
#pragma mark - 自定义方法

/**
 设置tableView的头
 */
-(void)setHeaser{
    UIView *view = [[UIView alloc]initWithFrame:CCXRectMake(0, 0, 750, 60)];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CCXRectMake(40, 20, 20, 20)];
    imageV.image = [UIImage imageNamed:@"注明"];
    [view addSubview:imageV];
    UILabel *label = [[UILabel alloc]initWithFrame:CCXRectMake(80, 20, 570, 20)];
    label.textColor = CCXColorWithHex(@"#999999");
    label.font = [UIFont systemFontOfSize:20*CCXSCREENSCALE];
    label.text = @"请阅读下方文字录音并上传。";
    [view addSubview:label];
    self.tableV.tableHeaderView = view;
}

/**
 底部背景图懒加载
 
 @return 底部背景
 */
-(UIImageView *)backImageV{
    if (!_backImageV) {
        _backImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, CCXSIZE_H-158*CCXSCREENSCALE, CCXSIZE_W, 158*CCXSCREENSCALE)];
        _backImageV.userInteractionEnabled = YES;
        _backImageV.image = [UIImage imageNamed:@"录音底部固定背景"];
        [self.view addSubview:_backImageV];
    }
    return _backImageV;
}

/**
 *  创建上传按钮
 *
 *  @return 上传按钮
 */
-(UIButton *)uploadBtn{
    if (!_uploadBtn) {
        _uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _uploadBtn.frame = CCXRectMake(0, 0, 250, 158);
        _uploadBtn.enabled = NO;
        [_uploadBtn setBackgroundImage:[UIImage imageNamed:@"上传"] forState:UIControlStateNormal];
        [_uploadBtn setBackgroundImage:[UIImage imageNamed:@"上传 2"] forState:UIControlStateDisabled];
        [_uploadBtn addTarget:self action:@selector(uploadClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.backImageV addSubview:_uploadBtn];
    }
    return _uploadBtn;
}

/**
 *  创建试听按钮
 *
 *  @return 试听按钮
 */
-(UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.enabled = NO;
        _playBtn.frame = CCXRectMake(500, 0, 250, 158);
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"试听"] forState:UIControlStateNormal];
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"试听 2"] forState:UIControlStateDisabled];
        [_playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.backImageV addSubview:_playBtn];
    }
    return _playBtn;
}

/**
 *  创建录音按钮
 *
 *  @return 录音按钮
 */
-(UIButton *)recordBtn{
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordBtn.frame = CCXRectMake(250, 0, 250, 158);
        [_recordBtn setBackgroundImage:[UIImage imageNamed:@"录音"] forState:UIControlStateNormal];
        [_recordBtn setBackgroundImage:[UIImage imageNamed:@"录音 1"] forState:UIControlStateHighlighted];
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"录音 2"] forState:UIControlStateDisabled];
        [_recordBtn addTarget:self action:@selector(recordClick:) forControlEvents:UIControlEventTouchDown];
        [_recordBtn addTarget:self action:@selector(recordUndoClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.backImageV addSubview:_recordBtn];
    }
    return _recordBtn;
}

/**
 *  创建音频播放器
 *
 *  @return 音频播放器
 */
-(AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        NSURL *url = [self getRecordSavePath];
        NSError *error = nil;
        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        _audioPlayer.delegate = self;
        _audioPlayer.numberOfLoops = 0;
        [_audioPlayer prepareToPlay];
        if (error) {
            NSLog(@"=====创建播放器错误,错误信息为:%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}

/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
-(AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        NSURL *url = [self getRecordSavePath];//创建录音文件保存路径
        NSDictionary *setting = [self getAudioSetting];//创建录音格式设置
        NSError *error = nil;
        _audioRecorder = [[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];//创建录音机
        _audioRecorder.delegate = self;
        _audioRecorder.meteringEnabled = YES;//监控声波设置为YES
        if (error) {
            NSLog(@"=====创建录音机对象发生错误,错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}

/**
 *  获得录音文件的保存路劲
 *
 *  @return 录音文件路径
 */
-(NSURL *)getRecordSavePath{
    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    str = [str stringByAppendingPathComponent:CCXRecordAudioFile];
    NSLog(@"======file path:%@",[NSURL fileURLWithPath:str]);
    return [NSURL fileURLWithPath:str];
}

/**
 *  获取录音文件设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];//设置录音格式
    [dicM setObject:@(8000) forKey:AVSampleRateKey];//设置录音采样率(8000是电话采样率)
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];//设置通道(单声道)
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];//每个采样点位数(8,16,24,32)
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];//是否采用浮点数采样
    //....其他设置等
    return dicM;
}
/**
 *  设置audio的seccsion
 */
-(void)setAudioSession{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}

/**
 *  按住录音事件
 *
 *  @param button 按住不放
 */
-(void)recordClick:(UIButton *)button{
    if (![self.audioRecorder isRecording]) {
        _audioPlayer = nil;
        [_audioRecorder record];//开始录音
        _uploadBtn.enabled = NO;
        _playBtn.enabled = NO;
    }
}
/**
 *  录音保存
 *
 *  @param button 松开录音按钮
 */
-(void)recordUndoClick:(UIButton *)button{
    [self.audioRecorder stop];
}
/**
 *  播放录音
 *
 *  @param button 点击播放按钮
 */
-(void)playClick:(UIButton *)button{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
    [self.audioPlayer play];
    _recordBtn.enabled = NO;
    _uploadBtn.enabled = NO;
}
/**
 *  录音上传
 *
 *  @param button 点击上传按钮并且松开
 */
-(void)uploadClick:(UIButton *)button{
    _recordBtn.enabled = YES;
    [self prepareDataWithCount:1];
}

@end
