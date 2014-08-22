//
//  LoginDetailsViewController.m
//  iOS51rcProject
//
//  Created by qlrc on 14-8-15.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import "LoginDetailsViewController.h"
#import "FindPsdStep1ViewController.h"
#import "NetWebServiceRequest.h"
#import "GDataXMLNode.h"
#import "CommonController.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LoginDetailsViewController ()
@property (retain, nonatomic) IBOutlet UITextField *txtName;
@property (retain, nonatomic) IBOutlet UITextField *txtPsd;
@property (nonatomic, retain) NetWebServiceRequest *runningRequest;
@property (retain, nonatomic) IBOutlet UILabel *labelNameBg;
@property (retain, nonatomic) IBOutlet UIButton *btnLogin;
@property (retain, nonatomic) IBOutlet UILabel *labelLine;
@property (retain, nonatomic) IBOutlet UIImageView *imgAutoLogin;
@property (retain, nonatomic) IBOutlet UIButton *btnAutoLogin;
@end


@implementation LoginDetailsViewController
@synthesize delegate;
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
    self.txtName.layer.borderWidth = 1;
    self.txtName.layer.borderColor = [UIColor whiteColor].CGColor;
    self.txtPsd.layer.borderWidth = 1;
    self.txtPsd.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.labelNameBg.layer.borderWidth = 0.3;
    self.labelNameBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.labelNameBg.layer.cornerRadius = 5;
    
    self.btnLogin.layer.cornerRadius = 5;
    self.btnLogin.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:90/255.0 blue:39/255.0 alpha:1].CGColor;
    
    self.labelLine.layer.borderWidth = 0.15;
    self.labelLine.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.labelLine setFrame:CGRectMake(24, 76.5, 273, 0.5)];
    isAutoLogin = true;
}
- (IBAction)btnAutoLoginClick:(id)sender {
    isAutoLogin = !isAutoLogin;
    if (isAutoLogin) {
        self.imgAutoLogin.image = [UIImage imageNamed:@"unChecked.png" ];
    }else{
        self.imgAutoLogin.image = [UIImage imageNamed:@"checked.png"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnLoginClick:(id)sender {
    userName = self.txtName.text;
    passWord = self.txtPsd.text;
    if (userName == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请输入用户名" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
        [alert show];
    }
    if (passWord == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请输入密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
        [alert show];
    }
    
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    [dicParam setObject:userName forKey:@"userName"];
    [dicParam setObject:passWord forKey:@"passWord"];
    [dicParam setObject:@"IOS" forKey:@"ip"];
    [dicParam setObject:@"32" forKey:@"provinceID"];
    [dicParam setObject:@"ismobile:Android" forKey:@"browser"];
    [dicParam setObject:@"0" forKey:@"autoLogin"];
    
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:@"Login" Params:dicParam];
    
    [request startAsynchronous];
    [request setDelegate:self];
    self.runningRequest = request;
    wsName = @"login";
}

- (IBAction)btnFindPsd:(id)sender {
    [delegate pushParentsFromLoginDetails];//调用父界面的函数
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

//失败
- (void)netRequestFailed:(NetWebServiceRequest *)request didRequestError:(int *)error
{
    
}

//成功
- (void)netRequestFinished:(NetWebServiceRequest *)request
      finishedInfoToResult:(NSString *)result
              responseData:(NSArray *)requestData
{
    if ([wsName isEqual: @"login"]) {
        [result retain];
        [self didReceiveLoginData:result];
    }
    else if ([wsName isEqual: @"GetPaAddDate"]){
        //NSLog(@"login response");
        [result retain];
        [self didReceiveGetCodeData: result];
        //didReceiveGetCodeData(requestData);
    }
    //recruitmentData = requestData;
    //[recruitmentData retain];
    //[self.tvRecruitmentList reloadData];
}

//接收到登录webservice内容
-(void) didReceiveLoginData:(NSString*) result
{
   // NSLog(result);//
    if ([result isEqual:@"-1"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您今天的登录次数已超过20次的限制，请明天再来。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
        [alert show];
    } else if ([result isEqual:@"-2"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请进入用户反馈向我们反映，谢谢配合。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
        [alert show];
    }else if ([result isEqual:@"-3"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"提交错误，请检查您的网络链接，并稍后重试……" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
        [alert show];
    }else if ([result isEqual:@"0"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"用户名或密码错误，请重新输入！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
        [alert show];
    }else if (result > 0){
        userID = result;
        [self getCode:result];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您今天的登录次数已超过20次的限制，请明天再来。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
        [alert show];
    }
}

-(void) didReceiveGetCodeData:(NSString*) result
{
    NSString *realCode=@"";
    realCode =
    [realCode stringByAppendingFormat:@"%@%@%@%@%@",[result substringWithRange:NSMakeRange(11,2)],
    [result substringWithRange:NSMakeRange(0,4)],[result substringWithRange:NSMakeRange(14,2)],
    [result substringWithRange:NSMakeRange(8,2)],[result substringWithRange:NSMakeRange(5,2)]];
   
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue: userID forKey:@"UserID"];//PamainID
    [userDefaults setValue: userName forKey:@"UserName"];
    [userDefaults setValue: passWord forKey:@"PassWord"];    
    [userDefaults setValue: @"1" forKey:@"BeLogined"];
    [userDefaults setBool: isAutoLogin forKey:@"isAutoLogin"];
    [userDefaults setObject:realCode forKey:@"code"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"登录成功。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
    [alert show];
}

//从webservice获取code
-(void) getCode:(NSString* ) userID
{
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    [dicParam setObject:userID forKey:@"paMainID"];
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:@"GetPaAddDate" Params:dicParam];
    
    [request startAsynchronous];
    [request setDelegate:self];
    self.runningRequest = request;
    wsName = @"GetPaAddDate";
}

- (void)dealloc {
    [_txtName release];
    [_txtPsd release];
    [_labelNameBg release];   
    [_btnLogin release];
    [_labelLine release];
    [_imgAutoLogin release];
    [_btnAutoLogin release];
    [super dealloc];
}
@end
