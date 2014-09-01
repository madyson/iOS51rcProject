#import "RmSearchJobForInviteViewController.h"
#import "CommonSearchJobViewController.h"
#import "RmInviteCpListFromSearchViewController.h"

@interface RmSearchJobForInviteViewController ()
@property (retain, nonatomic) CommonSearchJobViewController  *searchViewCtrl;
@end

@implementation RmSearchJobForInviteViewController

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
    //加载搜索页面
    self.searchViewCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"CommonSearchJobView"];
    self.searchViewCtrl.view.frame = CGRectMake(0, 30, 320, self.searchViewCtrl.view.frame.size.height - 30);
    self.searchViewCtrl.searchDelegate = self;
    [self.view addSubview:self.searchViewCtrl.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//搜索职位的代理
-(void) gotoJobSearchResultListView:(NSString*) strSearchRegion SearchJobType:(NSString*) strSearchJobType SearchIndustry:(NSString *) strSearchIndustry SearchKeyword:(NSString *) strSearchKeyword SearchRegionName:(NSString *) strSearchRegionName SearchJobTypeName:(NSString *) strSearchJobTypeName SearchCondition:(NSString *) strSearchCondition{    
      UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
      RmInviteCpListFromSearchViewController *rmInviteCpListFromSearchViewCtrl = [mainStoryboard                                                                                  instantiateViewControllerWithIdentifier: @"RmInviteCpListFromSearchView"];
    
      rmInviteCpListFromSearchViewCtrl.searchRegion = strSearchRegion;
      rmInviteCpListFromSearchViewCtrl.searchJobType = strSearchJobType;
      rmInviteCpListFromSearchViewCtrl.searchIndustry = strSearchIndustry;
      rmInviteCpListFromSearchViewCtrl.searchKeyword = strSearchKeyword;
      rmInviteCpListFromSearchViewCtrl.searchRegionName = strSearchRegionName;
      rmInviteCpListFromSearchViewCtrl.searchJobTypeName = strSearchJobTypeName;
      rmInviteCpListFromSearchViewCtrl.searchCondition = strSearchCondition;
      [self.navigationController pushViewController:rmInviteCpListFromSearchViewCtrl animated:true];
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

@end
