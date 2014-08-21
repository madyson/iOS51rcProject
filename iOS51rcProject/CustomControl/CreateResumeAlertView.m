//
//  MainView.m
//  TNRadioButtonGroupDemo
//
//  Created by Frederik Jacques on 22/04/14.
//  Copyright (c) 2014 Frederik Jacques. All rights reserved.
//

#import "CreateResumeAlertView.h"

@implementation CreateResumeAlertView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        self.background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
        [self addSubview:self.background];
      
        [self createHasExpBtnGroupWithImage];
    }
    
    return self;
}

//创建按钮
- (void)createHasExpBtnGroupWithImage {
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SELECTED_RADIO_BUTTON_CHANGED object:self.hasExpGroup];
}

@end
