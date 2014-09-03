#import "RmAttendPaListViewController.h"
#import "NetWebServiceRequest.h"
#import "LoadingAnimationView.h"
#import "CommonController.h"
#import "MJRefresh.h"
#import "MyRecruitmentViewController.h"

@interface RmAttendPaListViewController ()<NetWebServiceRequestDelegate>
@property (nonatomic, retain) NetWebServiceRequest *runningRequest;
@property (retain, nonatomic) IBOutlet UITableView *tvRecruitmentPaList;
@end

@implementation RmAttendPaListViewController

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
    [button setTitle: @"参会个人" forState: UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button sizeToFit];
    self.navigationItem.titleView = button;
    page = 1;
    pageSize = 20;
    //数据加载等待控件初始化
    loadView = [[LoadingAnimationView alloc] initWithFrame:CGRectMake(140, 100, 80, 98) loadingAnimationViewStyle:LoadingAnimationViewStyleCarton target:self];
    [self onSearch];
}

-(void) btnMyRecruitmentClick:(UIBarButtonItem *)sender
{
    MyRecruitmentViewController *myRmCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"MyRecruitmentView"];
    [self.navigationController pushViewController:myRmCtrl animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onSearch
{
    if (page == 1) {
        [recruitmentPaData removeAllObjects];
        [self.tvRecruitmentPaList reloadData];
    }
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    [dicParam setObject:self.rmID forKey:@"ID"];
    [dicParam setObject:[NSString stringWithFormat:@"%d",page] forKey:@"pageNum"];
    [dicParam setObject:[NSString stringWithFormat:@"%d",pageSize] forKey:@"pageSize"];   
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:@"GetRmPersonList" Params:dicParam];
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
            [recruitmentPaData removeAllObjects];
            recruitmentPaData = requestData;
        }
        else{
            [recruitmentPaData addObjectsFromArray:requestData];
        }
        [self.tvRecruitmentPaList reloadData];
        [self.tvRecruitmentPaList footerEndRefreshing];
        
        //结束等待动画
        [loadView stopAnimating];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =
    [[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"paList"] autorelease];
    
    NSDictionary *rowData = recruitmentPaData[indexPath.row];
    //标题：现职位
    NSString *strJobName = rowData[@"JobName"];
    UIFont *titleFont = [UIFont systemFontOfSize:14];
    CGFloat titleWidth = 235;
    CGSize titleSize = CGSizeMake(titleWidth, 5000.0f);
    CGSize labelSize = [CommonController CalculateFrame:strJobName fontDemond:titleFont sizeDemand:titleSize];
    //现职位这三个字的label
    UILabel *lbPreTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 50, 20)];
    lbPreTitle.text = @"[现职位]";
    lbPreTitle.textColor = [UIColor grayColor];
    lbPreTitle.font = [UIFont systemFontOfSize:14];
    //职位名称
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(lbPreTitle.frame.origin.x+lbPreTitle.frame.size.width + 1, lbPreTitle.frame.origin.y, labelSize.width, 20)];
    lbTitle.text = strJobName;
    lbTitle.lineBreakMode = NSLineBreakByCharWrapping;
    lbTitle.numberOfLines = 0;
    lbTitle.font = [UIFont systemFontOfSize:14];
    
    [cell.contentView addSubview:lbPreTitle];
    [cell.contentView addSubview:(lbTitle)];
    
    //性别
    NSString *boolSex = rowData[@"Gender"];
    NSString *strSex;
    if ([boolSex isEqualToString:@"1"]) {
        strSex = @"男";
    }else{
        strSex = @"女";
    }
    //年龄
    NSString *strAge = rowData[@"BirthDay"];
    //学历
    NSString *strDegree = rowData[@"Degree"];
    //经验
    NSString *strRelatedWorkYears = rowData[@"RelatedWorkYears"];
    //所在地
    NSString *strLivePlace = rowData[@"LivePlace"];
    NSString *strPaInfo = [NSString stringWithFormat:@"%@ %@ %@ %@  %@ ", strSex, strAge, strDegree, strRelatedWorkYears, strLivePlace];
    labelSize = [CommonController CalculateFrame:strPaInfo fontDemond:[UIFont systemFontOfSize:12] sizeDemand:titleSize];
    UILabel *lbPaInfo = [[UILabel alloc] initWithFrame:CGRectMake(20, lbTitle.frame.origin.y+lbTitle.frame.size.height + 5, labelSize.width, labelSize.height)];
    lbPaInfo.text = strPaInfo;
    lbPaInfo.font = [UIFont systemFontOfSize:12];
    lbPaInfo.textColor = [UIColor grayColor];
    [cell.contentView addSubview:(lbPaInfo)];
    //参会时间
    NSString *strBeginDate = rowData[@"BeginDate"];
    NSDate *dtBeginDate = [CommonController dateFromString:strBeginDate];
    strBeginDate = [CommonController stringFromDate:dtBeginDate formatType:@"yyyy-MM-dd HH:mm"];
    NSString *strWeek = [CommonController getWeek:dtBeginDate];
    strBeginDate = [NSString stringWithFormat:@"参会时间：%@ %@",strBeginDate,strWeek];
    
    labelSize = [CommonController CalculateFrame:strBeginDate fontDemond:[UIFont systemFontOfSize:12] sizeDemand:titleSize];
    UILabel *lbBegin = [[UILabel alloc] initWithFrame:CGRectMake(20, lbPaInfo.frame.origin.y+lbPaInfo.frame.size.height + 5, labelSize.width, labelSize.height)];
    lbBegin.text = strBeginDate;
    lbBegin.font = [UIFont systemFontOfSize:12];
    lbBegin.textColor = [UIColor grayColor];
    [cell.contentView addSubview:(lbBegin)];
    
    [lbPreTitle release];
    [lbTitle release];
    [lbPaInfo release];
    [lbBegin release];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [recruitmentPaData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
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
    [_tvRecruitmentPaList release];
    [super dealloc];
}
@end
