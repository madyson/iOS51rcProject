#import "RecruitmentListViewController.h"
#import "NetWebServiceRequest.h"
#import "GDataXMLNode.h"
#import "CommonController.h"
#import "MJRefresh.h"

@interface RecruitmentListViewController ()<NetWebServiceRequestDelegate,DatePickerDelegate>
    @property (retain, nonatomic) IBOutlet UITableView *tvRecruitmentList;
    @property (retain, nonatomic) IBOutlet UIButton *btnProvinceSel;
    @property (retain, nonatomic) IBOutlet UIButton *btnPlaceSel;
    @property (retain, nonatomic) IBOutlet UILabel *lbDateSet;
    @property (retain, nonatomic) IBOutlet UIButton *btnDateSet;
    @property (nonatomic, retain) NetWebServiceRequest *runningRequest;
@end

@implementation RecruitmentListViewController
@synthesize runningRequest = _runningRequest;
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
    [recruitmentData retain];
    //时间选择控件
    pickDate = [[DatePicker alloc] init];
    pickDate.delegate = self;
    [self.btnDateSet addTarget:self action:@selector(showDateSelect) forControlEvents:UIControlEventTouchUpInside];
    
    //数据加载等待控件初始化
    loadView = [[LoadingAnimationView alloc] initWithFrame:CGRectMake(140, 100, 80, 98) loadingAnimationViewStyle:LoadingAnimationViewStyleCarton];
    
    //添加上拉加载更多
    [self.tvRecruitmentList addFooterWithTarget:self action:@selector(footerRereshing)];
    //不显示列表分隔线
    self.tvRecruitmentList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //搜索初始化
    begindate = @"";
    page = 1;
    placeid = @"0";
    [self onSearch];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    
}

- (void)onSearch
{
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    [dicParam setObject:@"0" forKey:@"paMainID"];
    [dicParam setObject:begindate forKey:@"strBeginDate"];
    [dicParam setObject:placeid forKey:@"strPlaceID"];
    [dicParam setObject:@"32" forKey:@"strRegionID"];
    [dicParam setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [dicParam setObject:@"0" forKey:@"code"];
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:@"GetRecruitMentList" Params:dicParam];
    [request startAsynchronous];
    [request setDelegate:self];
    self.runningRequest = request;
    //开始等待动画
    [loadView startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =
        [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"rmList"];
    
    NSDictionary *rowData = recruitmentData[indexPath.row];
    //显示标题
    NSString *strRecruitmentName = rowData[@"RecruitmentName"];
    UIFont *titleFont = [UIFont systemFontOfSize:15];
    CGFloat titleWidth = 235;
    CGSize titleSize = CGSizeMake(titleWidth, 5000.0f);
    CGSize labelSize = [CommonController CalculateFrame:strRecruitmentName fontDemond:titleFont sizeDemand:titleSize];
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, labelSize.width, labelSize.height)];
    lbTitle.text = strRecruitmentName;
    lbTitle.lineBreakMode = NSLineBreakByCharWrapping;
    lbTitle.numberOfLines = 0;
    lbTitle.font = titleFont;
    [cell.contentView addSubview:(lbTitle)];
    [lbTitle release];
    
    //显示举办时间 举办场馆 具体地址
    UILabel *lbBegin = [[UILabel alloc] initWithFrame:CGRectMake(20, (labelSize.height + 15), titleWidth, 15)];
    NSString *strBeginDate = rowData[@"BeginDate"];
    NSDate *dtBeginDate = [CommonController dateFromString:strBeginDate];
    strBeginDate = [CommonController stringFromDate:dtBeginDate formatType:@"yyyy-MM-dd HH:mm"];
    NSString *strWeek = [CommonController getWeek:dtBeginDate];
    lbBegin.text = [NSString stringWithFormat:@"举办时间：%@ %@",strBeginDate,strWeek];
    lbBegin.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:(lbBegin)];
    [lbBegin release];
    
    UILabel *lbPlace = [[UILabel alloc] initWithFrame:CGRectMake(20, (labelSize.height + 35), titleWidth, 15)];
    lbPlace.text = [NSString stringWithFormat:@"举办场馆：%@",rowData[@"PlaceName"]];
    lbPlace.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:(lbPlace)];
    [lbPlace release];
    
    UILabel *lbAddress = [[UILabel alloc] initWithFrame:CGRectMake(20, (labelSize.height + 55), titleWidth, 15)];
    lbAddress.text = [NSString stringWithFormat:@"举办场馆：%@",rowData[@"Address"]];
    lbAddress.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:(lbAddress)];
    [lbAddress release];

    UILabel *lbSeparator = [[UILabel alloc] initWithFrame:CGRectMake(0, 119, 320, 1)];
    lbSeparator.backgroundColor = [UIColor grayColor];
    [cell.contentView addSubview:(lbSeparator)];
    [lbSeparator release];

    //显示状态
    int runStatus = 0;
    NSDate *dtEndDate = [CommonController dateFromString:rowData[@"EndDate"]];
    NSDate *dtNow = [NSDate date];
    NSDate *dtCompare = [dtBeginDate earlierDate:dtNow];
    if (dtNow == dtCompare) {
        runStatus = 3; //未开始
    }
    else{
        dtCompare = [dtEndDate earlierDate:dtNow];
        if(dtNow == dtCompare){
            runStatus = 1; //正在进行
        }
        else{
            runStatus = 2; //已过期
        }
    }
    if (runStatus == 1) {
        UIView *rightContent = [[UIView alloc] initWithFrame:CGRectMake(260, 35, 30, 45)];
        UILabel *lbRunning = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 30, 10)];
        lbRunning.text = @"进行中";
        lbRunning.font = [UIFont systemFontOfSize:10];
        lbRunning.textColor = [UIColor colorWithRed:107.f/255.f green:217.f/255.f blue:70.f/255.f alpha:1];
        lbRunning.textAlignment = NSTextAlignmentCenter;
        [rightContent addSubview:lbRunning];
        
        UIImageView *imgRunning = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        imgRunning.image = [UIImage imageNamed:@"ico_clock.png"];
        
        [rightContent addSubview:imgRunning];
        [cell.contentView addSubview:rightContent];
        [rightContent release];
        [lbRunning release];
        [imgRunning release];
    }
    else if (runStatus == 2){
        
    }
    else if (runStatus == 3){
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(260, 35, 30, 45)];
        UILabel *lbWillRun = [[UILabel alloc] initWithFrame:CGRectMake(-5, 35, 40, 10)];
        lbWillRun.text = @"我要参会";
        lbWillRun.font = [UIFont systemFontOfSize:10];
        lbWillRun.textColor = [UIColor colorWithRed:255.f/255.f green:90.f/255.f blue:40.f/255.f alpha:1];
        lbWillRun.textAlignment = NSTextAlignmentCenter;
        [rightButton addSubview:lbWillRun];
        
        UIImageView *imgWillRun = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        imgWillRun.image = [UIImage imageNamed:@"ico_rm_group.png"];
        rightButton.tag = (NSInteger)rowData[@"ID"];
        [rightButton addSubview:imgWillRun];
        [rightButton addTarget:self action:@selector(joinRecruitment:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:rightButton];
        [rightButton release];
        [lbWillRun release];
        [imgWillRun release];
        
    }
    //结束等待动画
    [loadView stopAnimating];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void) joinRecruitment:(UIButton *)sender{
    NSLog(@"%d",sender.tag);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [recruitmentData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (void)footerRereshing{
    page++;
    [self onSearch];
}

//成功
- (void)netRequestFinished:(NetWebServiceRequest *)request
      finishedInfoToResult:(NSString *)result
              responseData:(NSArray *)requestData
{
    if(page == 1){
        [recruitmentData removeAllObjects];
        recruitmentData = requestData;
    }
    else{
        [recruitmentData addObjectsFromArray:requestData];
    }
    [self.tvRecruitmentList reloadData];
    [self.tvRecruitmentList footerEndRefreshing];
}

- (void)dealloc {
    [recruitmentData release];
    [pickDate release];
    [loadView release];
    [_tvRecruitmentList release];
    [_btnDateSet release];
    [_btnProvinceSel release];
    [_btnPlaceSel release];
    [_lbDateSet release];
    [super dealloc];
}

-(void)showDateSelect{
    [pickDate showDatePicker:self dateTitle:@"请选择举办日期"];
}

-(void)saveDate:(NSDate *)selectDate{
    NSString *strSelDate = [CommonController stringFromDate:selectDate formatType:@"MM-dd"];
    self.lbDateSet.text = strSelDate;
    begindate = [CommonController stringFromDate:selectDate formatType:@"yyyy-MM-dd"];
    [self onSearch];
    [pickDate removeDatePicker];
}

-(void)resetDate{
    
}
@end
