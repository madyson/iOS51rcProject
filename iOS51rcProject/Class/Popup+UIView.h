#import <UIKit/UIKit.h>

typedef enum {
    PopupButtonTypeOK,
    PopupButtonTypeNone
} PopupButtonType;

@interface UIView (Popup)
- (void)popupView:(UIView *)contentView
       buttonType:(PopupButtonType)buttonType;

- (void)closePopup;
@end
