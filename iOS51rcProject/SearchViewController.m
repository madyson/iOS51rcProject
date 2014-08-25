#import "SearchViewController.h"
#import "DictionaryPickerView.h"
#import "SlideNavigationController.h"

@interface SearchViewController () <DictionaryPickerDelegate,SlideNavigationControllerDelegate>
@property (strong, nonatomic) DictionaryPickerView *DictionaryPicker;
@property (retain, nonatomic) NSString *regionSelect;
@property (retain, nonatomic) NSString *jobTypeSelect;
@property (retain, nonatomic) NSString *industrySelect;
-(void)cancelDicPicker;
@end

@implementation SearchViewController

-(void)cancelDicPicker
{
    [self.DictionaryPicker cancelPicker];
    self.DictionaryPicker.delegate = nil;
    self.DictionaryPicker = nil;
    [_DictionaryPicker release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewSearchSelect.layer.cornerRadius = 5;
    self.viewSearchSelect.layer.borderWidth = 1;
    self.viewSearchSelect.layer.borderColor = [[UIColor colorWithRed:236.f/255.f green:236.f/255.f blue:236.f/255.f alpha:1] CGColor];
    self.btnSearch.layer.cornerRadius = 5;
    
    [self.btnRegionSelect addTarget:self action:@selector(showRegionSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnJobTypeSelect addTarget:self action:@selector(showJobTypeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnIndustrySelect addTarget:self action:@selector(showIndustrySelect:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)showRegionSelect:(UIButton *)sender {
    [self cancelDicPicker];
    self.DictionaryPicker = [[DictionaryPickerView alloc] initWithCustom:DictionaryPickerWithRegionL3 pickerMode:DictionaryPickerModeMulti pickerInclude:DictionaryPickerIncludeParent delegate:self defaultValue:self.regionSelect defaultName:self.lbRegionSelect.text];
    
    self.DictionaryPicker.tag = 1;
    [self.DictionaryPicker showInView:self.view];
}

-(void)showJobTypeSelect:(UIButton *)sender {
    [self cancelDicPicker];
    self.DictionaryPicker = [[DictionaryPickerView alloc] initWithCustom:DictionaryPickerWithJobType pickerMode:DictionaryPickerModeMulti pickerInclude:DictionaryPickerIncludeParent delegate:self defaultValue:self.jobTypeSelect defaultName:self.lbJobTypeSelect.text];
    
    self.DictionaryPicker.tag = 2;
    [self.DictionaryPicker showInView:self.view];
}

-(void)showIndustrySelect:(UIButton *)sender {
    [self cancelDicPicker];
    self.DictionaryPicker = [[DictionaryPickerView alloc] initWithCommon:self pickerMode:DictionaryPickerModeMulti tableName:@"dcIndustry" defalutValue:self.industrySelect defaultName:self.lbIndustrySelect.text];
    
    self.DictionaryPicker.tag = 3;
    [self.DictionaryPicker showInView:self.view];
}

- (void)pickerDidChangeStatus:(DictionaryPickerView *)picker
                selectedValue:(NSString *)selectedValue
                 selectedName:(NSString *)selectedName
{
    
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (int)slideMenuItem
{
    return 2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_viewSearchSelect release];
    [_btnSearch release];
    [_txtKeyWord release];
    [_btnRegionSelect release];
    [_btnJobTypeSelect release];
    [_btnIndustrySelect release];
    [_btnIndustrySelect release];
    [_btnJobTypeSelect release];
    [_lbRegionSelect release];
    [_lbJobTypeSelect release];
    [_lbIndustrySelect release];
    [_btnSearch release];
    [_regionSelect release];
    [_jobTypeSelect release];
    [_industrySelect release];
    [super dealloc];
}
@end
