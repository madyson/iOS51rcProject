//
//  RmInviteCpViewController.h
//  iOS51rcProject
//
//  Created by qlrc on 14-8-29.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePicker.h"
#import "LoadingAnimationView.h"
#import "RmCpMain.h"
#import "Delegate/SelectJobDelegate.h"

@interface RmInviteCpViewController : UIViewController<SelectJobDelegate>
{
    NSMutableArray *placeData;//场馆
    DatePicker *pickDate;//时间选择
    
    NSString *regionID;
    NSString *beginDate;
    NSString *placeID;
    LoadingAnimationView *loadView;
    
    //如果是从职位页面设置返回
    NSString *settedCpID;
    NSString *settedJobID;
    NSString *settedJobName;
}
@property (retain, nonatomic) NSString *strRmID;//招聘会ID
@property (retain, nonatomic) NSString *strBeginTime;//举办时间
@property (retain, nonatomic) NSString *strAddress;//地址
@property (retain, nonatomic) NSString *strPlace;//场馆
@property (retain, nonatomic) NSArray  *arrJobs;//邀请的职位
//@property (retain, nonatomic) NSArray *cpIDs;//预约面试的企业
@property (retain, nonatomic) NSMutableArray *selectRmCps;
//@property (retain, nonatomic) s
@end
