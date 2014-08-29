#import <UIKit/UIKit.h>
#import "Popup+UIView.h"

@interface CustomPopup : UIView
@property (nonatomic,retain) UIView* viewContent;
@property (nonatomic) PopupButtonType buttonType;
@property (nonatomic, retain) UIView* viewBody;
-(id) popupCvSelect:(NSMutableArray *)arrayCv;
-(void) showPopup:(UIView *)view;
-(void) showCvSelect:(NSString *)applyResult
                view:(UIView *)view;
-(void) closePopup;
@end
