#import "Popup+UIView.h"
#import <objc/runtime.h>

@implementation UIView (Popup)
- (void)popupView:(UIView *)contentView
       buttonType:(PopupButtonType)buttonType
{
    //加背景
    UIView *viewBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [viewBackground setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
    
    //加内容
    UIView *viewInner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentView.frame.size.width+20, contentView.frame.size.height+20)];
    [viewInner setBackgroundColor:[UIColor whiteColor]];
    viewInner.layer.cornerRadius = 5;
    viewInner.center = self.center;
    viewInner.alpha = 0;
    CGRect contentFrame = contentView.frame;
    contentFrame.origin = CGPointMake(10, 10);
    [contentView setFrame:contentFrame];
    [viewInner addSubview:contentView];
    
    //加按钮
    if (buttonType == PopupButtonTypeOK) {
        UIButton *btnOK = [[UIButton alloc] initWithFrame:CGRectMake(viewInner.frame.size.width/2-contentView.frame.size.width/6, contentView.frame.size.height+20, contentView.frame.size.width/3, 30)];
        [btnOK setBackgroundColor:[UIColor colorWithRed:248.f/255.f green:248.f/255.f blue:248.f/255.f alpha:1]];
        [btnOK setTitle:@"知道了" forState:UIControlStateNormal];
        [btnOK setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnOK.titleLabel.font = [UIFont systemFontOfSize:12];
        btnOK.layer.cornerRadius = 5;
        btnOK.layer.borderWidth = 1;
        btnOK.layer.borderColor = [[UIColor grayColor] CGColor];
        [btnOK addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
        CGRect innerFrame = viewInner.frame;
        innerFrame.size.height = innerFrame.size.height+40;
        viewInner.frame = innerFrame;
        [viewInner addSubview:btnOK];
    }
    //将内容放到背景上
    [viewBackground addSubview:viewInner];
    [self addSubview:viewBackground];
    
    [UIView animateWithDuration:0.7
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         viewInner.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         
                     }];
    [viewInner release];
    [viewBackground release];
    objc_setAssociatedObject(self, @"popupview", viewBackground, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)closePopup
{
    UIView *view = (UIView *)objc_getAssociatedObject(self, @"popupview");
    [view removeFromSuperview];
}

@end
