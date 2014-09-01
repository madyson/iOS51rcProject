//
//  MyRmReceivedInvitationViewController.h
//  iOS51rcProject
//
//  Created by qlrc on 14-8-27.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingAnimationView.h"
#import "GoToRmViewDetailDelegate.h"
#import "GoToMyInvitedCpViewDelegate.h"

@interface MyRmReceivedInvitationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger selectRowIndex;
    NSMutableArray *recruitmentCpData;
    //NSString *rmID;
    LoadingAnimationView *loadView;
    NSMutableArray *checkedCpArray;
    id<GoToRmViewDetailDelegate> gotoRmViewDelegate;
    id<GoToMyInvitedCpViewDelegate> gotoMyInvitedCpViewDelegate;
    NSInteger selectRowHeight;
}
@property (retain, nonatomic) id<GoToRmViewDetailDelegate> gotoRmViewDelegate;
@property (retain, nonatomic) id<GoToMyInvitedCpViewDelegate> gotoMyInvitedCpViewDelegate;
@end
