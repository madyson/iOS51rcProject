#import <UIKit/UIKit.h>
#import "Popup+UIView.h"

@protocol CustomPopupDelegate <NSObject>
@required
- (void) getPopupValue:(NSString *)value;
@end

@interface CustomPopup : UIView
@property (assign, nonatomic) id <CustomPopupDelegate> delegate;
@property (nonatomic, retain) UIView* viewContent;
@property (nonatomic, retain) UIView* viewSuper;
@property (nonatomic) PopupButtonType buttonType;
@property (nonatomic, retain) NSMutableArray* arrCvButton;
@property (nonatomic, retain) NSString* selectCvID;
-(id) popupCvSelect:(NSMutableArray *)arrayCv
               view:(UIView *)view;
-(void) showPopup:(UIView *)view;
-(void) showJobApplyCvSelect:(NSString *)applyResult;
-(void) closePopup;
@end
