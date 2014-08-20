#import <UIKit/UIKit.h>
#import "DatePicker.h"
#import "LoadingAnimationView.h"

@interface RecruitmentListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *recruitmentData;
    NSMutableArray *placeData;
    NSInteger page;
    NSString *begindate;
    NSString *placeid;
    NSString *regionid;
    DatePicker *pickDate;
    LoadingAnimationView *loadView;
}
@end
