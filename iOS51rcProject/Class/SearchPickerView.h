#import <UIKit/UIKit.h>

typedef enum {
    DictionaryPickerWithRegionL3,
    DictionaryPickerWithRegionL2,
    DictionaryPickerWithJobType,
    DictionaryPickerWithCommon,
    DictionaryPickerWithSearchRegion,
    DictionaryPickerWithSearchJobType
} DictionaryPickerType;

typedef enum {
    DictionaryPickerModeOne,
    DictionaryPickerModeMulti
} DictionaryPickerMode;

typedef enum {
    DictionaryPickerIncludeParent,
    DictionaryPickerNoIncludeParent
} DictionaryPickerInclude;

@class SearchPickerView;

@protocol SearchPickerDelegate <NSObject>

@optional
- (void)pickerDidChangeStatus:(SearchPickerView *)picker
                selectedValue:(NSString *)selectedValue
                 selectedName:(NSString *)selectedName;

@end

@interface SearchPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (assign, nonatomic) id <SearchPickerDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIButton *btnMultiClear;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerDictionary;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollMulti;
@property (retain, nonatomic) IBOutlet UIButton *btnMultiAdd;
@property (retain, nonatomic) IBOutlet UIView *viewMultiTop;
@property (retain, nonatomic) IBOutlet UIView *viewMultiBottom;
@property (retain, nonatomic) IBOutlet UILabel *lbMulti;
@property (retain, nonatomic) IBOutlet UIButton *btnMultiSave;
@property (retain, nonatomic) IBOutlet UIButton *btnMultiCancel;
@property (nonatomic) DictionaryPickerType pickerType;
@property (nonatomic) DictionaryPickerMode pickerMode;
@property (nonatomic) DictionaryPickerInclude pickerInclude;
@property (retain, nonatomic) NSMutableArray *arrSelectValue;
@property (retain, nonatomic) NSMutableArray *arrSelectName;
@property (assign, nonatomic) NSString *selectTableName;

- (id)initWithSearchRegionFilter:(id <SearchPickerDelegate>)delegate
                     selectValue:(NSString *)selectValue
                      selectName:(NSString *)selectName
                    defalutValue:(NSString *)defaultValue;

- (void)showInView:(UIView *)view;
- (void)cancelPicker;

@end