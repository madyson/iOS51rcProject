//
//  tipViewController.m
//  welcom_demo_1
//
//  Created by chaoxiao zhuang on 13-1-10.
//  Copyright (c) 2013年 taizhouxueyuan. All rights reserved.
//

#import "tipViewController.h"
#import "WelcomeUIImage.h"
//#import "Home.storyboard"

@interface tipViewController ()

@end

@implementation tipViewController


#define HEIGHT 460
#define SAWTOOTH_COUNT 10
#define SAWTOOTH_WIDTH_FACTOR 20 

@synthesize imageView;
@synthesize left = _left;
@synthesize right = _right;
@synthesize pageScroll;
@synthesize pageControl;
@synthesize gotoMainViewBtn;

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
    
    self.view.backgroundColor = [UIColor whiteColor];
        
    pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, HEIGHT)];
    pageScroll.contentSize = CGSizeMake(5*320, HEIGHT);
    pageScroll.pagingEnabled = YES;
    pageScroll.delegate = self;
    [pageScroll setShowsHorizontalScrollIndicator:NO];
    
    self.gotoMainViewBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.gotoMainViewBtn.frame = CGRectMake(110, 200, 80, 30);
    [self.gotoMainViewBtn setTitle:@"进入主页" forState:UIControlStateNormal];
    [self.gotoMainViewBtn addTarget:self action:@selector(gotoMainView:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
    }
    else {
    }
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(0, 0, 320, 568);
    //self.imageView.frame = CGRectMake(0, 0, 320, 480);
    self.imageView.image = [UIImage imageNamed:@"index640x960.png"];
    
    UIImageView * imageView1 = [[UIImageView alloc]init];
    imageView1.image = [UIImage imageNamed:@"welcom2-320x1136.png"];
    
    UIImageView * imageView2 = [[UIImageView alloc]init];
    imageView2.image = [UIImage imageNamed:@"welcom3-320x1136.png"];
    
    UIImageView * imageView3 = [[UIImageView alloc]init];
    imageView3.image = [UIImage imageNamed:@"welcom4-320x1136.png"];
    
    UIImageView * imageView4 = [[UIImageView alloc]init];
    imageView4.image = [UIImage imageNamed:@"welcom5-320x1136.png"];
    
    UIView * returnView = [[UIView alloc]init];
    returnView.backgroundColor = [UIColor redColor];
    [returnView addSubview:self.imageView];
    [returnView addSubview:self.gotoMainViewBtn];
    
    
    for(int i = 0; i < 5; ++ i )
    {
        if( i == 0 )
        {
            [pageScroll addSubview:imageView1];
            imageView1.frame = CGRectMake(i*320, 0, 320, HEIGHT);
        }
        else if( i == 1 )
        {
            [pageScroll addSubview:imageView2];
            imageView2.frame = CGRectMake(i*320, 0, 320, HEIGHT);
        }
        else if( i == 2 )
        {
            [pageScroll addSubview:imageView3];
            imageView3.frame = CGRectMake(i*320, 0, 320, HEIGHT);
        }
        else if( i == 3 )
        {
            [pageScroll addSubview:imageView4];
            imageView4.frame = CGRectMake(i*320, 0, 320, HEIGHT);
        }
        else if( i == 4 )
        {
            returnView.frame = CGRectMake(i*320, 0, 320, HEIGHT);
            [pageScroll addSubview:returnView];
        }
    }
    
    [self.view addSubview:pageScroll];
    
    
    pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(141,364,50,50);
    [pageControl setNumberOfPages:5];
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
}


-(void)animationDidStop:(NSString *)animationID finished:(NSNumber*)finished context:(void*)context
{
    if( [animationID isEqualToString:@"split"] && finished )
    {
        [self.left removeFromSuperview];
        [self.right removeFromSuperview];
        
        [pageScroll removeFromSuperview];
        
        //LogInView * logView = [[LogInView alloc] initWithNibName:@"LogInView" bundle:nil];
        //[self.view addSubview:logView.view];
        //[logView release];
        
    }
}

-(void)gotoMainView:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];

    NSArray * array = [UIImage WelcomeUIImage:self.imageView.image];
    
    self.left = [[UIImageView alloc] initWithImage:[array objectAtIndex:0]];
    self.right = [[UIImageView alloc] initWithImage:[array objectAtIndex:1]];
    [self.view addSubview:self.left];
    [self.view addSubview:self.right];
    [self.pageControl setHidden:YES];
    [self.pageScroll setHidden:YES];
    
    self.left.transform = CGAffineTransformIdentity;
    self.right.transform = CGAffineTransformIdentity;
    
    [UIView beginAnimations:@"split" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:3];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    self.left.transform = CGAffineTransformMakeTranslation(-150, 0);
    self.right.transform = CGAffineTransformMakeTranslation(150, 0);
    
    [UIView commitAnimations];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    pageControl.currentPage = offset.x/320;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    pageControl.currentPage = offset.x / 320;
}


-(void)pageTurn:(UIPageControl*)aPageControl
{
    /*
    int whichPage = aPageControl.currentPage;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2];
    pageScroll.contentOffset = CGPointMake(320*whichPage, 0);
    [UIView commitAnimations];
     */
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end





































