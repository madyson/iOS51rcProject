//
//  HomeViewController.m
//  iOS51rcProject
//
//  Created by qlrc on 14-8-20.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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

//点击我的简历按钮
- (IBAction)btnMyResultClick:(id)sender {
    UIStoryboard *login = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginViewController *loginCtrl = [login instantiateViewControllerWithIdentifier:@"LoginView"];
    [self.navigationController pushViewController:loginCtrl animated:YES];
    //[loginCtrl release];//加release会报错
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
