//
//  MyRecruitmentViewController.m
//  iOS51rcProject
//
//  Created by qlrc on 14-8-27.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import "MyRecruitmentViewController.h"
#import "RecruitmentViewController.h"
#import "MyRmInviteCpListViewController.h"

@interface MyRecruitmentViewController ()
@property (retain, nonatomic) IBOutlet UILabel *lbBgLeft;
@property (retain, nonatomic) IBOutlet UILabel *lbBgRight;
@property (retain, nonatomic) IBOutlet UIButton *btnInvitation;
@property (retain, nonatomic) IBOutlet UIButton *btnMyRm;

@end

@implementation MyRecruitmentViewController

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
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.origin.y = 106;//状态栏和切换栏的高度
    frame.size.height = frame.size.height - 106;
    //获得子View
    self.myRmCpListViewCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"MyRmCpListView"];
    self.myRmInvitationViewCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"MyRmInvitationView"];
    self.myRmCpListViewCtrl.view.frame = frame;
    self.myRmInvitationViewCtrl.view.frame = frame;
    
    //初始化左侧和右侧的登录以及注册子View
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    self.myRmCpListViewCtrl.gotoRmViewDelegate = self;
    self.myRmCpListViewCtrl.gotoMyInvitedCpViewDelegate = self;
    //self.myRmInvitationViewCtrl.gotoHomeDelegate = self;
    
    //默认加载登录页面
    [self.view addSubview: self.myRmCpListViewCtrl.view];
}

//从我的预约页面到招聘会详情页面
-(void) gotoRmView:(NSString *) rmID
{
    RecruitmentViewController *rmViewCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"RecruitmentView"];
    rmViewCtrl.recruitmentID = rmID;
    [self.navigationController pushViewController:rmViewCtrl animated:true];
}

//从我的预约页面到我邀请的企业页面
-(void) GoToMyInvitedCpView:(NSString *) paMainID
{
    MyRmInviteCpListViewController *rmViewCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"MyRmInviteCpListView"];
    [self.navigationController pushViewController:rmViewCtrl animated:true];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.myRmCpListViewCtrl removeFromParentViewController];
        [self.view addSubview:self.myRmInvitationViewCtrl.view];
        //self.navigationItem.title = @"登录";
        self.lbBgRight.backgroundColor = [UIColor clearColor];
        self.lbBgLeft.backgroundColor = [UIColor orangeColor];
        self.btnMyRm.titleLabel.textColor = [UIColor orangeColor];
        self.btnInvitation.titleLabel.textColor = [UIColor blackColor];
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self.myRmInvitationViewCtrl removeFromParentViewController];
        [self.view addSubview:self.myRmCpListViewCtrl.view];
        //self.navigationItem.title = @"注册";
        self.lbBgRight.backgroundColor = [UIColor orangeColor];
        self.lbBgLeft.backgroundColor = [UIColor clearColor];
        self.btnMyRm.titleLabel.textColor = [UIColor blackColor];
        self.btnInvitation.titleLabel.textColor = [UIColor orangeColor];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnLeftClick:(id)sender {
    [self.myRmInvitationViewCtrl removeFromParentViewController];
    [self.view addSubview:self.myRmCpListViewCtrl.view];
    //self.navigationItem.title = @"登录";
    self.lbBgRight.backgroundColor = [UIColor clearColor];
    self.lbBgLeft.backgroundColor = [UIColor orangeColor];
    self.btnMyRm.titleLabel.textColor = [UIColor orangeColor];
    self.btnInvitation.titleLabel.textColor = [UIColor blackColor];
}

- (IBAction)btnRightClick:(id)sender {
    [self.myRmCpListViewCtrl removeFromParentViewController];
    [self.view addSubview:self.myRmInvitationViewCtrl.view];
    //self.navigationItem.title = @"注册";
    self.lbBgRight.backgroundColor = [UIColor orangeColor];
    self.lbBgLeft.backgroundColor = [UIColor clearColor];
    self.btnMyRm.titleLabel.textColor = [UIColor blackColor];
    self.btnInvitation.titleLabel.textColor = [UIColor orangeColor];
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
    [_lbBgLeft release];
    [_lbBgRight release];
    [_btnInvitation release];
    [_btnMyRm release];
    [super dealloc];
}
@end
