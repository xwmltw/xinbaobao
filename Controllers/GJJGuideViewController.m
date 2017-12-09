//
//  GJJGuideViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/11/9.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJGuideViewController.h"

@interface GJJGuideViewController ()<UIScrollViewDelegate>

@end

@implementation GJJGuideViewController
{
    // 当前页面
    int _currentPage;
    BOOL _isHiddenStatusBar;
    UIScrollView *_scrollView;
    NSMutableArray *_imgViews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self viewInit];
    }
    return self;
}

-(void)viewInit
{
    self.view.backgroundColor = [UIColor whiteColor];
    _currentPage = 0;
    _imgViews = [[NSMutableArray alloc] init];
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
}

#pragma mark- load images

-(void)reloadImages
{
    if (!_images || [_images count] == 0)
    {
        return;
    }
    
    if (_imgViews && [_imgViews count] != 0)
    {
        // 移除以前的imageView
        [_imgViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            [(UIImageView *)obj removeFromSuperview];
        }];
    }
    
    [_images enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        NSString *imgName = (NSString *)obj;
        UIImage *img = [UIImage imageNamed:imgName];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
        imageView.frame = CGRectMake(idx * CGRectGetWidth(_scrollView.frame), 0,CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
        imageView.tag = idx;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        
        if (idx == [_images count] - 1)
        {
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alreadyRead)];
            [imageView addGestureRecognizer:tap];
        }
        
        [_imgViews addObject:imageView];
        
        [_scrollView addSubview:imageView];
    }];
    
    _scrollView.contentSize = CGSizeMake([_images count] * _scrollView.frame.size.width, 0);
    
}

- (void)alreadyRead
{
    if ([_delegate respondsToSelector:@selector(guideDidFinished:)]) {
        //设置为已读
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:YES forKey:GJJReadGuide];
        [userDefaults synchronize];
        [_delegate guideDidFinished:self];
    }
}

#pragma mark- setter and getter

-(void)setImages:(NSArray *)images
{
    _images = images;
    
    [self reloadImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
