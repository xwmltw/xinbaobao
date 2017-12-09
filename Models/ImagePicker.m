//
//  ImagePicker.m
//  ReplaceThePicture
//
//  Created by apple on 16/1/25.
//  Copyright © 2016年 DeveYang. All rights reserved.
//

#import "ImagePicker.h"
#import <AVFoundation/AVFoundation.h>

@interface ImagePicker()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate>
@property(nonatomic, weak)UIViewController  *viewController;
@property(nonatomic, copy)ImagePickerFinishAction  finishAction;
@property(nonatomic, assign)BOOL  allowsEditing;
@end
//用到此类的时候初始化
static ImagePicker *imagePickerInstance = nil;
@implementation ImagePicker
+ (void)showImagePickerFromViewController:(UIViewController *)viewController
                            allowsEditing:(BOOL)allowsEditing
                             finishAction:(ImagePickerFinishAction)finishAction{
    if (imagePickerInstance == nil) {
        imagePickerInstance = [[ImagePicker alloc] init];
    }
    
    [imagePickerInstance showImagePickerFromViewController:viewController
                                               allowsEditing:allowsEditing
                                                finishAction:finishAction];
}
- (void)showImagePickerFromViewController:(UIViewController *)viewController
                            allowsEditing:(BOOL)allowsEditing
                             finishAction:(ImagePickerFinishAction)finishAction {
    _viewController = viewController;
    _finishAction = finishAction;
    _allowsEditing = allowsEditing;
    
    UIActionSheet *sheet = nil;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet = [[UIActionSheet alloc] initWithTitle:nil
                                            delegate:self
                                   cancelButtonTitle:@"取消"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"拍照", nil];
    }
    UIView *window = [UIApplication sharedApplication].keyWindow;
    [sheet showInView:window];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"拍照"]) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined:{
                // 许可对话没有出现，发起授权许可
                
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    
                    if (granted) {
                        //第一次用户接受
                    }else{
                        //用户拒绝
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized:{
                // 已经开启授权，可继续
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.allowsEditing = _allowsEditing;
                [_viewController presentViewController:picker animated:YES completion:nil];

                break;
            }
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                // 用户明确地拒绝授权，或者相机设备无法访问
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"请打开系统设置->隐私->相机%@按钮",APPDEFAULTNAME] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
                }];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    
                    if([[UIApplication sharedApplication] canOpenURL:url]) {
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
                            [[UIApplication sharedApplication] openURL:url];
                        }else {
                            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                        }
                    }
                }];
                
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
                [_viewController presentViewController:alertController animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }else {
        imagePickerInstance = nil;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    if (_finishAction) {
        _finishAction(image);
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    imagePickerInstance = nil;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (_finishAction) {
        _finishAction(nil);
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    imagePickerInstance = nil;
}

@end
