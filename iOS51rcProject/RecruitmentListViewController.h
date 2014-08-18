//
//  RecruitmentListViewController.h
//  iOS51rcProject
//
//  Created by Lucifer on 14-8-14.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecruitmentListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *recruitmentData;
    NSInteger page;
    NSString *begindate;
    NSString *placeid;
}
@end
