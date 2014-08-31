
#import "RmInviteCpViewController.h"
#import "../Class/CommonController.h"
#import "DictionaryPickerView.h"
#import "Toast+UIView.h"
#import "NetWebServiceRequest.h"
#import "RmCpJobListViewController.h"

//邀请企业参会
@interface RmInviteCpViewController () <NetWebServiceRequestDelegate, DictionaryPickerDelegate,DatePickerDelegate>
@property (retain, nonatomic) IBOutlet UILabel *lbTime;
@property (retain, nonatomic) IBOutlet UILabel *lbAddress;
@property (retain, nonatomic) IBOutlet UILabel *lbPlace;

@property (retain, nonatomic) IBOutlet UIView *viewSearchSelect;

@property (retain, nonatomic) IBOutlet UIButton *btnTimeSelect;
@property (retain, nonatomic) IBOutlet UIButton *btnAddressSelect;
@property (retain, nonatomic) IBOutlet UIButton *btnPlaceSelect;

@property (strong, nonatomic) DictionaryPickerView *DictionaryPicker;
@property (retain, nonatomic) NetWebServiceRequest *runningRequestGetJobs;
@property (retain, nonatomic) NetWebServiceRequest *runningRequestGetPlace;
@property (retain, nonatomic) IBOutlet UIView *ViewRmInfo;

@end

@implementation RmInviteCpViewController

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
    settedCpID = @"";
    settedJobID = @"";
    settedJobName = @"";
    
    self.ViewRmInfo.layer.cornerRadius = 5;
    self.ViewRmInfo.layer.borderWidth = 1;
    self.ViewRmInfo.layer.borderColor = [[UIColor colorWithRed:236.f/255.f green:236.f/255.f blue:236.f/255.f alpha:1] CGColor];
                                          
    UIButton *button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [button setTitle: @"邀请企业参会" forState: UIControlStateNormal];
    [button sizeToFit];
    self.navigationItem.titleView = button;
    
    //自定义从下一个视图左上角，“返回”本视图的按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"后退" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem=backButton;
    //NSString *strWeek = [CommonController getWeek:self.dtBeginTime];
    //NSString *strBeginDate = [CommonController stringFromDate:self.dtBeginTime formatType:@"MM-dd"];
    //self.lbTime.text = [NSString stringWithFormat:@"%@ (%@)",strBeginDate,strWeek];
    //上一个页面传入的值
    self.lbTime.text = self.strBeginTime;
    self.lbAddress.text = self.strAddress;
    self.lbPlace.text = self.strPlace;
    //默认参数
    regionID = @"32";
    beginDate = self.strBeginTime;   

    //初始化时间选择控件
    pickDate = [[DatePicker alloc] init];
    pickDate.delegate = self;

    [self.btnTimeSelect addTarget:self action:@selector(showDateSelect) forControlEvents:UIControlEventTouchUpInside];
    [self.btnAddressSelect addTarget:self action:@selector(showRegionSelect) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPlaceSelect addTarget:self action:@selector(showPlaceSelect) forControlEvents:UIControlEventTouchUpInside];

    //数据加载等待控件初始化
    loadView = [[LoadingAnimationView alloc] initWithFrame:CGRectMake(140, 100, 80, 98) loadingAnimationViewStyle:LoadingAnimationViewStyleCarton target:self];
    //开始等待动画
    [loadView startAnimating];
    
    //场馆初始化
    [self reloadPlace];
    //加载选择的公司
    [self reloadJobs:self.selectRmCps];
}

//加载场馆
- (void)reloadPlace {
    //加载场馆
    NSMutableDictionary *dicParam = [[ NSMutableDictionary alloc] init];
    [dicParam setObject:beginDate forKey:@"strBeginDate"];
    [dicParam setObject:regionID forKey:@"RegionID"];
    [dicParam setObject:@"1" forKey:@"isDistinct"];
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:@"GetPlaceListByBeginDate" Params:dicParam];
    [request setDelegate:self];
    [request startAsynchronous];
    request.tag = 2;
    self.runningRequestGetPlace = request;
    [dicParam release];
}

//加载公司和职位
-(void)reloadJobs:(NSArray*) rmCpInfos{
    UIView *cpListView = [[UIView alloc]initWithFrame:CGRectMake(20, self.ViewRmInfo.frame.origin.y+self.ViewRmInfo.frame.size.height+20, 280, 70*rmCpInfos.count)];
    for (int i=0; i<rmCpInfos.count; i++) {
        RmCpMain *rmCp = rmCpInfos[i];
         UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 70*i, 280, 60)];
        [btnRight addTarget:self action:@selector(showJobSelect:) forControlEvents:UIControlEventTouchUpInside];
        btnRight.tag = [rmCp.ID integerValue];
        //JobName
        CGSize titleSize = CGSizeMake(240, 20.0f);
        CGSize labelSize = [CommonController CalculateFrame:rmCp.JobName fontDemond:[UIFont systemFontOfSize:14] sizeDemand:titleSize];
        UILabel *lbJobName = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, labelSize.width, 20)];
        lbJobName.text = rmCp.JobName;
        lbJobName.font = [UIFont systemFontOfSize:14];
        [btnRight addSubview:lbJobName];
        [lbJobName release];
        //公司名称
        UILabel *lbCpName = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 240, 20)];
        lbCpName.text = rmCp.Name;
        lbCpName.font = [UIFont systemFontOfSize:14];
        lbCpName.textColor = [UIColor grayColor];
        [btnRight addSubview:lbCpName];
        [lbCpName release];
        //右箭头
        UIImageView *imgRight = [[UIImageView alloc]initWithFrame:CGRectMake(260, 25, 10, 17)];
        imgRight.image = [UIImage imageNamed:@"ico_select_right.png"];
        [cpListView addSubview:btnRight];
        [btnRight addSubview:imgRight];
        [btnRight release];
        [imgRight release];
        //分隔线
        UILabel *lbLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 70*i+69.5, 280, 0.5)];
        lbLine.layer.borderWidth = 0;
        lbLine.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
        [cpListView addSubview:lbLine];
        [lbLine release];
        
        [cpListView addSubview:btnRight];
    }
    cpListView.layer.cornerRadius = 5;
    cpListView.layer.borderWidth = 1;
    cpListView.layer.borderColor = [[UIColor colorWithRed:236.f/255.f green:236.f/255.f blue:236.f/255.f alpha:1] CGColor];
    
    [self.view addSubview: cpListView];
    [cpListView release];
}

//成功
- (void)netRequestFinished:(NetWebServiceRequest *)request
      finishedInfoToResult:(NSString *)result
              responseData:(NSMutableArray *)requestData
{
    if (request.tag == 1) {        
        //结束等待动画
        [loadView stopAnimating];
    }
    else {
        NSMutableArray *arrPlace = [[NSMutableArray alloc] init];
        for (int i = 0; i < requestData.count; i++) {
            NSDictionary *dicPlace = [[[NSDictionary alloc] initWithObjectsAndKeys:
                                       requestData[i][@"id"],@"id",
                                       requestData[i][@"PlaceName"],@"value"
                                       ,nil] autorelease];
            [arrPlace addObject:dicPlace];
        }
        placeData = arrPlace;
        //[loadView startAnimating];
        [loadView stopAnimating];
    }
}

//点击转到职位选择页面
-(void)showJobSelect:(UIButton*)sender{
    RmCpJobListViewController *jobListCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"RmCpJobListViewController"];
    jobListCtrl.cpMainID = [NSString stringWithFormat:@"%d", sender.tag];
    jobListCtrl.delegate = self;
    [self.navigationController pushViewController:jobListCtrl animated:YES];
}

//代理
-(void) SetJob:(NSString *) cpID jobID:(NSString*)jobID JobName:(NSString*) jobName{
    [self reloadJobs:self.selectRmCps];
}

-(void)showDateSelect{
    [pickDate showDatePicker:self dateTitle:@"请选择举办日期"];
}

//选择日期完成
-(void)saveDate:(NSDate *)selectDate{
    NSString *strSelDate = [CommonController stringFromDate:selectDate formatType:@"MM-dd"];
    self.lbTime.text = strSelDate;
    beginDate = [CommonController stringFromDate:selectDate formatType:@"yyyy-MM-dd"];
    [beginDate retain];
    [pickDate removeDatePicker];
}

//重置时间
-(void)resetDate{
    self.lbTime.text = @"日期";
    beginDate = @"";
    //page = 1;
    //[self onSearch];
    [pickDate removeDatePicker];
    //开始等待动画
    //[loadView startAnimating];
}

//地区选择
-(void)showRegionSelect {
    [self cancelDicPicker];
    self.DictionaryPicker = [[[DictionaryPickerView alloc] initWithCustom:DictionaryPickerWithRegionL2 pickerMode:DictionaryPickerModeOne pickerInclude:DictionaryPickerIncludeParent delegate:self defaultValue:regionID defaultName:@"山东省"] autorelease];
    
    self.DictionaryPicker.tag = 1;
    [self.DictionaryPicker showInView:self.view];
}

//场馆选择
- (void)showPlaceSelect {
    if ([placeData count] == 0) {
        [self.view makeToast:@"没有该地区的场馆信息"];
        return;
    }
    [self cancelDicPicker];
    self.DictionaryPicker = [[[DictionaryPickerView alloc] initWithDictionary:self defaultArray:placeData defalutValue:placeID] autorelease];
    self.DictionaryPicker.tag = 2;
    [self.DictionaryPicker showInView:self.view];
}

- (void)pickerDidChangeStatus:(DictionaryPickerView *)picker
                selectedValue:(NSString *)selectedValue
                 selectedName:(NSString *)selectedName {
    [self cancelDicPicker];
    if (picker.tag == 1) { //地区选择
        regionID = selectedValue;
        placeID = @"";
        [self.lbPlace setText:@"全部场馆"];
        //[self.lbProvince setText:selectedName];
        //加载场馆
        [self reloadPlace];
    }
    else { //场馆选择
        placeID = selectedValue;
        [self.lbPlace setText:selectedName];
    }
    //重新加载列表
    //page = 1;
    //[self onSearch];
    //开始等待动画
    //[loadView startAnimating];
}

-(void)cancelDicPicker
{
    [self.DictionaryPicker cancelPicker];
    self.DictionaryPicker.delegate = nil;
    self.DictionaryPicker = nil;
    [_DictionaryPicker release];
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
    [_lbTime release];
    [_lbAddress release];
    [_lbPlace release];
    [_ViewRmInfo release];
    [super dealloc];
}
@end
