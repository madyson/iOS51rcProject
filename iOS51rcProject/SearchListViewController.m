#import "SearchListViewController.h"
#import "NetWebServiceRequest.h"
#import "LoadingAnimationView.h"
#import "CommonController.h"
#import "MJRefresh.h"
#import "SearchPickerView.h"
#import "Toast+UIView.h"
#import "DictionaryPickerView.h"

@interface SearchListViewController () <NetWebServiceRequestDelegate,UITableViewDataSource,UITableViewDelegate,SearchPickerDelegate,DictionaryPickerDelegate>
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
@property (nonatomic, retain) UILabel *lbSearchResult;
@property (nonatomic, retain) SearchPickerView *searchPicker;
@property (nonatomic, retain) DictionaryPickerView *dictionaryPicker;
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

    //设置导航标题(搜索条件)
    UIView *viewTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 125, 45)];
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, viewTitle.frame.size.width, 20)];
    [lbTitle setFont:[UIFont systemFontOfSize:12]];
    [lbTitle setText:self.searchCondition];
    [lbTitle setTextAlignment:NSTextAlignmentCenter];
    [viewTitle setBackgroundColor:[UIColor blueColor]];
    [viewTitle addSubview:lbTitle];
    //设置导航标题(搜索结果)
    self.lbSearchResult = [[[UILabel alloc] initWithFrame:CGRectMake(0, 22, viewTitle.frame.size.width, 20)] autorelease];
    [self.lbSearchResult setText:@"正在获取职位列表"];
    [self.lbSearchResult setFont:[UIFont systemFontOfSize:10]];
    [self.lbSearchResult setTextAlignment:NSTextAlignmentCenter];
    [viewTitle addSubview:self.lbSearchResult];
    [self.navigationItem setTitleView:viewTitle];
    [viewTitle release];
    [lbTitle release];
    //设置底部功能栏
    self.btnApply.layer.cornerRadius = 5;
    self.viewBottom.layer.borderWidth = 1.0;
    self.viewBottom.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    //加载等待动画
    loadView = [[LoadingAnimationView alloc] initWithFrame:CGRectMake(140, 100, 80, 98) loadingAnimationViewStyle:LoadingAnimationViewStyleCarton target:self];
    //添加上拉加载更多
    [self.tvJobList addFooterWithTarget:self action:@selector(footerRereshing)];
    //不显示列表分隔线
    self.tvJobList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //添加检索功能
    [self.btnRegionFilter addTarget:self action:@selector(regionFilter) forControlEvents:UIControlEventTouchUpInside];
    [self.btnJobTypeFilter addTarget:self action:@selector(jobtypeFilter) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSalaryFilter addTarget:self action:@selector(salaryFilter) forControlEvents:UIControlEventTouchUpInside];
    [self.btnOtherFilter addTarget:self action:@selector(otherFilter) forControlEvents:UIControlEventTouchUpInside];
    //添加检索边框
    self.btnRegionFilter.layer.masksToBounds = YES;
    self.btnRegionFilter.layer.borderWidth = 1.0;
    self.btnRegionFilter.layer.borderColor = [[UIColor grayColor] CGColor];
    self.btnJobTypeFilter.layer.masksToBounds = YES;
    self.btnJobTypeFilter.layer.borderWidth = 1.0;
    self.btnJobTypeFilter.layer.borderColor = [[UIColor grayColor] CGColor];
    self.btnSalaryFilter.layer.masksToBounds = YES;
    self.btnSalaryFilter.layer.borderWidth = 1.0;
    self.btnSalaryFilter.layer.borderColor = [[UIColor grayColor] CGColor];
    self.btnOtherFilter.layer.masksToBounds = YES;
    self.btnOtherFilter.layer.borderWidth = 1.0;
    self.btnOtherFilter.layer.borderColor = [[UIColor grayColor] CGColor];
    
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
    [dicParam autorelease];
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
    UIFont *fontCell = [UIFont systemFontOfSize:12];
    UIColor *colorText = [UIColor colorWithRed:120.f/255.f green:120.f/255.f blue:120.f/255.f alpha:1];
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"jobList"] autorelease];
    NSDictionary *rowData = self.jobListData[indexPath.row];
    if (indexPath.row == 1) {
        [self.lbSearchResult setText:[NSString stringWithFormat:@"[找到%@个职位]",rowData[@"JobNumber"]]];
    }
    //职位名称
    UILabel *lbJobName = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 200, 20)];
    [lbJobName setText:rowData[@"JobName"]];
    [lbJobName setFont:[UIFont systemFontOfSize:14]];
    [cell.contentView addSubview:lbJobName];
    [lbJobName release];
    
    //公司名称
    UILabel *lbCompanyName = [[UILabel alloc] initWithFrame:CGRectMake(30, 28, 200, 20)];
    [lbCompanyName setText:rowData[@"cpName"]];
    [lbCompanyName setFont:fontCell];
    [lbCompanyName setTextColor:colorText];
    [cell.contentView addSubview:lbCompanyName];
    [lbCompanyName release];
    
    //刷新时间
    UILabel *lbRefreshDate = [[UILabel alloc] initWithFrame:CGRectMake(230, 28, 85, 20)];
    [lbRefreshDate setText:[CommonController stringFromDate:[CommonController dateFromString:rowData[@"RefreshDate"]] formatType:@"MM-dd HH:mm"]];
    [lbRefreshDate setFont:fontCell];
    [lbRefreshDate setTextColor:colorText];
    [lbRefreshDate setTextAlignment:NSTextAlignmentRight];
    [cell.contentView addSubview:lbRefreshDate];
    [lbRefreshDate release];
    
    //地区|学历
    NSString *strRegionAndEducation = [NSString stringWithFormat:@"%@|%@",[CommonController getDictionaryDesc:rowData[@"dcRegionID"] tableName:@"dcRegion"],[CommonController getDictionaryDesc:rowData[@"dcEducationID"] tableName:@"dcEducation"]];
    UILabel *lbRegionAndEducation = [[UILabel alloc] initWithFrame:CGRectMake(30, 51, 200, 20)];
    [lbRegionAndEducation setText:strRegionAndEducation];
    [lbRegionAndEducation setFont:fontCell];
    [lbRegionAndEducation setTextColor:colorText];
    [cell.contentView addSubview:lbRegionAndEducation];
    [lbRegionAndEducation release];
    
    //月薪
    NSString *strSalary = [CommonController getDictionaryDesc:rowData[@"dcSalaryID"] tableName:@"dcSalary"];
    if (strSalary.length == 0) {
        strSalary = @"面议";
    }
    UILabel *lbSalary = [[UILabel alloc] initWithFrame:CGRectMake(230, 51, 85, 20)];
    [lbSalary setText:strSalary];
    [lbSalary setFont:fontCell];
    [lbSalary setTextColor:[UIColor redColor]];
    [lbSalary setTextAlignment:NSTextAlignmentRight];
    [cell.contentView addSubview:lbSalary];
    [lbSalary release];
    
    //分割线
    UIView *viewSeparate = [[UIView alloc] initWithFrame:CGRectMake(0, 76, 320, 1)];
    [viewSeparate setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:viewSeparate];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

- (void)regionFilter
{
    if ([self.searchRegion rangeOfString:@","].location == NSNotFound) {
        if (![CommonController hasParentOfRegion:self.searchRegion]) {
            [self.view makeToast:@"您选择的地区已经到最后一级，不能再继续筛选了"];
            return;
        }
    }
    self.searchPicker = [[[SearchPickerView alloc] initWithSearchRegionFilter:self selectValue:self.searchRegion selectName:self.searchRegionName defalutValue:self.workPlace] autorelease];
    self.searchPicker.tag = 1;
    [self.searchPicker showInView:self.view];
}

- (void)jobtypeFilter
{
    if ([self.searchRegion rangeOfString:@","].location == NSNotFound) {
        if (self.searchRegion.length == 4) {
            [self.view makeToast:@"您选择的职位类别已经到最后一级，不能再继续筛选了"];
            return;
        }
    }
    self.searchPicker = [[[SearchPickerView alloc] initWithSearchJobTypeFilter:self selectValue:self.searchJobType selectName:self.searchJobTypeName defalutValue:self.jobType] autorelease];
    self.searchPicker.tag = 2;
    [self.searchPicker showInView:self.view];
}

- (void)salaryFilter
{
    self.dictionaryPicker = [[[DictionaryPickerView alloc] initWithCommon:self pickerMode:DictionaryPickerModeOne tableName:@"dcSalary" defalutValue:self.salary defaultName:@""] autorelease];
    self.dictionaryPicker.tag = 1;
    [self.dictionaryPicker showInView:self.view];
}

- (void)otherFilter
{
    self.searchPicker = [[[SearchPickerView alloc] initWithSearchOtherFilter:self defalutValue:self.selectOther defaultName:self.selectOtherName] autorelease];
    self.searchPicker.tag = 3;
    [self.searchPicker showInView:self.view];
}

- (void)searchPickerDidChangeStatus:(SearchPickerView *)picker
                selectedValue:(NSString *)selectedValue
                 selectedName:(NSString *)selectedName
{
    [self cancelPicker];
    if (picker.tag == 1) {
        self.workPlace = selectedValue;
        self.lbRegionFilter.text = selectedName;
    }
    else if (picker.tag == 2) {
        self.jobType = selectedValue;
        self.lbJobTypeFilter.text = selectedName;
    }
    else if (picker.tag == 3) {
        self.selectOther = selectedValue;
        self.selectOtherName = selectedName;
        self.experience = @"";
        self.education = @"";
        self.employType = @"";
        self.companySize = @"";
        self.welfare = @"";
        self.isOnline = @"";
        if (selectedValue.length > 0) {
            NSArray *arrSelectValue = [selectedValue componentsSeparatedByString:@","];
            for (NSString* value in arrSelectValue) {
                if ([[value substringToIndex:1] isEqualToString:@"a"]) {
                    self.isOnline = @"1";
                }
                if ([[value substringToIndex:1] isEqualToString:@"b"]) {
                    self.education = [value substringFromIndex:1];
                }
                if ([[value substringToIndex:1] isEqualToString:@"c"]) {
                    self.experience = [value substringFromIndex:1];
                }
                if ([[value substringToIndex:1] isEqualToString:@"d"]) {
                    self.employType = [value substringFromIndex:1];
                }
                if ([[value substringToIndex:1] isEqualToString:@"e"]) {
                    self.companySize = [value substringFromIndex:1];
                }
                if ([[value substringToIndex:1] isEqualToString:@"f"]) {
                    self.welfare = [self.welfare stringByAppendingString:[NSString stringWithFormat:@"%@,",[value substringFromIndex:1]]];
                }
            }
            if (self.welfare.length > 0) {
                self.welfare = [self.welfare substringToIndex:self.welfare.length-1];
            }
        }
    }
    self.pageNumber = 1;
    [self onSearch];
}

- (void)pickerDidChangeStatus:(DictionaryPickerView *)picker
                selectedValue:(NSString *)selectedValue
                 selectedName:(NSString *)selectedName
{
    [self cancelPicker];
    if (picker.tag == 1) {
        self.salary = selectedValue;
        self.lbSalaryFilter.text = selectedName;
    }
    self.pageNumber = 1;
    [self onSearch];
}

-(void)cancelPicker
{
    [self.dictionaryPicker cancelPicker];
    self.dictionaryPicker.delegate = nil;
    self.dictionaryPicker = nil;
    
    [self.searchPicker cancelPicker];
    self.searchPicker.delegate = nil;
    self.searchPicker = nil;
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
    [_lbSearchResult release];
    [_btnApply release];
    [_btnFavorite release];
    [_viewBottom release];
    [_searchPicker release];
    [_dictionaryPicker release];
    [super dealloc];
}
@end
