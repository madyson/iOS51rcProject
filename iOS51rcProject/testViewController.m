//
//  testViewController.m
//  iOS51rcProject
//
//  Created by qlrc on 14-8-29.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import "testViewController.h"

@interface testViewController ()
@property (retain, nonatomic) IBOutlet UIScrollView *sv;

@end

@implementation testViewController

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
    self.sv.delegate = self;
    self.sv.frame = CGRectMake(0,0, 320, 400);
    [self.sv setContentSize:CGSizeMake(320, 1600)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)dealloc {
    [_sv release];
    [super dealloc];
}
@end
