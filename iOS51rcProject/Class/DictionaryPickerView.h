#import <UIKit/UIKit.h>

typedef enum {
    DictionaryPickerWithRegionL3,
    DictionaryPickerWithRegionL2,
    DictionaryPickerWithJobType,
    DictionaryPickerWithIndustry
} DictionaryPickerType;

typedef enum {
    DictionaryPickerMulti,
    DictionaryPickerOne
} DictionaryPickerMode;

@class DictionaryPickerView;

@protocol DictionaryPickerDelegate <NSObject>

@optional
- (void)pickerDidChangeStatus:(DictionaryPickerView *)picker;

@end

@interface DictionaryPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (assign, nonatomic) id <DictionaryPickerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIPickerView *locatePicker;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (nonatomic) DictionaryPickerType pickerType;
@property (nonatomic) DictionaryPickerMode pickerMode;

- (id)initWithCustom:(DictionaryPickerType)pickerType
         pickerType:(DictionaryPickerMode)pickerMode
           delegate:(id <DictionaryPickerDelegate>)delegate;
- (void)showInView:(UIView *)view;
- (void)cancelPicker;

@end
