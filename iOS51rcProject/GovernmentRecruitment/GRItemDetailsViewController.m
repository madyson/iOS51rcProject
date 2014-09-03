#import "GRItemDetailsViewController.h"
#import "NetWebServiceRequest.h"
#import "LoadingAnimationView.h"
#import "CommonController.h"

@interface GRItemDetailsViewController ()<NetWebServiceRequestDelegate>
@property (nonatomic, retain) NetWebServiceRequest *runningRequest;
@property (nonatomic, retain) LoadingAnimationView *loading;
@property (retain, nonatomic) IBOutlet UIScrollView *newsScroll;
@end

@implementation GRItemDetailsViewController
@synthesize runningRequest = _runningRequest;
@synthesize loading = _loading;
@synthesize strNewsID;

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
    [button setTitle: @"政府招考详情" forState: UIControlStateNormal];
    [button sizeToFit];
    self.navigationItem.titleView = button;
    //返回按钮
    UIButton *leftBtn = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)] autorelease];
    [leftBtn addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *lbLeft = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)] autorelease];
    lbLeft.text = @"政府招考";
    lbLeft.font = [UIFont systemFontOfSize:13];
    //lbLeft.textColor = [UIColor colorWithRed:255.f/255.f green:90.f/255.f blue:39.f/255.f alpha:1];
    lbLeft.textColor = [UIColor whiteColor];
    [leftBtn addSubview:lbLeft];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=backButton;
    
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    [dicParam setObject:self.strNewsID forKey:@"strNewsID"];
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:@"GetNewsContentByID" Params:dicParam];
    [request setDelegate:self];
    [request startAsynchronous];
    self.runningRequest = request;
    self.loading = [[LoadingAnimationView alloc] initWithFrame:CGRectMake(140, 100, 80, 98) loadingAnimationViewStyle:LoadingAnimationViewStyleCarton target:self];
    [self.loading startAnimating];
}

- (void) btnBackClick:(UIButton*) sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidScroll......");
}


- (void)netRequestFinished:(NetWebServiceRequest *)request
      finishedInfoToResult:(NSString *)result
              responseData:(NSArray *)requestData
{
    [self didReceiveNews:requestData];
}

-(void) didReceiveNews:(NSArray *) requestData
{
    NSDictionary *dicCpMain = requestData[0];
    UIView *tmpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    //标题
    NSString *strTitle = dicCpMain[@"title"];
    CGSize labelSize = [CommonController CalculateFrame:strTitle fontDemond:[UIFont systemFontOfSize:14] sizeDemand:CGSizeMake(310, 200)];
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, labelSize.width, 40)];
    lbTitle.lineBreakMode = NSLineBreakByCharWrapping;
    lbTitle.numberOfLines = 0;
    [lbTitle setText:strTitle];
    [tmpView addSubview:lbTitle];
    
    //标签
    NSString *strTag = [NSString stringWithFormat:@"标     签：[%@]",dicCpMain[@"tag"]];
    int y = lbTitle.frame.origin.y + lbTitle.frame.size.height + 5;
    UILabel *lbTag = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 300, 15)];
    lbTag.text = strTag;
    lbTag.font = [UIFont systemFontOfSize:12];
    [tmpView addSubview:lbTag];
    
    //发布日期
    NSString *strDate = dicCpMain[@"refreshdate"];
    NSDate *dtDate = [CommonController dateFromString:strDate];
    strDate = [CommonController stringFromDate:dtDate formatType:@"MM-dd HH:mm"];
    strDate = [NSString stringWithFormat:@"发布日期：%@",strDate];
    y = lbTag.frame.origin.y + lbTag.frame.size.height + 5;
    UILabel *lbDate = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 300, 15)];
    lbDate.text = strDate;
    lbDate.font = [UIFont systemFontOfSize:12];
    [tmpView addSubview:lbDate];
    
    //阅读数
    NSString *strViewCount = [NSString stringWithFormat:@"阅 读 数：%@",dicCpMain[@"ViewNumber"]];
    y = lbDate.frame.origin.y + lbDate.frame.size.height + 5;
    UILabel *lbViewCount = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 300, 15)];
    lbViewCount.text = strViewCount;
    lbViewCount.font = [UIFont systemFontOfSize:12];
    [tmpView addSubview:lbViewCount];
    
    //横线
    y = lbViewCount.frame.origin.y+lbViewCount.frame.size.height + 2;
    UILabel *lbLine = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 310, 0.5)];
    lbLine.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    lbLine.layer.borderWidth = 0;
    [tmpView addSubview:lbLine];
    
    //正文
    NSString *strContent =[self FilterHtml: dicCpMain[@"Content"]];
    labelSize = [CommonController CalculateFrame:strContent fontDemond:[UIFont systemFontOfSize:12] sizeDemand:CGSizeMake(300, 5000)];
    y = lbLine.frame.origin.y + lbLine.frame.size.height + 5;
    UILabel *lbContent = [[UILabel alloc] initWithFrame:CGRectMake(10, y, labelSize.width, labelSize.height)];
    lbContent.lineBreakMode = NSLineBreakByCharWrapping;
    lbContent.numberOfLines = 0;
    lbContent.text = strContent;
    lbContent.font = [UIFont systemFontOfSize:12];
    [tmpView addSubview:lbContent];

    //来源
    y = (lbContent.frame.origin.y + lbContent.frame.size.height);
    UILabel *lbAuthor = [[UILabel alloc] initWithFrame:CGRectMake(100, y, 200, 15)];
    lbAuthor.text = [NSString stringWithFormat:@"来源：%@", dicCpMain[@"author"]];
    lbAuthor.textAlignment = NSTextAlignmentRight;
    lbAuthor.font = [UIFont systemFontOfSize:11];
    lbAuthor.textColor = [UIColor grayColor];
    [tmpView addSubview:lbAuthor];
    
    //加到滚动窗口上
    y = lbAuthor.frame.origin.y+lbAuthor.frame.size.height;
    tmpView.frame = CGRectMake(0, 0, 320, y);
    [self.newsScroll addSubview:tmpView];
    
    //屏幕滚动
    //self.newsScroll.frame = CGRectMake(self.newsScroll.frame.origin.x, self.newsScroll.frame.origin.y, self.newsScroll.frame.size.width, self.newsScroll.frame.size.height-5);
    [self.newsScroll setContentSize:CGSizeMake(320, y + 10)];
    [self.loading stopAnimating];
    [lbTitle release];
    [lbTag release];
    [lbViewCount release];
    [lbDate release];
    [lbLine release];
    [lbContent release];
    [lbAuthor release];
    [tmpView release];
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

//过滤Html标签
- (NSString *) FilterHtml :(NSString*) content
{
    content =[content stringByReplacingOccurrencesOfString:@"<br> <br>" withString:@"\n"];
    content =[content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    content =[content stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
    content =[content stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
    content =[content stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    content =[content stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    content =[content stringByReplacingOccurrencesOfString:@"<strong>" withString:@""];
    content =[content stringByReplacingOccurrencesOfString:@"</strong>" withString:@""];
    return content;
}
- (void)dealloc {
    [_newsScroll release];
    [super dealloc];
}
@end
