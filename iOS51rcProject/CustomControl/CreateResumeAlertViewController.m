//
//  CreateResumeAlertViewController.m
//  iOS51rcProject
//
//  Created by qlrc on 14-8-21.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import "CreateResumeAlertViewController.h"


@interface CreateResumeAlertViewController ()

@end

@implementation CreateResumeAlertViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//创建按钮
- (void)createHorizontalListWithImage {
    TNImageRadioButtonData *hasExpData = [TNImageRadioButtonData new];
    hasExpData.labelText = @"有工作经历";
    hasExpData.identifier = @"hasExp";
    hasExpData.selected = YES;
    hasExpData.unselectedImage = [UIImage imageNamed:@"unchecked"];
    hasExpData.selectedImage = [UIImage imageNamed:@"checked"];
    
    TNImageRadioButtonData *hasNoExpData = [TNImageRadioButtonData new];
    hasNoExpData.labelText = @"没有工作经历";
    hasNoExpData.identifier = @"hasNoExp";
    hasNoExpData.selected = NO;
    hasNoExpData.unselectedImage = [UIImage imageNamed:@"unchecked"];
    hasNoExpData.selectedImage = [UIImage imageNamed:@"checked"];
    
    self.hasExpGroup = [[TNRadioButtonGroup alloc] initWithRadioButtonData:@[hasExpData, hasNoExpData] layout:TNRadioButtonGroupLayoutVertical];
    self.hasExpGroup.identifier = @"hasExp group";
    [self.hasExpGroup create];
    self.hasExpGroup.position = CGPointMake(25, 400);
    
    [self addSubview: self.hasExpGroup];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasExpGroupUpdated:) name:SELECTED_RADIO_BUTTON_CHANGED object:self.hasExpGroup];
}

//切换选择按钮
- (void)hasExpGroupUpdated:(NSNotification *)notification {
    NSLog(@"[MainView] Temperature group updated to %@", self.hasExpGroup.selectedRadioButton.data.identifier);
}

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:SELECTED_RADIO_BUTTON_CHANGED object:self.sexGroup];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:SELECTED_RADIO_BUTTON_CHANGED object:self.hobbiesGroup];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SELECTED_RADIO_BUTTON_CHANGED object:self.hasExpGroup];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
