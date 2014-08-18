#import <UIKit/UIKit.h>
#import "DatePicker.h"
#import "LoadingAnimationView.h"

@interface RecruitmentListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *recruitmentData;
    NSInteger page;
    NSString *begindate;
    NSString *placeid;
    DatePicker *pickDate;
    LoadingAnimationView *loadView;
}
@end
