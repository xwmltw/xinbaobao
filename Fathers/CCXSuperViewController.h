//
//  CCXSuperViewController.h
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/10/18.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Hex.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "DEFINE.h"
#import "UIImageView+AFNetworking.h"
#import "CCXUser.h"

@interface CCXSuperViewController : UIViewController<
UITableViewDelegate,
UITableViewDataSource,
MBProgressHUDDelegate>

#pragma mark - 变量区

@property(nonatomic,assign) int requestCount;//标记同一个控制器中的多次网络请求
@property(nonatomic,strong) UITableView *tableV;//创建一个全局变量tableView
@property(nonatomic,strong) NSMutableArray *dataSourceArr;//创建一个全局变量数组
@property(nonatomic,copy)NSDictionary *dict;//用于网络请求的入参数
@property(nonatomic,copy)NSString *cmd;//用于标示网络请求的接口类型
@property(nonatomic,strong)MBProgressHUD *hud;//网络请求时的指示器
@property(nonatomic,strong)UIView *headerView;//声明一个tableView的头
@property(nonatomic,copy)NSDictionary *detailDict;//网络请求成功之后的detail

#pragma mark - 方法区

/**
 获取UUID
 */
- (NSString *)getUUID;

/**
 hud展示
 
 @param name hud展示的内容
 @param time hud持续的时间
 @param type 0:加载成功 1.加载失败 2.提醒警告 3.提示语
 */
-(void)setHudWithName:(NSString *)name Time:(float)time andType:(int)type;

/**创建带点击和标题的ImageView
 *name:表示图片名
 *frame:注意竖直长方形
 *tag:tag
 *title:标题
 */
-(UIView *)CCXTitleImageViewWithTitle:(NSString *)title frame:(CGRect)frame imageName:(NSString *)name url:(NSString *)url tag:(int)tag;

/**创建带点击事件的imageVIew
*name:表示图片名
*frame:正方形
*tag:tag
*/
-(UIImageView *)CCXImageViewWithImageName:(NSString *)name url:(NSString *)url andFrame:(CGRect)frame tag:(int)tag;

/** 可点图片的点击事件
 *  入参是图片上可点的button
 */
-(void)CCXImageClick:(UIButton *)button;

/** 创建学生版TabBar的类方法创建学生版TabBar的对象方法
 *  返回值是一个数组，数组中的元素是控制器对象
 */
-(NSArray *)setStudentTabBar;

/** 创建学生版TabBar的对象方法
 *  返回值是一个数组，数组中的元素是控制器对象
 */
+(NSArray *)setStudentTabBar;

/** 创建成人版TabBar的类方法
 *  返回值是一个数组，数组中的元素是控制器对象
 */
-(NSArray *)setAdultTabBar;

/** 创建成人版TabBar的对象方法
 *  返回值是一个数组，数组中的元素是控制器对象
 */
+(NSArray *)setAdultTabBar;

/**
 设置网络请求参数cmd,params,供子类重写
 */
-(void)setRequestParams;

/**  准备网络请求的参数,供子类调用重写
 *  count:用于表示多次网络请求的标识(0:表示tableView的数据创建)
 */
-(void)prepareDataWithCount:(int)count;

///**  网络请求成功之后调用,子类重写
// *   object 是网络请求的结果
// */
//-(void)getDataSourceWithObject:(id)object;

/**
 网络操作成功
 
 @param dict 成功之后的数据detail
 */
-(void)requestSuccessWithDictionary:(NSDictionary *)dict;

/**
 网络操作失败
 
 @param dict 失败之后的数据object
 */
-(void)requestFaildWithDictionary:(NSDictionary *)dict;

///**  网络请求
// *   string:表示请求的cmd dict:表示请求的参数
// */
//-(void)prepareDataGetUrlWithString:(NSString *)string andparmeter:(NSDictionary *)dict;

/** MD5加密(16位大写)
 *  input:需要加密的字符串
 *  出  参:加密之后的字符串
 */
- (NSString *)md5:(NSString *)input;

/**保存seccsion对象
 *参数1️⃣：表示存入seccsion的对象
 */
-(void)saveSeccionWithUser:(CCXUser *)user;
+(void)saveSeccionWithUser:(CCXUser *)user;

/**获取seccsion对象
 *返回结果:本地的seccsion
 */
-(CCXUser *)getSeccsion;
+(CCXUser *)getSeccsion;

/**
 清空seccsion
 */
-(void)clearSeccsion;
/**
 *  当某个对象不存在时,返回空值
 */
+(id)getValueWithkey:(id)key;

/**计算未来某一时刻到当前时间的时间差
 *time:表示未来某一时刻
 *dateFormatter:时间格式(ag:yyyy-MM-dd hh:mm:ss.SS)
 */
+(NSString *)getRestTimeWithString:(NSString *)time dataFormat:(NSString *)dateFormatter;

/** 创建点击手势
 *  view:手势作用的视图  tapNumber:触发点击手势的次数
 */
-(void)setTapGuestureWithView:(UIView *)view andTapNumber:(int)tapNumber;

/** 创建tableView
 *  frame:tableView的尺寸
 */
-(void)createTableViewWithFrame:(CGRect )frame;

/**
 tableView的上拉刷新事件
 */
-(void)headerRefresh;

/**
 tableView的下拉加载事件
 */
-(void)footerRefresh;

/** 点击手势的点击事件
 *  通过 guesture.view 获取点击手势添加的视图
 */
-(void)tapGuesture:(UITapGestureRecognizer *)guesture;

/**
 导航栏按钮的点击事件

 @param button 被点击的导航栏按钮 tag：9999 表示返回按钮
 */
-(void)BarbuttonClick:(UIButton *)button;

/**
设置导航栏透明
 */
-(void)setClearNavigationBar;

/**
 创建返回按钮
 */
-(void)setBackNavigationBarItem;


/**
 隐藏tabBar
 */
-(void)hideTabBar;

/**
 显示tabBar
 */
-(void)showTabBar;

@end

#pragma mark -- 跳转页面时候的效果动画
/**＊＊＊＊＊＊使用步骤＊＊＊＊＊＊＊＊＊＊*/
/***1.添加QuartzCore.framework  ***/
/***2.导入头文件#import <QuartzCore/QuartzCore.h>***/
typedef enum{
    /**相机*/CCXTransitionAnimationTypeCameraIris,
    /**立方体*/CCXTransitionAnimationTypeCube,
    /**淡入*/CCXTransitionAnimationTypeFade,
    /**移入*/CCXTransitionAnimationTypeMoveIn,
    /**翻转*/CCXTransitionAnimationTypeOglFilp,
    /**翻去一页*/CCXTransitionAnimationTypePageCurl,
    /**添上一页*/CCXTransitionAnimationTypePageUnCurl,
    /**平移*/CCXTransitionAnimationTypePush,
    /**移走*/CCXTransitionAnimationTypeReveal,
    /**移走*/CCXTransitionAnimationTypeRippleEffect,
    /**移走*/CCXTransitionAnimationTypeSuckEffect
}CCXTransitionAnimationType;

/**动画方向*/
typedef enum{
    CCXTransitionAnimationTowardFromLeft,
    CCXTransitionAnimationTowardFromRight,
    CCXTransitionAnimationTowardFromTop,
    CCXTransitionAnimationTowardFromBottom
}CCXTransitionAnimationToward;

@interface UIView (CCXTransitionAnimation)
//为当前视图添加切换的动画效果
//参数是动画类型和方向
//如果要切换两个视图，应将动画添加到父视图
- (void)setTransitionAnimationType:(CCXTransitionAnimationType)transtionAnimationType toward:(CCXTransitionAnimationToward)transitionAnimationToward duration:(NSTimeInterval)duration;

@end

