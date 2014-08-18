#import "RecruitmentListViewController.h"
#import "NetWebServiceRequest.h"
#import "GDataXMLNode.h"
#import "CommonController.h"

@interface RecruitmentListViewController ()<NetWebServiceRequestDelegate>
    @property (retain, nonatomic) IBOutlet UITableView *tvRecruitmentList;
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
    self.tvRecruitmentList.separatorStyle = UITableViewCellSeparatorStyleNone;
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

    
    //显示举办时间 举办场馆 具体地址
    UILabel *lbBegin = [[UILabel alloc] initWithFrame:CGRectMake(20, (labelSize.height + 15), titleWidth, 10)];
    NSString *strBeginDate = rowData[@"BeginDate"];
    lbBegin.text = [NSString stringWithFormat:@"举办时间：%@",strBeginDate];
    lbBegin.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:(lbBegin)];
//    var lbBegin = UILabel()
//    var strBeginDate = rowData["BeginDate"]["text"] as NSString
//    var dateFormatter = NSDateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//    var dtBeginDate = dateFormatter.dateFromString(strBeginDate.stringByReplacingOccurrencesOfString("T", withString: " ").substringFrom(0, to: 18))
//    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//    strBeginDate = dateFormatter.stringFromDate(dtBeginDate)
//    var strWeek = ""
//    var calDate:NSCalendar = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)
//    var week = calDate.component(NSCalendarUnit.CalendarUnitWeekday, fromDate: dtBeginDate)
//    switch week{
//    case 1:
//        strWeek = "周日"
//    case 2:
//        strWeek = "周一"
//    case 3:
//        strWeek = "周二"
//    case 4:
//        strWeek = "周三"
//    case 5:
//        strWeek = "周四"
//    case 6:
//        strWeek = "周五"
//    case 7:
//        strWeek = "周六"
//    default:
//        strWeek = "周日"
//    }
//    lbBegin.text = "举办时间：\(strBeginDate) \(strWeek)"
//    lbBegin.font = UIFont.systemFontOfSize(12)
//    lbBegin.frame = CGRectMake(20, (labelSize.height + 15), titleWidth, 10)
//    cell.contentView.addSubview(lbBegin)
//    
//    var lbPlace = UILabel()
//    var strPlace = rowData["PlaceName"]["text"] as String
//    lbPlace.text = "举办场馆：\(strPlace)"
//    lbPlace.font = UIFont.systemFontOfSize(12)
//    lbPlace.frame = CGRectMake(20, (labelSize.height + 35), titleWidth, 10)
//    cell.contentView.addSubview(lbPlace)
//    
//    var lbAddress = UILabel()
//    var strAddress = rowData["Address"]["text"] as String
//    lbAddress.text = "具体地址：\(strAddress)"
//    lbAddress.font = UIFont.systemFontOfSize(12)
//    lbAddress.frame = CGRectMake(20, (labelSize.height + 55), titleWidth, 10)
//    cell.contentView.addSubview(lbAddress)
//    
//    var lbSeparator = UILabel(frame: CGRect(x: 0, y: 115, width: 320, height: 1))
//    lbSeparator.backgroundColor = UIColor.grayColor()
//    cell.contentView.addSubview(lbSeparator)
//    
//    //显示状态
//    var strEndDate = rowData["EndDate"]["text"] as NSString
//    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//    var dtEndDate = dateFormatter.dateFromString(strEndDate.stringByReplacingOccurrencesOfString("T", withString: " ").substringFrom(0, to: 18))
//    
//    dateFormatter.dateFormat = "yyyy-MM-dd"
//    var compareResult = dtBeginDate.compare(NSDate())
//    var recruitmentStatus = 0
//    switch compareResult{
//    case NSComparisonResult.OrderedAscending:
//        var compareResult2 = dtEndDate.compare(NSDate())
//        if(compareResult2 == NSComparisonResult.OrderedDescending){
//            recruitmentStatus = 1
//        }
//        else{
//            recruitmentStatus = 2
//        }
//    case NSComparisonResult.OrderedDescending:
//        recruitmentStatus = 3
//    case NSComparisonResult.OrderedSame:
//        recruitmentStatus = 1
//    default:
//        recruitmentStatus = 0
//    }
//    recruitmentStatus = 1
//    switch recruitmentStatus{
//    case 1:
//        println("ing")
//        var viewGoing = UIView(frame: CGRect(x: 250, y: 60, width: 60, height: 60))
//        var lbGoing = UILabel(frame: CGRect(x: 0, y: 30, width: 60, height: 10))
//        lbGoing.font = UIFont(name: "Arial", size: 12.0)
//        lbGoing.text = "正在进行"
//        
//        viewGoing.addSubview(lbGoing)
//        viewGoing.backgroundColor = UIColor.yellowColor()
//        cell.contentView.addSubview(viewGoing)
//    case 2:
//        println("expired")
//    case 3:
//        println("pre")
//    default:
//        println("error")
//    }
//    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [recruitmentData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

//失败
- (void)netRequestFailed:(NetWebServiceRequest *)request didRequestError:(int *)error
{
    
}

//成功
- (void)netRequestFinished:(NetWebServiceRequest *)request
      finishedInfoToResult:(NSString *)result
              responseData:(NSArray *)requestData
{
    recruitmentData = requestData;
    [recruitmentData retain];
    [self.tvRecruitmentList reloadData];
}

- (void)dealloc {
    [recruitmentData release];
    [_tvRecruitmentList release];
    [super dealloc];
}
@end
