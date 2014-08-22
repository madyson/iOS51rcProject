#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController
@property (nonatomic, assign) UITableView *tvMenu;

-(void)changeMenuItem:(int)item;
@end