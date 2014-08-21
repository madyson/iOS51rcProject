//
//  RegisterViewController.h
//  iOS51rcProject
//
//  Created by qlrc on 14-8-15.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomControl/CreateResumeAlertViewController.h"

@interface RegisterViewController : UIViewController
{
    NSString *wsName;//当前调用的webservice名字
    
    NSString *userName;
    NSString *userID;
    NSString *password;
    NSString *rePassword;
    NSString *ip;
    NSString *provinceID;
    NSString *browser;
    NSString *isAutoLogin;
    CreateResumeAlertViewController *createResumeCtrl;
    UIView *backGroundView;
}

@end
