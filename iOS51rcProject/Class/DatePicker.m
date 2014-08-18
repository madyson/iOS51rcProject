#import "DatePicker.h"

@implementation DatePicker
@synthesize delegate;
- (void)showDatePicker:(UIViewController *)viewC
             dateTitle:(NSString *)title
{
    viewController = viewC;
    datePanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 640)];
    datePanel.backgroundColor = [UIColor colorWithRed:255.f/255.f green:255.f/255.f blue:255.f/255.f alpha:0.9];
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 320, 50)];
    dateLabel.text = title;
    dateLabel.textColor = [UIColor blackColor];
    [datePanel addSubview:dateLabel];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 150, 320, 216)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.locale = locale;
    [datePanel addSubview:datePicker];

    UIButton *dateConfirm = [[UIButton alloc] initWithFrame:CGRectMake(50, (150 + datePicker.bounds.size.height), 100, 50)];
    [dateConfirm setTitle:@"确定" forState:UIControlStateNormal];
    dateConfirm.backgroundColor = [UIColor blackColor];
    [dateConfirm addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [datePanel addSubview:dateConfirm];
    
    UIButton *dateReset = [[UIButton alloc] initWithFrame:CGRectMake(60 + (dateConfirm.bounds.size.width), (150 + datePicker.bounds.size.height), 100, 50)];
    [dateReset setTitle:@"清空" forState:UIControlStateNormal];
    dateReset.backgroundColor = [UIColor blackColor];
    [dateReset addTarget:self action:@selector(resetClick) forControlEvents:UIControlEventTouchUpInside];
    [datePanel addSubview:dateReset];
    [viewC.view addSubview:datePanel];

    [dateConfirm release];
    [dateReset release];
    [locale release];
}

- (void)confirmClick
{
    [delegate saveDate:[datePicker date]];
}

- (void)resetClick
{
    [delegate resetDate];
}

- (void)removeDatePicker
{
    [datePanel removeFromSuperview];
}

- (void)dealloc
{
    [datePanel release];
    [datePicker release];
    [super dealloc];
}
@end
