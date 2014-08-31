//
//  RmInviteCpViewController.h
//  iOS51rcProject
//
//  Created by qlrc on 14-8-29.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RmInviteCpViewController : UIViewController
@property (retain, nonatomic) NSString *strRmID;//招聘会ID
@property (retain, nonatomic) NSDate *dtBeginTime;//举办时间
@property (retain, nonatomic) NSString *strAddress;//地址
@property (retain, nonatomic) NSString *strPlace;//场馆
@property (retain, nonatomic) NSArray  *arrJobs;//邀请的职位
@end
