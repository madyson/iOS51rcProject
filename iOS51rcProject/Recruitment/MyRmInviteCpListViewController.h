//
//  MyRmInviteCpListViewController.h
//  iOS51rcProject
//
//  Created by qlrc on 14-8-28.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingAnimationView.h"
@interface MyRmInviteCpListViewController: UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *recruitmentCpData;
    //NSString *rmID;
    LoadingAnimationView *loadView;   
}
@property (retain, nonatomic) NSString *rmID;
@end
