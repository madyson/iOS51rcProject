#import "SearchListViewController.h"
#import "NetWebServiceRequest.h"
#import "LoadingAnimationView.h"
#import "MJRefresh.h"

@interface SearchListViewController () <NetWebServiceRequestDelegate,UITableViewDataSource,UITableViewDelegate>
{
    LoadingAnimationView *loadView;
}
@property (nonatomic, retain) NSMutableArray *jobListData;
@property int pageNumber;
@property (nonatomic, retain) NSString *jobType;
@property (nonatomic, retain) NSString *workPlace;
@property (nonatomic, retain) NSString *industry;
@property (nonatomic, retain) NSString *salary;
@property (nonatomic, retain) NSString *experience;
@property (nonatomic, retain) NSString *education;
@property (nonatomic, retain) NSString *employType;
@property (nonatomic, retain) NSString *keyWord;
@property (nonatomic, retain) NSString *rsType;
@property (nonatomic, retain) NSString *companySize;
@property (nonatomic, retain) NSString *welfare;
@property (nonatomic, retain) NSString *isOnline;
@property (nonatomic, retain) NetWebServiceRequest *runningRequest;

@end

@implementation SearchListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //设置导航标题
    UIView *viewTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewTitle.frame.size.width, 20)];
    [lbTitle setFont:[UIFont systemFontOfSize:12]];
    [lbTitle setText:self.searchCondition];
    [lbTitle setTextAlignment:NSTextAlignmentCenter];
    [viewTitle setBackgroundColor:[UIColor blueColor]];
    [viewTitle addSubview:lbTitle];
    [self.navigationItem setTitleView:viewTitle];
    [viewTitle release];
    [lbTitle release];
    
    //加载等待动画
    loadView = [[LoadingAnimationView alloc] initWithFrame:CGRectMake(140, 100, 80, 98) loadingAnimationViewStyle:LoadingAnimationViewStyleCarton target:self];
    //添加上拉加载更多
    [self.tvJobList addFooterWithTarget:self action:@selector(footerRereshing)];
    //不显示列表分隔线
    self.tvJobList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //搜索条件赋值
    self.jobType = @"";
    self.workPlace = @"";
    self.industry = @"";
    self.salary = @"";
    self.experience = @"";
    self.education = @"";
    self.employType = @"";
    self.keyWord = @"";
    self.rsType = @"";
    self.companySize = @"";
    self.welfare = @"";
    self.isOnline = @"";
    
    if (self.searchJobType.length > 0) {
        self.jobType = self.searchJobType;
    }
    if (self.searchIndustry.length > 0) {
        self.industry = self.searchIndustry;
    }
    
    self.workPlace = self.searchRegion;
    self.keyWord = self.searchKeyword;
    self.pageNumber = 1;
    self.rsType = @"0";
    
    [self onSearch];
}

- (void)onSearch
{
    if (self.pageNumber == 1) {
        [self.jobListData removeAllObjects];
        [self.tvJobList reloadData];
        //开始等待动画
        [loadView startAnimating];
    }
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    [dicParam setObject:self.jobType forKey:@"jobType"];
    [dicParam setObject:self.workPlace forKey:@"workPlace"];
    [dicParam setObject:self.industry forKey:@"industry"];
    [dicParam setObject:self.salary forKey:@"salary"];
    [dicParam setObject:self.experience forKey:@"experience"];
    [dicParam setObject:self.education forKey:@"education"];
    [dicParam setObject:self.employType forKey:@"employType"];
    [dicParam setObject:self.keyWord forKey:@"keyWord"];
    [dicParam setObject:self.education forKey:@"education"];
    [dicParam setObject:self.rsType forKey:@"rsType"];
    [dicParam setObject:[NSString stringWithFormat:@"%d",self.pageNumber] forKey:@"pageNumber"];
    [dicParam setObject:self.companySize forKey:@"companySize"];
    [dicParam setObject:@"" forKey:@"searchFromID"];
    [dicParam setObject:self.welfare forKey:@"welfare"];
    [dicParam setObject:self.isOnline forKey:@"isOnline"];
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:@"GetJobListBySearch" Params:dicParam];
    [request setDelegate:self];
    [request startAsynchronous];
    self.runningRequest = request;
}

- (void)footerRereshing{
    self.pageNumber++;
    [self onSearch];
}

- (void)netRequestFinished:(NetWebServiceRequest *)request
      finishedInfoToResult:(NSString *)result
              responseData:(NSMutableArray *)requestData
{
    if(self.pageNumber == 1){
        [self.jobListData removeAllObjects];
        self.jobListData = requestData;
    }
    else{
        [self.jobListData addObjectsFromArray:requestData];
    }
    //结束等待动画
    [loadView stopAnimating];
    [self.tvJobList footerEndRefreshing];
    //重新加载列表
    [self.tvJobList reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.jobListData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"jobList"];
    
    
    NSDictionary *rowData = self.jobListData[indexPath.row];
    cell.textLabel.text = rowData[@"JobName"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
    [_btnRegionFilter release];
    [_lbRegionFilter release];
    [_btnJobTypeFilter release];
    [_lbJobTypeFilter release];
    [_btnSalaryFilter release];
    [_lbSalaryFilter release];
    [_btnOtherFilter release];
    [_runningRequest release];
    [_jobType retain];
    [_workPlace retain];
    [_industry retain];
    [_salary retain];
    [_experience retain];
    [_education retain];
    [_employType retain];
    [_keyWord retain];
    [_rsType retain];
    [_companySize retain];
    [_welfare retain];
    [_isOnline retain];
    [_tvJobList release];
    [_searchKeyword release];
    [_searchRegion release];
    [_searchJobType release];
    [_searchIndustry release];
    [_searchCondition release];
    [super dealloc];
}
@end
