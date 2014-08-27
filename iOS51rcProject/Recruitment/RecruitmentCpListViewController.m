//
//  RecruitmentCpListViewController.m
//  iOS51rcProject
//
//  Created by qlrc on 14-8-26.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import "RecruitmentCpListViewController.h"
#import "NetWebServiceRequest.h"
#import "LoadingAnimationView.h"
#import "CommonController.h"
#import "MJRefresh.h"

@interface RecruitmentCpListViewController ()<NetWebServiceRequestDelegate>
@property (nonatomic, retain) NetWebServiceRequest *runningRequest;
@property (retain, nonatomic) IBOutlet UITableView *tvRecruitmentCpList;
@end

@implementation RecruitmentCpListViewController

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
    page = 1;
    pageSize = 20;
    rmID = @"95935";
    //数据加载等待控件初始化
    loadView = [[LoadingAnimationView alloc] initWithFrame:CGRectMake(140, 100, 80, 98) loadingAnimationViewStyle:LoadingAnimationViewStyleCarton target:self];
    [self onSearch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onSearch
{
    if (page == 1) {
        [recruitmentCpData removeAllObjects];
        [self.tvRecruitmentCpList reloadData];
    }
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    [dicParam setObject:rmID forKey:@"ID"];
    [dicParam setObject:[NSString stringWithFormat:@"%d",page] forKey:@"pageNum"];
    [dicParam setObject:[NSString stringWithFormat:@"%d",pageSize] forKey:@"pageSize"];
    [dicParam setObject:@"123456" forKey:@"paMainID"];
    [dicParam setObject:@"1" forKey:@"code"];
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:@"GetRmcompanyList" Params:dicParam];
    [request setDelegate:self];
    [request startAsynchronous];
    request.tag = 1;
    self.runningRequest = request;
    [dicParam release];
}

//成功
- (void)netRequestFinished:(NetWebServiceRequest *)request
      finishedInfoToResult:(NSString *)result
              responseData:(NSMutableArray *)requestData
{
    if(page == 1){
        [recruitmentCpData removeAllObjects];
        recruitmentCpData = requestData;
    }
    else{
        [recruitmentCpData addObjectsFromArray:requestData];
    }
    [self.tvRecruitmentCpList reloadData];
    [self.tvRecruitmentCpList footerEndRefreshing];
    
    //结束等待动画
    [loadView stopAnimating];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =
    [[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cpList"] autorelease];
    
    NSDictionary *rowData = recruitmentCpData[indexPath.row];
    //选择图标
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 22, 30, 45)];
    
    UIImageView *imgCheck = [[UIImageView alloc] initWithFrame:CGRectMake(7, 15, 15, 15)];
    imgCheck.image = [UIImage imageNamed:@"unChecked.png"];
    imgCheck.tag = (NSInteger)rowData[@"ID"];
    [leftButton addSubview:imgCheck];
    [leftButton addTarget:self action:@selector(bookinginterview:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:leftButton];
    [leftButton release];
    [imgCheck release];
    
    //企业名称
    NSString *strCpName = rowData[@"Name"];
    UIFont *titleFont = [UIFont systemFontOfSize:14];
    CGFloat titleWidth = 235;
    CGSize titleSize = CGSizeMake(titleWidth, 5000.0f);
    CGSize labelSize = [CommonController CalculateFrame:strCpName fontDemond:titleFont sizeDemand:titleSize];
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, self.tvRecruitmentCpList.frame.origin.x + 20, labelSize.width, labelSize.height)];
    lbTitle.text = strCpName;
    lbTitle.lineBreakMode = NSLineBreakByCharWrapping;
    lbTitle.numberOfLines = 0;
    lbTitle.font = [UIFont systemFontOfSize:14];
   
    [cell.contentView addSubview:(lbTitle)];
   
    //所在地
    NSString *strAddress = rowData[@"Address"];
    labelSize = [CommonController CalculateFrame:strAddress fontDemond:[UIFont systemFontOfSize:12] sizeDemand:titleSize];
    UILabel *lbPaInfo = [[UILabel alloc] initWithFrame:CGRectMake(50, lbTitle.frame.origin.y+lbTitle.frame.size.height + 5, labelSize.width, labelSize.height)];
    lbPaInfo.text = strAddress;
    lbPaInfo.font = [UIFont systemFontOfSize:12];
    lbPaInfo.textColor = [UIColor grayColor];
    [cell.contentView addSubview:(lbPaInfo)];
    
    //定展时间
    NSString *strBeginDate = rowData[@"AddDate"];
    NSDate *dtBeginDate = [CommonController dateFromString:strBeginDate];
    strBeginDate = [CommonController stringFromDate:dtBeginDate formatType:@"yyyy-MM-dd HH:mm"];
    NSString *strWeek = [CommonController getWeek:dtBeginDate];
    strBeginDate = [NSString stringWithFormat:@"定展时间：%@ %@",strBeginDate,strWeek];
    
    labelSize = [CommonController CalculateFrame:strBeginDate fontDemond:[UIFont systemFontOfSize:12] sizeDemand:titleSize];
    UILabel *lbBegin = [[UILabel alloc] initWithFrame:CGRectMake(50, lbPaInfo.frame.origin.y+lbPaInfo.frame.size.height + 5, labelSize.width, labelSize.height)];
    lbBegin.text = strBeginDate;
    lbBegin.font = [UIFont systemFontOfSize:12];
    lbBegin.textColor = [UIColor grayColor];
    [cell.contentView addSubview:(lbBegin)];
    
    //预约面试按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(260, 22, 30, 45)];
    UILabel *lbWillRun = [[UILabel alloc] initWithFrame:CGRectMake(-5, 35, 40, 10)];
    lbWillRun.text = @"预约面试";
    lbWillRun.font = [UIFont systemFontOfSize:10];
    lbWillRun.textColor = [UIColor colorWithRed:255.f/255.f green:90.f/255.f blue:40.f/255.f alpha:1];
    lbWillRun.textAlignment = NSTextAlignmentCenter;
    [rightButton addSubview:lbWillRun];
    
    UIImageView *imgWillRun = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    imgWillRun.image = [UIImage imageNamed:@"ico_rm_group.png"];
    rightButton.tag = (NSInteger)rowData[@"ID"];
    [rightButton addSubview:imgWillRun];
    [rightButton addTarget:self action:@selector(bookinginterview:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:rightButton];
    
    [rightButton release];
    [lbWillRun release];
    [imgWillRun release];
    [lbTitle release];
    [lbPaInfo release];
    [lbBegin release];
    return cell;
}

-(void) bookinginterview:(UIButton *)sender{
    NSLog(@"%d",sender.tag);
}

-(void) checkBoxBookinginterviewClick:(UIButton *)sender{
    NSLog(@"%d",sender.tag);
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [recruitmentCpData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)footerRereshing{
    page++;
    [self onSearch];
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
    [_tvRecruitmentCpList release];
    [super dealloc];
}
@end
