//
//  FindPsdStep1ViewController.m
//  iOS51rcProject
//
//  Created by qlrc on 14-8-15.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import "FindPsdStep1ViewController.h"
#import "Dialog.h"
#import "CommonController.h"
#import "NetWebServiceRequest.h"
#import "GDataXMLNode.h"
#import <UIKit/UIKit.h>
#import "FindPsdStep2ViewController.h"

@interface FindPsdStep1ViewController ()
@property (retain, nonatomic) IBOutlet UITextField *txtName;
@property (nonatomic, retain) NetWebServiceRequest *runningRequest;
@end

@implementation FindPsdStep1ViewController

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
    [button setTitle: @"找回密码" forState: UIControlStateNormal];
    [button sizeToFit];
    self.navigationItem.titleView = button;
   
    //自定义从下一个视图左上角，“返回”本视图的按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"后退" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem=backButton;
}

//发送验证码
- (IBAction)btnGetCode:(id)sender {
    if(self.txtName.text==nil||[self.txtName.text isEqualToString:@""]){
        //提示输入信息
        [Dialog alert:@"请输入用户名或邮箱或手机号"];
        return;
    }

    NSString *userName = @"";
    self.phone = @"";
    CommonController *commonCtrl = [[CommonController alloc] init];
    if([commonCtrl isMobileNumber:self.txtName.text])
    {
        self.phone = self.txtName.text;
    }
    else{
        userName = self.txtName.text;
    }

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *provinceID=[defaults stringForKey:@"provinceID"];
    provinceID = @"32";
    
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    [dicParam setObject:userName forKey:@"userName"];
    [dicParam setObject:userName forKey:@"email"];
    [dicParam setObject:self.phone forKey:@"mobile"];
    [dicParam setObject:@"" forKey:@"ip"];
    [dicParam setObject:@"" forKey:@"strPageHost"];
    [dicParam setObject:@"" forKey:@"subsiteName"];
    [dicParam setObject:provinceID forKey:@"provinceID"];
    
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:@"paGetPassword" Params:dicParam];
    
    [request startAsynchronous];
    [request setDelegate:self];
    self.runningRequest = request;
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
    
    if([result isEqualToString:@"1"])
    {
        [Dialog alert:@"一个账号一天取回超过5次"];
        return ;
    }
    else if([result isEqualToString:@"2"])
    {
        [Dialog alert:@"一个ip一天取回超过20次"];
        return;
    }
    else if([result isEqualToString:@"3"])
    {
        [Dialog alert:@"手机号码或邮箱格式不正确，请检查！"];
        return;
    }
    else if([result isEqualToString:@"4"])
    {
        [Dialog alert:@"机号一天取回超过3次"];
        return;
    }
    else if([result isEqualToString:@""])
    {
        [Dialog alert:@"错误，请检查您的网络链接，并稍后重试⋯⋯"];
        return;
    }
    else if([result isEqualToString:@"-1"])
    {
        [Dialog alert:@"提供数据无效，请重新检查输入"];
        return;
    }
    else
    {
        NSRange range = [result rangeOfString:@":"];
        NSString *getWay = [result substringToIndex:range.location];
        NSString *code = [result substringFromIndex:range.location+1];
        range = [code rangeOfString:@":"];
        NSString *email = @"";
        if(range.location!=NSNotFound)
        {
            range = [code rangeOfString:@":"];
            email = [code substringFromIndex:range.location+1];
            code = [code substringToIndex:range.location];
        }
        if([getWay isEqualToString:@"100"])
        {
            NSString *temp = @"激活码已经发送到您的邮箱";
            temp =[temp stringByAppendingString:email];
            temp = [temp stringByAppendingString:@"，请注意查收！"];
            [Dialog alert:temp];
            //[temp release];
            //转到下一个视图
            //FindPsdStep2ViewController *find2Ctr = [[FindPsdStep2ViewController alloc] init];//这种方法不能找到
            FindPsdStep2ViewController *find2Ctr = [self.storyboard instantiateViewControllerWithIdentifier: @"findPsd2View"];
            find2Ctr.code = code;
            find2Ctr.type = @"1";
            find2Ctr.name = self.txtName.text;
            [self.navigationController pushViewController:find2Ctr animated:YES];
            //[find2Ctr release];
        }
        else
        {
            NSString *temp = @"激活码将发送到您的手机";
            temp =[temp stringByAppendingString:self.phone];
            temp = [temp stringByAppendingString:@"，请注意查收！"];
            [Dialog alert:temp];
            //[temp release];
            
            FindPsdStep2ViewController *find2Ctr = [self.storyboard instantiateViewControllerWithIdentifier: @"findPsd2View"];
            find2Ctr.code = code;
            find2Ctr.type = @"2";
            find2Ctr.name = self.txtName.text;
            [self.navigationController pushViewController:find2Ctr animated:YES];
            //[find2Ctr release];
        }
    }
    
    [result retain];
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
    [_txtName release];
    [super dealloc];
}
@end
