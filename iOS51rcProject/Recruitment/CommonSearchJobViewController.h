
#import <UIKit/UIKit.h>
#import "Delegate/GoJobSearchResultListViewDelegate.h"
@interface CommonSearchJobViewController : UIViewController
{
    id<GoJobSearchResultListViewDelegate> searchDelegate;
}
@property (retain, nonatomic) IBOutlet UIView *viewSearchSelect;
@property (retain, nonatomic) IBOutlet UIButton *btnSearch;
@property (retain, nonatomic) IBOutlet UITextField *txtKeyWord;
@property (retain, nonatomic) IBOutlet UIButton *btnRegionSelect;
@property (retain, nonatomic) IBOutlet UILabel *lbRegionSelect;
@property (retain, nonatomic) IBOutlet UIButton *btnJobTypeSelect;
@property (retain, nonatomic) IBOutlet UILabel *lbJobTypeSelect;
@property (retain, nonatomic) IBOutlet UIButton *btnIndustrySelect;
@property (retain, nonatomic) IBOutlet UILabel *lbIndustrySelect;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollSearch;
@property (retain, nonatomic) UIView *viewHistory;
@property (retain, nonatomic) id<GoJobSearchResultListViewDelegate>searchDelegate;
@end
