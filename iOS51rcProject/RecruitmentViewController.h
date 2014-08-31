#import <UIKit/UIKit.h>

@interface RecruitmentViewController : UIViewController
{
    NSString *strAddress;
    NSString *strPlace;
    NSDate *dtBeginTime;
}

@property (assign,nonatomic) NSString *recruitmentMobile;
@property (assign,nonatomic) NSString *recruitmentTelephone;
@property (retain,nonatomic) NSString *recruitmentID;

@end
