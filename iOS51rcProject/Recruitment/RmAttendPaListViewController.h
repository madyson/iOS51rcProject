//
//  RecruitmentPaListViewController.h
//  iOS51rcProject
//
//  Created by qlrc on 14-8-26.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingAnimationView.h"

@interface RmAttendPaListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger page;
    NSInteger pageSize;
    NSMutableArray *recruitmentPaData;
    //NSString *rmID;
    LoadingAnimationView *loadView;
}
@property (retain, nonatomic) NSString *rmID;
@end
