#import <UIKit/UIKit.h>

@protocol DatePickerDelegate <NSObject>

-(void)saveDate:(NSDate *)selectDate;
-(void)resetDate;

@end

@interface DatePicker : NSObject
{
    id<DatePickerDelegate> delegate;
    UIDatePicker *datePicker;
    UIViewController *viewController;
    UIView *datePanel;
}

@property(nonatomic,assign)id<DatePickerDelegate> delegate;
- (void)showDatePicker:(UIViewController *)viewC
             dateTitle:(NSString *)title;

- (void)confirmClick;
- (void)resetClick;
- (void)removeDatePicker;
@end