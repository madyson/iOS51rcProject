//
//  JobViewController.m
//  iOS51rcProject
//
//  Created by qlrc on 14-8-25.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import "JobViewController.h"
#import "NetWebServiceRequest.h"
#import "LoadingAnimationView.h"
#import "CommonController.h"

@interface JobViewController ()<NetWebServiceRequestDelegate,UIScrollViewDelegate>
@property (retain, nonatomic) IBOutlet UIScrollView *jobMainScroll;
@property (retain, nonatomic) IBOutlet UILabel *lbJobName;
@property (retain, nonatomic) IBOutlet UILabel *lbFereashTime;
@property (retain, nonatomic) IBOutlet UILabel *lbCpName;
@property (retain, nonatomic) IBOutlet UILabel *lbCpNameValue;
@property (retain, nonatomic) IBOutlet UILabel *lbWorkPlace;
@property (retain, nonatomic) IBOutlet UILabel *lbWorkPlaceValue;
@property (retain, nonatomic) IBOutlet UILabel *lbJobRequest;
@property (retain, nonatomic) IBOutlet UILabel *lbJobRequestValue;
@property (retain, nonatomic) IBOutlet UILabel *lbSalary;
@property (retain, nonatomic) IBOutlet UILabel *lbSpitLine2;
@property (retain, nonatomic) IBOutlet UILabel *lbSpitLine3;
@property (retain, nonatomic) IBOutlet UILabel *lbCaName;
@property (retain, nonatomic) IBOutlet UILabel *lbCaTitle;

@property (retain, nonatomic) IBOutlet UILabel *lbDept;
@property (retain, nonatomic) IBOutlet UILabel *lbDeptValue;
@property (retain, nonatomic) IBOutlet UILabel *lbCaTel;
@property (retain, nonatomic) IBOutlet UILabel *lbCaTelValue;
@property (retain, nonatomic) IBOutlet UILabel *lbResponsibility;
@property (retain, nonatomic) IBOutlet UILabel *lbDemand;

@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UILabel *lbResponsibilityInput;
@property (retain, nonatomic) IBOutlet UILabel *lbDemandInput;
@property (retain, nonatomic) IBOutlet UILabel *lbCaNameValue;

@property (retain, nonatomic) IBOutlet UILabel *lbCaTitleValue;


@property (nonatomic, retain) NetWebServiceRequest *runningRequest;
@property (nonatomic, retain) LoadingAnimationView *loading;
@property (retain, nonatomic) NSString *wsName;//当前调用的webservice名称
@end

@implementation JobViewController

@synthesize runningRequest = _runningRequest;
@synthesize loading = _loading;
@synthesize JobID;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidScroll......");
}

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
    //NSLog(@"%@",self.recruitmentID);
//    self.btnRmCp.layer.masksToBounds = YES;
//    self.btnRmCp.layer.borderWidth = 1.0;
//    self.btnRmCp.layer.borderColor = [[UIColor grayColor] CGColor];
//    
//    self.btnRmPa.layer.masksToBounds = YES;
//    self.btnRmPa.layer.borderWidth = 1.0;
//    self.btnRmPa.layer.borderColor = [[UIColor grayColor] CGColor];
    
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    [dicParam setObject:self.JobID forKey:@"JobID"];
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:@"GetJobInfo" Params:dicParam];
    [request setDelegate:self];
    [request startAsynchronous];
    self.runningRequest = request;
    self.wsName = @"GetJobInfo";//当前调用的函数名称
    self.loading = [[LoadingAnimationView alloc] initWithFrame:CGRectMake(140, 100, 80, 98) loadingAnimationViewStyle:LoadingAnimationViewStyleCarton target:self];
    [self.loading startAnimating];
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

- (void)netRequestFinished:(NetWebServiceRequest *)request
      finishedInfoToResult:(NSString *)result
              responseData:(NSArray *)requestData
{
    if ([self.wsName isEqualToString:@"GetJobInfo"]) {
        [self didReceiveJobMain:requestData];
    }
}

-(void) didReceiveJobMain:(NSArray *) requestData
{
    float fltHeight = 235;
    
    NSDictionary *dicJob = requestData[0];
    //职位名称
    NSString *jobName = dicJob[@"Name"];
    CGSize labelSize = [CommonController CalculateFrame:jobName fontDemond:[UIFont systemFontOfSize:16] sizeDemand:CGSizeMake(self.lbJobName.frame.size.width, 500)];
    self.lbJobName.frame = CGRectMake(self.lbJobName.frame.origin.x, self.lbJobName.frame.origin.y, labelSize.width, labelSize.height);
    self.lbJobName.lineBreakMode = NSLineBreakByCharWrapping;
    self.lbJobName.numberOfLines = 0;
    [self.lbJobName setText:jobName];
    //刷新时间
    self.lbFereashTime.textColor = [UIColor grayColor];
    NSDate *refreshDate = [CommonController dateFromString:dicJob[@"RefreshDate"]];
    NSString *strRefreshDate = [CommonController stringFromDate:refreshDate formatType:@"MM-dd HH:mm"];
    [self.lbFereashTime setText:[NSString stringWithFormat:@"刷新时间：%@", strRefreshDate]];
    //待遇
    NSString *strSalary = dicJob[@"Salary"];
    self.lbSalary.text = strSalary;
    //公司名称
    self.lbCpName.textColor = [UIColor grayColor];
    [self.lbCpNameValue setText:dicJob[@"cpName"]];
    //工作地点
    self.lbWorkPlace.textColor = [UIColor grayColor];
    [self.lbWorkPlaceValue setText:dicJob[@"JobRegion"]];
    //招聘人数
    NSString *num = dicJob[@"NeedNumber"];
    //学历
    NSString *education = dicJob[@"Education"];
    //年龄
    NSString *minAge = dicJob[@"MinAge"];
    NSString *maxAge = dicJob[@"MaxAge"];
    //经验
    NSString *experience = dicJob[@"Experience"];
    //全职与否
    NSString *employType = dicJob[@"EmployType"];
    //招聘条件
    self.lbJobRequest.textColor = [UIColor grayColor];
    self.lbJobRequestValue.text = [NSString stringWithFormat:@"%@|%@|%@-%@|%@|%@", num, education, minAge, maxAge, experience, employType];
    //岗位职责------hight = 166
    self.lbResponsibility.textColor = [UIColor grayColor];
    self.lbResponsibility.frame = CGRectMake(20, self.lbJobRequestValue.frame.origin.y + self.lbJobRequest.frame.size.height - 5, 200, 40);
    NSString *strResponsibility = dicJob[@"Responsibility"];
    labelSize = [CommonController CalculateFrame:strResponsibility fontDemond:[UIFont systemFontOfSize:12] sizeDemand:CGSizeMake(280, 500)];
    self.lbResponsibilityInput.frame = CGRectMake(20, self.lbResponsibility.frame.origin.y + self.lbResponsibility.frame.size.height - 8, labelSize.width, labelSize.height);
    self.lbResponsibilityInput.lineBreakMode = NSLineBreakByCharWrapping;
    self.lbResponsibilityInput.numberOfLines = 0;
    self.lbResponsibilityInput.text = strResponsibility;
    
    //岗位要求
    self.lbDemand.textColor = [UIColor grayColor];
    self.lbDemand.frame = CGRectMake(20, self.lbResponsibilityInput.frame.origin.y+self.lbResponsibilityInput.frame.size.height -5, 200, 40);
    NSString *strDemand = dicJob[@"Demand"];
    labelSize = [CommonController CalculateFrame:strDemand fontDemond:[UIFont systemFontOfSize:12] sizeDemand:CGSizeMake(280, 500)];
    self.lbDemandInput.frame = CGRectMake(20, self.lbDemand.frame.origin.y+self.lbDemand.frame.size.height - 8, labelSize.width, labelSize.height);
    self.lbDemandInput.lineBreakMode = NSLineBreakByCharWrapping;
    self.lbDemandInput.numberOfLines = 0;
    self.lbDemandInput.text = strDemand;
    
    //第二个分割线
    CGFloat y = self.lbDemandInput.frame.origin.y + self.lbDemandInput.frame.size.height - 23;
    self.lbSpitLine2.frame = CGRectMake(8, y + 40, 304, 0.5);
    
    //联系人
    self.lbCaName.textColor = [UIColor grayColor];
    self.lbCaName.frame = CGRectMake(20, self.lbSpitLine2.frame.origin.y + 5, 64, 40);
    self.lbCaNameValue.frame = CGRectMake(64, self.lbSpitLine2.frame.origin.y + 5, 200, 40);
    NSString *strCaName = dicJob[@"caName"];
    self.lbCaNameValue.text = strCaName;
    
    //职务
    self.lbCaTitle.textColor = [UIColor grayColor];
    self.lbCaTitle.frame = CGRectMake(20, self.lbCaName.frame.origin.y+self.lbCaName.frame.size.height - 5, 64, 40);
    self.lbCaNameValue.frame = CGRectMake(64, self.lbCaName.frame.origin.y+self.lbCaName.frame.size.height - 5, 200, 40);
    self.lbCaNameValue.text = dicJob[@"caTitle"];
    
    //所在部门
    self.lbDept.textColor = [UIColor grayColor];
    self.lbDept.frame = CGRectMake(20, self.lbCaTitle.frame.origin.y+self.lbCaTitle.frame.size.height - 5, 64, 40);
    self.lbDeptValue.frame = CGRectMake(64, self.lbCaTitle.frame.origin.y+self.lbCaTitle.frame.size.height -5 , 200, 40);
    self.lbDeptValue.text = dicJob[@"caDept"];
    
    //联系电话
    self.lbCaTel.textColor = [UIColor grayColor];
    self.lbCaTel.frame = CGRectMake(20, self.lbDept.frame.origin.y+self.lbDept.frame.size.height - 5, 64, 40);
    self.lbCaTelValue.frame = CGRectMake(64, self.lbDept.frame.origin.y+self.lbDept.frame.size.height - 5, 200, 40);
    self.lbCaTelValue.text = dicJob[@"caTel"];
    
    self.jobMainScroll.frame = CGRectMake(self.jobMainScroll.frame.origin.x, self.jobMainScroll.frame.origin.y, self.jobMainScroll.frame.size.width, self.jobMainScroll.frame.size.height-50);
    [self.jobMainScroll setContentSize:CGSizeMake(320, fltHeight+20)];
    [self.loading stopAnimating];
}

- (void)call:(UIButton *)sender {
    NSString *strCallNumber;
    if (sender.tag == 1) {
        //strCallNumber = self.recruitmentMobile;
    }
    else {
        //strCallNumber = self.recruitmentTelephone;
    }
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",strCallNumber]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    [self.view addSubview:callWebview];
}

- (void)dealloc {
    //[_nibName release];
    [_lbFereashTime release];
    [_wsName release];
    [_lbWorkPlaceValue release];
    [_lbJobRequestValue release];
    [_lbSalary release];
    [_lbSpitLine2 release];
    [_lbSpitLine3 release];
    [_lbResponsibility release];
    [_lbDemand release];
    [_lbCaName release];
    [_lbCaTitle release];

    [_lbDept release];
    [_lbDeptValue release];
    [_lbCaTel release];
    [_lbCaTelValue release];
    
    [_jobMainScroll release];
    [_lbCpName release];
    [_lbWorkPlace release];
    [_lbJobRequest release];
    [_contentView release];
    [_lbResponsibilityInput release];
    [_lbDemandInput release];
    [_lbCaNameValue release];
    [_lbCaTitleValue release];
    [super dealloc];
}
@end
