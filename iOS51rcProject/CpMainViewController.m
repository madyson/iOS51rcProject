//
//  CpMainViewController.m
//  iOS51rcProject
//
//  Created by qlrc on 14-8-26.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import "CpMainViewController.h"
#import "NetWebServiceRequest.h"
#import "LoadingAnimationView.h"
#import "CommonController.h"

@interface CpMainViewController ()<NetWebServiceRequestDelegate>
@property (retain, nonatomic) IBOutlet UILabel *lbCpName;
@property (retain, nonatomic) IBOutlet UIImageView *imgCpType;
@property (retain, nonatomic) IBOutlet UILabel *lbIndustry;
@property (retain, nonatomic) IBOutlet UILabel *lbIndustryValue;
@property (retain, nonatomic) IBOutlet UILabel *lbCompanyKind;
@property (retain, nonatomic) IBOutlet UILabel *lbCompanyKindValue;
@property (retain, nonatomic) IBOutlet UILabel *lbCompanySize;
@property (retain, nonatomic) IBOutlet UILabel *lbCompanySizeValue;
@property (retain, nonatomic) IBOutlet UILabel *lbAddress;
@property (retain, nonatomic) IBOutlet UILabel *lbAddressValue;
@property (retain, nonatomic) IBOutlet UILabel *lbBrief;
@property (retain, nonatomic) IBOutlet UILabel *lbBriefValue;
@property (retain, nonatomic) IBOutlet UILabel *lbLine;

@property (retain, nonatomic) IBOutlet UIScrollView *cpMainScroll;
@property (retain, nonatomic) IBOutlet UIView *cpMainView;
@property (retain, nonatomic) IBOutlet UIImageView *imageCoordinate;

@property (nonatomic, retain) NetWebServiceRequest *runningRequest;
@property (nonatomic, retain) LoadingAnimationView *loading;
@property (retain, nonatomic) NSString *wsName;//当前调用的webservice名称
@end

@implementation CpMainViewController
@synthesize runningRequest = _runningRequest;
@synthesize loading = _loading;
@synthesize cpMainID;

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
    [button setTitle: @"企业信息" forState: UIControlStateNormal];
    [button sizeToFit];
    self.navigationItem.titleView = button;
    //UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"后退" style:UIBarButtonItemStyleDone target:nil action:nil];
    //self.navigationItem.leftBarButtonItem=backButton;
    
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    [dicParam setObject:self.cpMainID forKey:@"CpMainID"];
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:@"GetCpMainInfo" Params:dicParam];
    [request setDelegate:self];
    [request startAsynchronous];
    self.runningRequest = request;
    self.wsName = @"GetCpMainInfo";//当前调用的函数名称
    self.loading = [[LoadingAnimationView alloc] initWithFrame:CGRectMake(140, 100, 80, 98) loadingAnimationViewStyle:LoadingAnimationViewStyleCarton target:self];
    [self.loading startAnimating];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidScroll......");
}


- (void)netRequestFinished:(NetWebServiceRequest *)request
      finishedInfoToResult:(NSString *)result
              responseData:(NSArray *)requestData
{
    if ([self.wsName isEqualToString:@"GetCpMainInfo"]) {
        [self didReceiveCpMain:requestData];
    }
}

-(void) didReceiveCpMain:(NSArray *) requestData
{
    NSDictionary *dicCpMain = requestData[0];
    //公司名称
    NSString *cpName = dicCpMain[@"Name"];
    CGSize labelSize = [CommonController CalculateFrame:cpName fontDemond:[UIFont systemFontOfSize:14] sizeDemand:CGSizeMake(self.lbCpName.frame.size.width, 500)];
    self.lbCpName.frame = CGRectMake(self.lbCpName.frame.origin.x, self.lbCpName.frame.origin.y, labelSize.width, labelSize.height);
    self.lbCpName.lineBreakMode = NSLineBreakByCharWrapping;
    self.lbCpName.numberOfLines = 0;
    [self.lbCpName setText:cpName];
    //公司名称后边的图标
    self.imgCpType.frame = CGRectMake(self.lbCpName.frame.origin.x + self.lbCpName.frame.size.width + 1, self.lbCpName.frame.origin.y+1, 18, 15);
    //所属行业
    self.lbIndustry.textColor = [UIColor grayColor];
    self.lbIndustryValue.text = dicCpMain[@"Industry"];
    //公司性质
    self.lbCompanyKind.textColor = [UIColor grayColor];
    self.lbCompanyKindValue.text = dicCpMain[@"CompanyKind"];
    //公司规模
    self.lbCompanySize.textColor = [UIColor grayColor];
    [self.lbCompanySizeValue setText:dicCpMain[@"CompanySize"]];
    //详细地址
    self.lbAddress.textColor = [UIColor grayColor];
    labelSize = [CommonController CalculateFrame:dicCpMain[@"Address"] fontDemond:[UIFont systemFontOfSize:12] sizeDemand:CGSizeMake(280, 500)];
    self.lbAddressValue.frame = CGRectMake(80, self.lbAddress.frame.origin.y + 5, labelSize.width, labelSize.height);
    self.lbAddressValue.lineBreakMode = NSLineBreakByCharWrapping;
    self.lbAddressValue.numberOfLines = 0;
    self.lbAddressValue.text = dicCpMain[@"Address"];
    //坐标图标
    self.imageCoordinate.frame = CGRectMake(self.lbAddressValue.frame.origin.x + self.lbAddressValue.frame.size.width + 1, self.lbAddressValue.frame.origin.y, 15, 15);
    
    //分割线
    CGFloat y = self.lbAddressValue.frame.origin.y + self.lbAddressValue.frame.size.height - 23;
    self.lbLine.frame = CGRectMake(8, y + 34, 304, 0.5);
    
    //公司介绍------hight = 166
    self.lbBrief.textColor = [UIColor grayColor];
    self.lbBrief.frame = CGRectMake(20, self.lbLine.frame.origin.y + self.lbLine.frame.size.height, 200, 40);
    NSString *strResponsibility = dicCpMain[@"Brief"];
    labelSize = [CommonController CalculateFrame:strResponsibility fontDemond:[UIFont systemFontOfSize:12] sizeDemand:CGSizeMake(280, 500)];
    self.lbBriefValue.frame = CGRectMake(20, self.lbBrief.frame.origin.y + self.lbBrief.frame.size.height - 5, labelSize.width, labelSize.height);
    self.lbBriefValue.lineBreakMode = NSLineBreakByCharWrapping;
    self.lbBriefValue.numberOfLines = 0;
    self.lbBriefValue.text = strResponsibility;
  
    //屏幕滚动
    self.cpMainScroll.frame = CGRectMake(self.cpMainScroll.frame.origin.x, self.cpMainScroll.frame.origin.y, self.cpMainScroll.frame.size.width, self.cpMainScroll.frame.size.height-5);
    [self.cpMainScroll setContentSize:CGSizeMake(320, self.lbBriefValue.frame.size.height + 200)];
    [self.loading stopAnimating];
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
    [_lbCpName release];
    [_imgCpType release];
    [_lbIndustry release];
    [_lbIndustryValue release];
    [_lbCompanyKind release];
    [_lbCompanyKindValue release];
    [_lbCompanySize release];
    [_lbCompanySizeValue release];
    [_lbAddress release];
    [_lbAddressValue release];
    [_lbBrief release];
    [_lbBriefValue release];
    [_lbLine release];
    [_cpMainScroll release];
    [_cpMainView release];
    [_imageCoordinate release];
    [super dealloc];
}
@end
