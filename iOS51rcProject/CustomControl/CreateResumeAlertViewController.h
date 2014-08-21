//
//  CreateResumeAlertViewController.h
//  iOS51rcProject
//
//  Created by qlrc on 14-8-21.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TNRadioButtonGroup.h"

//协议
@protocol CreateResumeDelegate <NSObject>
-(void) CreateResume:(BOOL) hasExp;
@end


@interface CreateResumeAlertViewController : UIViewController
{
    BOOL hasExp;
    id<CreateResumeDelegate> delegate;
}
@property (nonatomic, strong) TNRadioButtonGroup *hasExpGroup;//是否有经验
@property (nonatomic, assign) id<CreateResumeDelegate> delegate;
@end
