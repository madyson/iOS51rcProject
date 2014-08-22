//
//  FindPsdStep3ViewController.m
//  iOS51rcProject
//
//  Created by qlrc on 14-8-15.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import "FindPsdStep3ViewController.h"
#import "Dialog.h"
#import "CommonController.h"
#import "NetWebServiceRequest.h"
#import "GDataXMLNode.h"
#import <UIKit/UIKit.h>
#import "LoadingAnimationView.h"

@interface FindPsdStep3ViewController ()
@property (retain, nonatomic) IBOutlet UITextField *txtUserName;
@property (retain, nonatomic) IBOutlet UITextField *txtPsd;
@property (retain, nonatomic) IBOutlet UITextField *txtRePsd;
@property (nonatomic, retain) NetWebServiceRequest *runningRequest;
@property (retain, nonatomic) IBOutlet UIButton *btnOK;
@property (retain, nonatomic) LoadingAnimationView *loadingView;
@end

@implementation FindPsdStep3ViewController

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
    
    UIButton *button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [button setTitle: @"重置密码" forState: UIControlStateNormal];
    [button sizeToFit];
    self.navigationItem.titleView = button;
    
    self.txtUserName.text = self.userName;
    //自定义从下一个视图左上角，“返回”本视图的按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"后退" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem=backButton;
    self.btnOK.layer.cornerRadius = 5;
    self.btnOK.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:90/255.0 blue:39/255.0 alpha:1].CGColor;
}

//隐藏键盘
-(IBAction)textFiledReturnEditing:(id)sender {
    [sender resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)btnResetPsd:(id)sender {
    self.userName=self.txtUserName.text;
    NSString *passWord= self.txtPsd.text;
    NSString *rePassord=self.txtRePsd.text;
    
    BOOL result = [self checkInput:self.userName Password:passWord RePassword:rePassord];
    if (!result) {
        return;
    }
    
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    [dicParam setObject:self.paMainID forKey:@"PaMainID"];
    [dicParam setObject:passWord forKey:@"Password"];
    [dicParam setObject:@"IOS" forKey:@"ip"];
    [dicParam setObject:@"" forKey:@"Code"];
    
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:@"ResetPassword" Params:dicParam];
    
    [request startAsynchronous];
    [request setDelegate:self];
    self.runningRequest = request;

    //缓冲界面
    self.loadingView = [[LoadingAnimationView alloc] initWithFrame:CGRectMake(140, 100, 80, 98) loadingAnimationViewStyle:LoadingAnimationViewStyleCarton target:self];
    [self.loadingView startAnimating];
}

//失败
- (void)netRequestFailed:(NetWebServiceRequest *)request didRequestError:(int *)error
{
    [self.loadingView stopAnimating];
    [Dialog alert:@"出现意外错误"];
    return;
}

//成功
- (void)netRequestFinished:(NetWebServiceRequest *)request
      finishedInfoToResult:(NSString *)result
              responseData:(NSArray *)requestData
{
    [self.loadingView stopAnimating];
    if([result isEqualToString:@"-3"] || [result isEqualToString:@""])
    {
        [Dialog alert:@"提交错误，请检查您的网络链接，并稍后重试……"];
        return ;
    }
    else if([result isEqualToString:@"0"])
    {
        [Dialog alert:@"修改失败，信息已经过期... ..."];
        return;
    }
    else if([result intValue] > 0)
    {
        [Dialog alert:@"修改成功"];
        return;
//            NSString *temp = @"激活码将发送到您的手机";
//            temp =[temp stringByAppendingString:self.phone];
//            temp = [temp stringByAppendingString:@"，请注意查收！"];
//            [Dialog alert:temp];
//            //[temp release];
//            
//            FindPsdStep2ViewController *find2Ctr = [self.storyboard instantiateViewControllerWithIdentifier: @"findPsd2View"];
//            find2Ctr.code = code;
//            find2Ctr.type = @"2";
//            find2Ctr.name = self.phone;
//            [self.navigationController pushViewController:find2Ctr animated:YES];
            //[find2Ctr release];
        
    }
    else
    {
        [Dialog alert:@"未知错误"];
        return;
    }
    
    [result retain];
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
- (BOOL)checkInput:(NSString *)userName Password:(NSString*) passWord RePassword:(NSString*) rePsd
{
    BOOL result = true;
    
    if(userName==nil||[userName isEqualToString:@""]){
        //提示输入信息
        [Dialog alert:@"请输入邮箱"];
        result = false;
    }
    if(passWord==nil
       ||[passWord isEqualToString:@""]){
        
        [Dialog alert:@"请输入密码"];
        result = false;
    }
    if([self.userName length]>50){
        
        [Dialog alert:@"邮箱长度不能超过50位"];
        result = false;
    }
    
    if (![[CommonController alloc] checkEmail:self.userName]) {
        [Dialog alert:@"邮箱格式不正确"];
        result = false;
    }
    if(![rePsd isEqualToString:passWord]){
        if(rePsd==nil||[rePsd length]==0){
            [Dialog alert:@"重复密码不能为空"];
            result = false;
        }else{
            [Dialog alert:@"两次密码输入不一致"];
            result = false;
        }
    }
    
    if([passWord length]<6|| [passWord length]>20){
        [Dialog alert:@"密码长度为6-20！"];
        result = false;
    }
    
    if (![CommonController checkPassword:passWord]) {
        [Dialog alert:@"密码只能使用字母、数字、横线、下划线、点"];
        result = false;
    }
    return result;
}

- (void)dealloc {
    [_txtUserName release];
    [_txtPsd release];
    [_txtRePsd release];
    [_txtUserName release];
    [_txtPsd release];
    [_txtRePsd release];
    [_btnOK release];
    [super dealloc];
}
@end
