//
//  JobViewController.h
//  iOS51rcProject
//
//  Created by qlrc on 14-8-25.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *recommentJobsData;
}
@property (retain, nonatomic) NSString *JobID;
@end
