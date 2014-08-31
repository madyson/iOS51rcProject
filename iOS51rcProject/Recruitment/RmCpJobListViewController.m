#import "RmCpJobListViewController.h"
#import "NetWebServiceRequest.h"
#import "CommonController.h"

@interface RmCpJobListViewController ()<NetWebServiceRequestDelegate>
@property (nonatomic, retain) NetWebServiceRequest *runningRequest;
@property (retain, nonatomic) IBOutlet UITableView *tvCpJobList;

@end

@implementation RmCpJobListViewController
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
    
    UIBarButtonItem *btnMyRecruitment = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(btnMyRecruitmentClick:)];
    btnMyRecruitment.title = @"我的招聘会";
    self.navigationItem.rightBarButtonItem=btnMyRecruitment;
    
    //数据加载等待控件初始化
    loadView = [[LoadingAnimationView alloc] initWithFrame:CGRectMake(140, 100, 80, 98) loadingAnimationViewStyle:LoadingAnimationViewStyleCarton target:self];
    [self onSearch];
}

-(void) btnMyRecruitmentClick:(UIBarButtonItem *)sender
{
    //MyRecruitmentViewController *myRmCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"MyRecruitmentView"];
    //[self.navigationController pushViewController:myRmCtrl animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onSearch
{
    [JobListData removeAllObjects];
    [self.tvCpJobList reloadData];
    
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    [dicParam setObject:@"10178611" forKey:@"cpMainID"];
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:@"GetJobList" Params:dicParam];
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
    [JobListData removeAllObjects];
    JobListData = requestData;
    
    [self.tvCpJobList reloadData];
    //[self.tvCpJobList footerEndRefreshing];
    
    //结束等待动画
    [loadView stopAnimating];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =
    [[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"paList"] autorelease];
    
    NSDictionary *rowData = JobListData[indexPath.row];
    //职位名称
    NSString *strJobName = rowData[@"Name"];
    UIFont *titleFont = [UIFont systemFontOfSize:12];
    CGFloat titleWidth = 235;
    CGSize titleSize = CGSizeMake(titleWidth, 5000.0f);
    CGSize labelSize = [CommonController CalculateFrame:strJobName fontDemond:titleFont sizeDemand:titleSize];
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelSize.width, labelSize.height)];
    lbTitle.text = strJobName;
    lbTitle.lineBreakMode = NSLineBreakByCharWrapping;
    lbTitle.numberOfLines = 0;
    lbTitle.font = titleFont;
    [lbTitle release];
    [cell.contentView addSubview:(lbTitle)];
    //时间
    NSString *strefreshDate = rowData[@"RefreshDate"];
    NSDate *dtefreshDate = [CommonController dateFromString:strefreshDate];
    strefreshDate = [CommonController stringFromDate:dtefreshDate formatType:@"MM-dd HH:mm"];
    UILabel *lbeRfreshDate = [[UILabel alloc] initWithFrame:CGRectMake(240, lbTitle.frame.origin.y+lbTitle.frame.size.height + 5, labelSize.width, labelSize.height)];
    lbeRfreshDate.text = strefreshDate;
    lbeRfreshDate.font = [UIFont systemFontOfSize:12];
    lbeRfreshDate.textColor = [UIColor grayColor];
    [lbeRfreshDate release];
    [cell.contentView addSubview:(lbeRfreshDate)];
  
    //地区
    NSString *strAge = rowData[@"Region"];
    //学历
    NSString *strDegree = rowData[@"dcEducationID"];
    NSString *strInfo = [NSString stringWithFormat:@"%@|%@", strAge, strDegree];
    UILabel *lbInfo = [[UILabel alloc] initWithFrame:CGRectMake(20, lbTitle.frame.origin.y+lbTitle.frame.size.height + 5, labelSize.width, labelSize.height)];
    lbInfo.text = strInfo;
    lbInfo.font = [UIFont systemFontOfSize:12];
    lbInfo.textColor = [UIColor grayColor];
    [cell.contentView addSubview:(lbInfo)];
    [lbInfo release];
    
    //工资
    NSString *strdcSalaryID = rowData[@"dcSalaryID"];
    UILabel *lbSalary = [[UILabel alloc] initWithFrame:CGRectMake(240, lbTitle.frame.origin.y+lbTitle.frame.size.height + 5, labelSize.width, labelSize.height)];
    lbSalary.text = strdcSalaryID;
    lbSalary.font = [UIFont systemFontOfSize:12];
    lbSalary.textColor = [UIColor grayColor];
    [cell.contentView addSubview:(lbSalary)];
    [lbSalary release];
    
    return cell;
}

//点击某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSArray *arr = JobListData[indexPath.row];
    NSString *cpMainID = JobListData[indexPath.row][@"cpMainID"];
    NSString *jobID = JobListData[indexPath.row][@"ID"];
    NSString *name = JobListData[indexPath.row][@"Name"];
    [cpMainID retain];
    [jobID retain];
    [name retain];
    [delegate SetJob:cpMainID jobID:jobID JobName:name];
    //[gotoRmViewDelegate gotoRmView:recruitmentCpData[indexPath.row][@"id"]];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [JobListData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

//- (void)footerRereshing{
//    page++;
//    [self onSearch];
//}


- (void)dealloc {
    [_tvCpJobList release];
    [super dealloc];
}
@end
