#import "CustomPopup.h"

@implementation CustomPopup

-(id) popupCvSelect:(NSMutableArray *)arrayCv
{
    if (self = [super init]) {
        self.buttonType = PopupButtonTypeNone;
        self.viewContent = [[UIView alloc] init];
        float contentHeight = 15;
        if (arrayCv.count > 1) {
            for (NSDictionary* dicCv in arrayCv) {
                UIButton *btnRadio = [[UIButton alloc] initWithFrame:CGRectMake(20, contentHeight+3, 20, 20)];
                [btnRadio setImage:[UIImage imageNamed:@"radio_unsel.png"] forState:UIControlStateNormal];
                [btnRadio setTitle:dicCv[@"ID"] forState:UIControlStateNormal];
                [btnRadio setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                btnRadio.tag = 1;
                [self.viewContent addSubview:btnRadio];
                
                UILabel *lbCvName = [[UILabel alloc] initWithFrame:CGRectMake(50, contentHeight, 200, 30)];
                [lbCvName setText:dicCv[@"Name"]];
                [self.viewContent addSubview:lbCvName];
                
                contentHeight+=50;
            }
            UIButton *btnConfirm = [[UIButton alloc] initWithFrame:CGRectMake(30, contentHeight-10, 80, 30)];
            [btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
            [btnConfirm setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:90.f/255.f blue:39.f/255.f alpha:1]];
            btnConfirm.layer.cornerRadius = 5;
            [self.viewContent addSubview:btnConfirm];
            [btnConfirm release];
            
            UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(130, contentHeight-10, 80, 30)];
            [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
            [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btnCancel setBackgroundColor:[UIColor colorWithRed:236.f/255.f green:236.f/255.f blue:236.f/255.f alpha:1]];
            btnCancel.layer.cornerRadius = 5;
            [self.viewContent addSubview:btnConfirm];
            [btnCancel addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
            [self.viewContent addSubview:btnCancel];
            [btnCancel release];
            
            contentHeight+=40;
        }
        [self.viewContent setFrame:CGRectMake(0, 0, 240, contentHeight)];
        [self.viewContent setBackgroundColor:[UIColor grayColor]];
    }
    return self;
}

-(void) showCvSelect:(NSString *)applyResult
                view:(UIView *)view
{
    self.viewBody = [view popupView:self.viewContent buttonType:PopupButtonTypeNone];
}

-(void) showPopup:(UIView *)view
{
    [view popupView:self.viewContent buttonType:PopupButtonTypeNone];
}

-(void) closePopup
{
    [self.viewBody closePopup];
}

@end
