//
//  RegisterViewController.m
//  iOS51rcProject
//
//  Created by qlrc on 14-8-15.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import "RegisterViewController.h"
#import "Dialog.h"
#import "CommonController.h"
#import "NetWebServiceRequest.h"
#import "GDataXMLNode.h"
#import <UIKit/UIKit.h>

#define TAG_DEV 1
#define TAG_RESUME 2

@interface RegisterViewController ()
@property (retain, nonatomic) IBOutlet UITextField *txtUserName;
@property (retain, nonatomic) IBOutlet UITextField *txtPsd;
@property (retain, nonatomic) IBOutlet UITextField *txtRePsd;
@property (nonatomic, retain) NetWebServiceRequest *runningRequest;
@end

@implementation RegisterViewController

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
//    // Do any additional setup after loading the view.
//    [[CXAlertView appearance] setTitleFont:[UIFont boldSystemFontOfSize:18.]];
//    [[CXAlertView appearance] setTitleColor:[UIColor orangeColor]];
//    [[CXAlertView appearance] setCornerRadius:12];
//    [[CXAlertView appearance] setShadowRadius:20];
//    [[CXAlertView appearance] setButtonColor:[UIColor colorWithRed:0.039 green:0.380 blue:0.992 alpha:1.000]];
//    [[CXAlertView appearance] setCancelButtonColor:[UIColor colorWithRed:0.047 green:0.337 blue:1.000 alpha:1.000]];
//    [[CXAlertView appearance] setCustomButtonColor:[UIColor orangeColor]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnRegisterClick:(id)sender {
    
    //CreateResumeAlertViewController *alertCtrl =[[CreateResumeAlertViewController alloc] init];
    //测试
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"帐号已经注册成功，立即创建简历？。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定", nil] ;
    [alert show];
    alert.tag = TAG_DEV;
    
    userName=self.txtUserName.text;
    password= self.txtPsd.text;
    rePassword=self.txtRePsd.text;
    
    //检查参数
    BOOL result = [self checkInput:userName Password:password RePassword:rePassword];
    if (!result) {
        return;
    }
    else{
        
        NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
        [dicParam setObject:userName forKey:@"email"];
        [dicParam setObject:password forKey:@"password"];
        [dicParam setObject:@"32" forKey:@"provinceid"];
        [dicParam setObject:@"6" forKey:@"registermod"];
        [dicParam setObject:@"IOS" forKey:@"ip"];
        
        NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:@"Register" Params:dicParam];
        [request startAsynchronous];
        [request setDelegate:self];
        self.runningRequest = request;
        wsName = @"Register";
    }
}

//失败
- (void)netRequestFailed:(NetWebServiceRequest *)request didRequestError:(int *)error
{
    [Dialog alert:@"出现意外错误"];
    return;
}

//成功
- (void)netRequestFinished:(NetWebServiceRequest *)request
      finishedInfoToResult:(NSString *)result
              responseData:(NSArray *)requestData
{
    if ([wsName isEqual: @"Register"])
    {
        [self didReceiveRegisterData:result];
    }
    else if ([wsName isEqualToString:@"GetPaAddDate"])
    {
        [self didReceiveGetCode:result];
    }
    
    [result retain];
}

-(void) didReceiveRegisterData:(NSString *) result
{
    NSInteger intResult = [result intValue];
    if(intResult == -1)
    {
        [Dialog alert:@"您的电子邮箱已被我们列入黑名单，不再接受注册。如果您有任何疑问，请拨打全国统一客服电话400 626 5151寻求帮助。"];
        return ;
    }
    else if(intResult == -2)
    {
        [Dialog alert:@"您已经使用当前的E-mail注册过一个用户，建议您不要重复注册。"];
        return;
    }
    else if(intResult == -3)
    {
        [Dialog alert:@"用户注册失败！向保存用户信息时数据操作失败！"];
        return;
    }
    else if(intResult == -4)
    {
        [Dialog alert:@"提交错误，请检查您的网络链接，并稍后重试……"];
        return;
    }
    else if(intResult == 0)
    {
        [Dialog alert:@"用户名或密码错误，请重新输入！"];
        return;
    }
    else if(intResult > 0)
    {
        userID = result;
        [self getCode: userID];//获取code
    }
    else
    {
        [Dialog alert:@"未知错误"];
        return;
    }
}


//获取code
-(void) getCode:(NSString*) paMainID
{
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    [dicParam setObject:paMainID forKey:@"paMainID"];
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:@"GetPaAddDate" Params:dicParam];
    
    [request startAsynchronous];
    [request setDelegate:self];
    self.runningRequest = request;
    wsName = @"GetPaAddDate";
}

-(void) didReceiveGetCode:(NSString *) result
{
    NSString *realCode=@"";
    realCode =
    [realCode stringByAppendingFormat:@"%@%@%@%@%@",[result substringWithRange:NSMakeRange(11,2)],
     [result substringWithRange:NSMakeRange(0,4)],[result substringWithRange:NSMakeRange(14,2)],
     [result substringWithRange:NSMakeRange(8,2)],[result substringWithRange:NSMakeRange(5,2)]];
    //NSLog(result);
    //NSString *name = [result substringWithRange:NSMakeRange(0,4)];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue: userID forKey:@"UserID"];
    [userDefaults setValue: userName forKey:@"UserName"];
    [userDefaults setValue: password forKey:@"PassWord"];
    //[userDefaults setValue: name forKey:@"name"];
    [userDefaults setValue: @"1" forKey:@"BeLogined"];
    [userDefaults setValue:isAutoLogin forKey:@"isAutoLogin"];
    [userDefaults setObject:realCode forKey:@"code"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"帐号已经注册成功，立即创建简历？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定", nil] ;
    alert.tag = TAG_DEV;
    [alert show];
}

//注册成功后
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == TAG_DEV) {
        if (buttonIndex == 0) {//取消，直接返回首页
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else {
            UIAlertView *alertResume = [[UIAlertView alloc] initWithTitle:@"您有没有工作经历" message:nil delegate:self cancelButtonTitle:@"有工作经历" otherButtonTitles: @"没有工作经历", nil] ;
            alertResume.tag = TAG_RESUME;
            [alertResume show];
        }
    }
    else if (alertView.tag == TAG_RESUME){
        if (buttonIndex == 0) {//有工作经历
            //[self.navigationController popToRootViewControllerAnimated:YES];
        }
        else {
            
        }
    }
}
- (BOOL)checkInput:(NSString *)userName Password:(NSString*) passWord RePassword:(NSString*) rePsd
{
    BOOL result = true;
    if(userName==nil||[userName isEqualToString:@""]){
        //提示输入信息
        [Dialog alert:@"请输入邮箱"];
        result = false;
    }
    else if(passWord==nil
       ||[passWord isEqualToString:@""]){
        
        [Dialog alert:@"请输入密码"];
        result = false;
    }
    else if([userName length]>50){
        
        [Dialog alert:@"邮箱长度不能超过50位"];
        result = false;
    }
    
    else if (![[CommonController alloc] checkEmail:userName]) {
        [Dialog alert:@"邮箱格式不正确"];
        result = false;
    }
    else if(![rePsd isEqualToString:passWord]){
        if(rePsd==nil||[rePsd length]==0){
            [Dialog alert:@"重复密码不能为空"];
            result = false;
        }else{
            [Dialog alert:@"两次密码输入不一致"];
            result = false;
        }
    }
    else if([passWord length]<6|| [passWord length]>20){
        [Dialog alert:@"密码长度为6-20！"];
        result = false;
    }
    else if (![CommonController checkPassword:passWord]) {
        [Dialog alert:@"密码只能使用字母、数字、横线、下划线、点"];
        result = false;
    }
    return result;
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
    [_txtUserName release];
    [_txtPsd release];
    [_txtRePsd release];
    [super dealloc];
}
@end
