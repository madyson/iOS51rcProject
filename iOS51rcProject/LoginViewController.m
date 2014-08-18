//
//  LoginViewController.m
//  iOS51rcProject
//
//  Created by qlrc on 14-8-15.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import "LoginViewController.h"


@interface LoginViewController ()
@property (retain, nonatomic) IBOutlet UISegmentedControl *segment;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)segmentChange:(id)sender {
    NSInteger index = self.segment.selectedSegmentIndex;
    if (index == 0){
        [self.registerView removeFromParentViewController];
        [self.view addSubview:self.loginDetailsView.view];
    } else  {
        [self.loginDetailsView removeFromParentViewController];
        [self.view addSubview:self.registerView.view];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loginDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginDetailsView"];
    self.registerView = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterView"];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.origin.y = 100;//状态栏和切换栏的高度
    frame.size.height = frame.size.height - 100;
    
    self.loginDetailsView.view.frame = frame;
    self.registerView.view.frame = frame;
    
    // Do any additional setup after loading the view.
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    
    [self.view addSubview: self.loginDetailsView.view];
}
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.registerView removeFromParentViewController];
        [self.view addSubview:self.loginDetailsView.view];
        self.segment.selectedSegmentIndex = 0;
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self.loginDetailsView removeFromParentViewController];
        [self.view addSubview:self.registerView.view];
        self.segment.selectedSegmentIndex = 1;
    }
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
    [_segment release];
    [super dealloc];
}
@end
