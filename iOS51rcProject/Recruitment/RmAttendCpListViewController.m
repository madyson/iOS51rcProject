
//招聘会参会企业列表
#import "RmAttendCpListViewController.h"
#import "NetWebServiceRequest.h"
#import "LoadingAnimationView.h"
#import "CommonController.h"
#import "MJRefresh.h"
#import "CpMainViewController.h"
#import "RmInviteCpViewController.h"
#import "RmCpMain.h"
#import <objc/runtime.h> 

@interface RmAttendCpListViewController ()<NetWebServiceRequestDelegate>
@property (nonatomic, retain) NetWebServiceRequest *runningRequest;
@property (retain, nonatomic) IBOutlet UITableView *tvRecruitmentCpList;

@end

@implementation RmAttendCpListViewController

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
    checkedCpArray = [[NSMutableArray alloc] init];//选择的企业
    page = 1;
    pageSize = 20;   
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *code = [userDefaults objectForKey:@"code"];
    NSString *userID = [userDefaults objectForKey:@"UserID"];
    
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    [dicParam setObject:self.rmID forKey:@"ID"];
    [dicParam setObject:[NSString stringWithFormat:@"%d",page] forKey:@"pageNum"];
    [dicParam setObject:[NSString stringWithFormat:@"%d",pageSize] forKey:@"pageSize"];
    [dicParam setObject:userID forKey:@"paMainID"];
    [dicParam setObject:code forKey:@"code"];
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

//绑定数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =
    [[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cpList"] autorelease];
    
    NSDictionary *rowData = recruitmentCpData[indexPath.row];
    RmCpMain *cpMain = [[RmCpMain alloc] init];
    [cpMain retain];
    
    int isBooked = [rowData[@"isBooked"] integerValue];
    cpMain.IsBooked = isBooked;
    cpMain.ID = rowData[@"cpMainID"];
    cpMain.Name = rowData[@"Name"];
    cpMain.Address = rowData[@"Address"];
    cpMain.OrderDate = rowData[@"AddDate"];
    cpMain.Lat = rowData[@"Lat"];
    cpMain.Lng = rowData[@"Lng"];
    cpMain.jobID = rowData[@"jobID"];
    cpMain.caMainID = rowData[@"caMainID"];
    cpMain.JobName = rowData[@"JobName"];
    
    //选择图标
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 22, 30, 45)];
    leftButton.tag = [rowData[@"cpMainID"] integerValue];
    UIImageView *imgCheck = [[UIImageView alloc] initWithFrame:CGRectMake(7, 15, 15, 15)];
    imgCheck.tag = isBooked;
    if (isBooked == 1) {
        //已经预约
        imgCheck.image = [UIImage imageNamed:@"checked.png"];
    }else{
        //没有预约才可以点击
        objc_setAssociatedObject(leftButton, "rmCpMain", cpMain, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [leftButton addTarget:self action:@selector(checkBoxBookinginterviewClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    imgCheck.image = [UIImage imageNamed:@"unChecked.png"];
    [leftButton addSubview:imgCheck];
   
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
    UILabel *lbWillRun;
    UIImageView *imgWillRun = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    if (isBooked == 1) {
        //没有图片，只显示“已预约”三个字
        lbWillRun = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, 40, 10)];
        lbWillRun.text = @"已预约";
        lbWillRun.font = [UIFont systemFontOfSize:12];
        lbWillRun.textColor = [UIColor grayColor];
        lbWillRun.textAlignment = NSTextAlignmentCenter;
    }else{
        //文字
        lbWillRun = [[UILabel alloc] initWithFrame:CGRectMake(-5, 35, 40, 10)];
        lbWillRun.text = @"预约面试";
        lbWillRun.font = [UIFont systemFontOfSize:10];
        lbWillRun.textColor = [UIColor colorWithRed:255.f/255.f green:90.f/255.f blue:40.f/255.f alpha:1];
        lbWillRun.textAlignment = NSTextAlignmentCenter;
        //图片
        imgWillRun.image = [UIImage imageNamed:@"ico_rm_group.png"];
        [rightButton addSubview:imgWillRun];
        //没有预约才可以点击
        [rightButton addTarget:self action:@selector(bookinginterview:) forControlEvents:UIControlEventTouchUpInside];
    }
   
    [rightButton addSubview:lbWillRun];
    rightButton.tag = [rowData[@"cpMainID"] integerValue];
    [cell.contentView addSubview:rightButton];
    
    [rightButton release];
    [lbWillRun release];
    [imgWillRun release];
    [lbTitle release];
    [lbPaInfo release];
    [lbBegin release];
    return cell;
}

//点击某一行,到达企业页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *jobSearchStoryboard = [UIStoryboard storyboardWithName:@"JobSearch" bundle:nil];
    CpMainViewController *cpMainCtrl = (CpMainViewController*)[jobSearchStoryboard instantiateViewControllerWithIdentifier: @"CpMainView"];
    cpMainCtrl.cpMainID = recruitmentCpData[indexPath.row][@"cpMainID"];
    [self.navigationController pushViewController:cpMainCtrl animated:true];
}

//点击下方预约面试(批量预约)
- (IBAction)btnBookAll:(id)sender {
    RmInviteCpViewController *rmInviteCpViewCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"RmInviteCpView"];
    rmInviteCpViewCtrl.strBeginTime = self.strBeginTime;
    rmInviteCpViewCtrl.strAddress = self.strAddress;
    rmInviteCpViewCtrl.strPlace = self.strPlace;
    rmInviteCpViewCtrl.strRmID = self.rmID;
    rmInviteCpViewCtrl.selectRmCps = checkedCpArray;
    [checkedCpArray retain];
    [self.navigationController pushViewController:rmInviteCpViewCtrl animated:YES];
}

//点击我要参会--进入邀请企业参会页面（预约一个）
-(void) bookinginterview:(UIButton *)sender{
    //NSLog(@"%d",sender.tag);
    RmInviteCpViewController *rmInviteCpViewCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"RmInviteCpView"];
    [self.navigationController pushViewController:rmInviteCpViewCtrl animated:YES];
}

//点击左侧小图标
-(void) checkBoxBookinginterviewClick:(UIButton *)sender{
    NSLog(@"选择的企业为：%d",sender.tag);
    RmCpMain *selectCp = (RmCpMain*)objc_getAssociatedObject(sender, "rmCpMain");
    //NSInteger cpID = [@(sender.tag) integerValue];
    UIImageView *imgView = [sender subviews][0];
    int tmpTag = imgView.tag;
    if (tmpTag == 1) {//如果是已经预约
        imgView.image = [UIImage imageNamed:@"unChecked.png"];
        //[checkedCpArray removeObject:@(cpID)];
        [checkedCpArray removeObject:(selectCp)];
    }else{
        imgView.image = [UIImage imageNamed:@"checked.png"];
        [checkedCpArray addObject: selectCp];
    }
    imgView.tag = !imgView.tag;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [recruitmentCpData count];
}

//每一行的高度
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
