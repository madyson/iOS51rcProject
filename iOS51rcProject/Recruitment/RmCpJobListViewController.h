//
//  RmCpJobListViewController.h
//  iOS51rcProject
//
//  Created by qlrc on 14-8-31.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingAnimationView.h"
#import "Delegate/SelectJobDelegate.h"

@interface RmCpJobListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *JobListData;
    LoadingAnimationView *loadView;
    id<SelectJobDelegate> delegate;
}
@property (retain, nonatomic) NSString *cpMainID;
@property (retain, nonatomic) id<SelectJobDelegate> delegate;
@end
