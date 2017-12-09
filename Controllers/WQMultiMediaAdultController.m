//
//  WQMulti_MediaApprovementViewController.m
//  RenRenhua2.0
//
//  Created by peterwon on 2016/10/31.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "WQMultiMediaAdultController.h"
#import "WQPhotoCell.h"
#import "WQAlbumModel.h"
#import "ImagePicker.h"
#import "WQDashLineView.h"
#import "ZYQAssetPickerController.h"
#import "ZLShowBigImage.h"
#import "WQPhotoModel.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface WQMultiMediaAdultController ()<UINavigationControllerDelegate, ZYQAssetPickerControllerDelegate,UIScrollViewDelegate>

@property (retain, nonatomic) NSMutableArray *DataSource;

@end

@implementation WQMultiMediaAdultController{
    NSString        *_encodeString;
    UIScrollView    *_photoScrollView;
    NSMutableArray  *_theAddImageArr;
    NSMutableArray  *_theImageArr;
    NSDictionary    *_dataList;
    NSMutableArray  *_smallPicUrlArr;
    NSMutableArray  *_picTypeArr;
    NSMutableArray  *_picUrlArr;
    NSArray         *_photoArr;
    UIButton        *_btn;
    NSArray         *_photoImageArr;
    ALAsset         *_aset;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareDataWithCount:0];
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

-(void)headerRefresh{
    [self.tableV removeFromSuperview];
    [self prepareDataWithCount:0];
}

#pragma mark -- 网络请求
/**
 设置网络请求的params cmd
 */
-(void)setRequestParams{
    //上传图片
    CCXUser *secession = [self getSeccsion];
    if (self.requestCount == 0) {
        self.cmd = WQQueryMyStatus;
        self.dict = @{@"userId" :secession.userId,
                      @"type"   :@"2"};
    } else{//1,2,3,4
        self.cmd = WQUpLoadPicture;
        UIImageView *imageV = (UIImageView *)([self.view viewWithTag:self.requestCount].superview);
        NSData *imageData = UIImageJPEGRepresentation(imageV.image, 1);
        if (self.requestCount == 4) {
            imageData = UIImageJPEGRepresentation([UIImage imageWithCGImage:_aset.defaultRepresentation.fullScreenImage], 0.3);
        }
        _encodeString = [[imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet punctuationCharacterSet]];
        self.dict = @{@"userId": secession.userId,
                      @"picType":[NSString stringWithFormat:@"%d",self.requestCount-1],
                      @"imgIo": _encodeString};
    }
}

/**
 网络请求成功之后的结果
 
 @param dict 网络请求成功之后返回的detail
 */
-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
    if (self.requestCount == 0) {
        NSArray *dataListArr = dict[@"dataList"];
        self.dataSourceArr = [NSMutableArray new];
        for (NSDictionary *dic in dataListArr) {
            WQPhotoModel *model = [WQPhotoModel yy_modelWithDictionary:dic];
            [self.dataSourceArr addObject:model];
        }
        NSArray *personPicListArr = dict[@"personPicList"];
        self.DataSource = [NSMutableArray new];
        for (NSDictionary *dic in personPicListArr) {
            WQPhotoModel *model = [WQPhotoModel yy_modelWithDictionary:dic];
            [self.DataSource addObject:model];
        }
        [self createTableViewWithFrame:CGRectZero];
        [self.tableV makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [self createView];
//        [_photoScrollView removeFromSuperview];
//        [self createScrollView];
    }else if(self.requestCount == 4){
        [self setHudWithName:@"上传成功" Time:1 andType:3];
        
    }else{
        [self setHudWithName:@"上传成功" Time:1 andType:3];
        [self prepareDataWithCount:0];
    }
}



-(void)createView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CCXSIZE_W, CCXSIZE_H-64)];
    headerView.userInteractionEnabled = YES;
    _photoImageArr = @[@"身份证正面.png",@"身份证反面.png",@"手持身份证.png",@"添加.png"];
    for (int i = 0; i<4; i++) {
        WQPhotoModel *model;
        for (WQPhotoModel *model1 in self.dataSourceArr) {
            if ([model1.picType intValue] == i) {
                model = model1;
            }
        }
        UIImageView *view = [self CCXImageViewWithImageName:_photoImageArr[i] url:model.smallPicUrl andFrame:CCXRectMake((50+350*(i%2)), (20+350*(i/2)), 300, 300) tag:i+1];
        
        [headerView addSubview:view];
    }
    WQDashLineView *dashView = [[WQDashLineView alloc]initWithFrame:CCXRectMake(20, 700, 710, 30)];
    [headerView addSubview:dashView];
    
    UILabel* noteLabel = [[UILabel alloc] init];
    noteLabel.frame = CCXRectMake(20, 730, 710, 120);
    noteLabel.textColor = [UIColor grayColor];
    noteLabel.numberOfLines = 2;
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:@"选填: 可补充上传相关照片(例：家庭、工作等),完善度越高,总额度就越高。"];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:@"选填:"].location, [[noteStr string] rangeOfString:@"选填:"].length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
    
    NSRange redRangeTwo = NSMakeRange([[noteStr string] rangeOfString:@"总额度就越高。"].location, [[noteStr string] rangeOfString:@"总额度就越高"].length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRangeTwo];
    
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:40*CCXSCREENSCALE weight:12*CCXSCREENSCALE] range:redRangeTwo];
    
    [noteLabel setAttributedText:noteStr];
    [noteLabel sizeToFit];
    [headerView addSubview:noteLabel];
    
    
        _photoScrollView=[[UIScrollView alloc] initWithFrame:CCXRectMake(30, 850, 690, 200)];
        _photoScrollView.userInteractionEnabled = YES;
        _photoScrollView.alwaysBounceHorizontal = YES;
        _photoScrollView.delegate=self;
        _photoScrollView.contentSize = CCXSizeMake(180*self.DataSource.count, 180);
        for (int i=0; i<self.DataSource.count; i++) {
            WQPhotoModel *model = self.DataSource[i];
            UIImageView *imageV = [self CCXImageViewWithImageName:@"加载图" url:model.smallPicUrl andFrame:CCXRectMake(180*i, 20, 160, 160) tag:5+i];
            [_photoScrollView addSubview:imageV];
        }
        [headerView addSubview:_photoScrollView];
        self.tableV.tableHeaderView = headerView;
}


//picType为0 1 2 tag 1 2 3
-(void)CCXImageClick:(UIButton *)btn{
    if (btn.tag<4) {
        for (WQPhotoModel *model in self.dataSourceArr) {
            if ([model.picType intValue] == btn.tag-1) {
                btn.enabled = NO;
            }
        }
        if (btn.enabled) {
            [ImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
                if (!image) {
                    return;
                }
                UIImageView *imageV = (UIImageView *)([self.view viewWithTag:btn.tag].superview);
                imageV.image = image;
                [self prepareDataWithCount:(int)btn.tag];
            }];
        }
    }else if (btn.tag == 4){
        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
        picker.maximumNumberOfSelection = 30;
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups=NO;
        picker.delegate=self;
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                return duration >= 5;
            }else{
                return YES;
            }
        }];
        [self presentViewController:picker animated:YES completion:NULL];
    }else{
        [ZLShowBigImage showBigImage:(UIImageView *)([self.view viewWithTag:btn.tag].superview)];
    }
}

#pragma mark - ZYQAssetPickerController Delegate

-(void)assetPickerController:(ZYQAssetPickerController *)picker currentViewController:(ZYQAssetViewController *)assetController didFinishPickingAssets:(NSArray *)assets{
    self.hud = [MBProgressHUD showHUDAddedTo:assetController.navigationController.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.detailsLabel.text = @"上传中,请等待";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            _aset = obj;
            [self prepareDataWithCount:4];
        }];
        self.hud.hidden = YES;
        [self prepareDataWithCount:0];
        if (picker.isFinishDismissViewController) {
            [picker.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
