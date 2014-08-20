#import "RecruitmentViewController.h"
#import "NetWebServiceRequest.h"
#import "LoadingAnimationView.h"
#import "CommonController.h"

@interface RecruitmentViewController () <NetWebServiceRequestDelegate>

@property (retain, nonatomic) IBOutlet UILabel *lbRmTitle;
@property (retain, nonatomic) IBOutlet UILabel *lbRmCp;
@property (retain, nonatomic) IBOutlet UILabel *lbRmPa;
@property (retain, nonatomic) IBOutlet UIButton *btnRmPa;
@property (retain, nonatomic) IBOutlet UILabel *lbPlace;
@property (retain, nonatomic) IBOutlet UIButton *btnRmCp;
@property (retain, nonatomic) IBOutlet UILabel *lbAddress;
@property (retain, nonatomic) IBOutlet UILabel *lbRunDate;
@property (retain, nonatomic) IBOutlet UILabel *lbViewNumber;
@property (nonatomic, retain) NetWebServiceRequest *runningRequest;
@property (nonatomic, retain) LoadingAnimationView *loading;
@end

@implementation RecruitmentViewController
@synthesize recruitmentID = _recruitmentID;
@synthesize runningRequest = _runningRequest;
@synthesize loading = _loading;

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
    self.btnRmCp.layer.masksToBounds = YES;
    self.btnRmCp.layer.borderWidth = 1.0;
    self.btnRmCp.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.btnRmPa.layer.masksToBounds = YES;
    self.btnRmPa.layer.borderWidth = 1.0;
    self.btnRmPa.layer.borderColor = [[UIColor grayColor] CGColor];
    
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    [dicParam setObject:self.recruitmentID forKey:@"ID"];
    [dicParam setObject:@"0" forKey:@"paMainID"];
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:@"GetOneRectuitment" Params:dicParam];
    [request setDelegate:self];
    [request startAsynchronous];
    self.runningRequest = request;
    
    self.loading = [[LoadingAnimationView alloc] initWithFrame:CGRectMake(140, 100, 80, 98) loadingAnimationViewStyle:LoadingAnimationViewStyleCarton target:self];
    [self.loading startAnimating];
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

- (void)netRequestFinished:(NetWebServiceRequest *)request
      finishedInfoToResult:(NSString *)result
              responseData:(NSArray *)requestData
{
    NSString *recruitmentTitle = requestData[0][@"RecruitmentName"];
    
    CGSize labelSize = [CommonController CalculateFrame:recruitmentTitle fontDemond:[UIFont systemFontOfSize:16] sizeDemand:CGSizeMake(self.lbRmTitle.frame.size.width, 500)];
    
    self.lbRmTitle.frame = CGRectMake(self.lbRmTitle.frame.origin.x, self.lbRmTitle.frame.origin.y, labelSize.width, labelSize.height);
    self.lbRmTitle.lineBreakMode = NSLineBreakByCharWrapping;
    self.lbRmTitle.numberOfLines = 0;
    
    [self.lbRmTitle setText:recruitmentTitle];
    [self.lbViewNumber setText:[NSString stringWithFormat:@"总浏览量：%@",requestData[0][@"ViewNumber"]]];
    [self.loading stopAnimating];
}

- (void)dealloc {
    [_lbViewNumber release];
    [_lbRmPa release];
    [_lbRmCp release];
    [_lbRunDate release];
    [_lbPlace release];
    [_lbAddress release];
    [_lbRmTitle release];
    [_btnRmCp release];
    [_btnRmPa release];
    [super dealloc];
}
@end
