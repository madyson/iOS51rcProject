//
//  LoginDetailsViewController.h
//  iOS51rcProject
//
//  Created by qlrc on 14-8-15.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginDetailsDelegate.h"

@interface LoginDetailsViewController : UIViewController
{
    id<LoginDetailsDelegate> delegate;
    NSString *userName;
    NSString *userID;
    NSString *passWord;
    NSString *ip;
    NSString *provinceID;
    NSString *browser;
    BOOL isAutoLogin;
    
    NSString *wsName;//当前调用的webservice名字
}
@property (assign, nonatomic) id<LoginDetailsDelegate> delegate;
@end
