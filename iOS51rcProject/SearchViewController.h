//
//  SearchViewController.h
//  iOS51rcProject
//
//  Created by Lucifer on 14-8-25.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIView *viewSearchSelect;
@property (retain, nonatomic) IBOutlet UIButton *btnSearch;
@property (retain, nonatomic) IBOutlet UITextField *txtKeyWord;
@property (retain, nonatomic) IBOutlet UIButton *btnRegionSelect;
@property (retain, nonatomic) IBOutlet UILabel *lbRegionSelect;
@property (retain, nonatomic) IBOutlet UIButton *btnJobTypeSelect;
@property (retain, nonatomic) IBOutlet UILabel *lbJobTypeSelect;
@property (retain, nonatomic) IBOutlet UIButton *btnIndustrySelect;
@property (retain, nonatomic) IBOutlet UILabel *lbIndustrySelect;

@end
