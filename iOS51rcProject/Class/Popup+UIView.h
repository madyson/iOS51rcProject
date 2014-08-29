#import <UIKit/UIKit.h>

typedef enum {
    PopupButtonTypeOK,
    PopupButtonTypeNone
} PopupButtonType;

@interface UIView (Popup)
- (UIView*)popupView:(UIView *)contentView
       buttonType:(PopupButtonType)buttonType;

- (void)closePopup;
@end
