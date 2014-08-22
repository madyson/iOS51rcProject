#import <UIKit/UIKit.h>

typedef enum {
    DictionaryPickerWithRegionL3,
    DictionaryPickerWithRegionL2,
    DictionaryPickerWithJobType,
    DictionaryPickerWithCommon
} DictionaryPickerType;

typedef enum {
    DictionaryPickerMulti,
    DictionaryPickerOne
} DictionaryPickerMode;

@class DictionaryPickerView;

@protocol DictionaryPickerDelegate <NSObject>

@optional
- (void)pickerDidChangeStatus:(DictionaryPickerView *)picker
                  selectValue:(NSString *)selectValue
                   selectName:(NSString *)selectName;

@end

@interface DictionaryPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (assign, nonatomic) id <DictionaryPickerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerDictionary;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (nonatomic) DictionaryPickerType pickerType;
@property (nonatomic) DictionaryPickerMode pickerMode;
@property (assign, nonatomic) NSString *selectValue;
@property (assign, nonatomic) NSString *selectName;
@property (assign, nonatomic) NSString *selectTableName;

- (id)initWithCustom:(DictionaryPickerType)pickerType
         pickerType:(DictionaryPickerMode)pickerMode
           delegate:(id <DictionaryPickerDelegate>)delegate
        defaultValue:(NSString *)defaultValue;

- (id)initWithDictionary:(id <DictionaryPickerDelegate>)delegate
       defaultArray:(NSMutableArray *)defaultArray
            defalutValue:(NSString *)defaultValue;

- (id)initWithCommon:(id <DictionaryPickerDelegate>)delegate
           tableName:(NSString *)tableName
        defalutValue:(NSString *)defaultValue;

- (void)showInView:(UIView *)view;
- (void)cancelPicker;

@end
