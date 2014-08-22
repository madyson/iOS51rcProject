#import <UIKit/UIKit.h>

@interface CommonController : NSObject

+(CGSize)CalculateFrame:(NSString*) content
             fontDemond:(UIFont*) font
             sizeDemand:(CGSize) size;

+(NSDate *)dateFromString:(NSString *)dateString;
+(NSString *)getWeek:(NSDate *)date;
+(NSString *)stringFromDate:(NSDate *)date
                 formatType:(NSString *)formatType;
+(BOOL)checkPassword:(NSString *) strPsd;
-(BOOL)isMobileNumber:(NSString *)mobileNum;
-(BOOL)checkEmail:(NSString *) userName;
@end
