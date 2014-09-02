#import <UIKit/UIKit.h>
#import "LoadingAnimationView.h"

@interface GRListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *gRListData;
    NSMutableArray *placeData;
    NSInteger page;    
    NSString *regionid;    
    LoadingAnimationView *loadView;
}
@end