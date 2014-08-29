#import "SearchViewController.h"
#import "DictionaryPickerView.h"
#import "SlideNavigationController.h"
#import "Toast+UIView.h"
#import "SearchListViewController.h"

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
    
    [self.btnSearch addTarget:self action:@selector(searchJob) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRegionSelect addTarget:self action:@selector(showRegionSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnJobTypeSelect addTarget:self action:@selector(showJobTypeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnIndustrySelect addTarget:self action:@selector(showIndustrySelect:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.lbRegionSelect setText:@"山东省"];
    self.regionSelect = @"32";
}

-(void)showRegionSelect:(UIButton *)sender {
    [self cancelDicPicker];
    self.DictionaryPicker = [[[DictionaryPickerView alloc] initWithCustom:DictionaryPickerWithRegionL3 pickerMode:DictionaryPickerModeMulti pickerInclude:DictionaryPickerIncludeParent delegate:self defaultValue:self.regionSelect defaultName:self.lbRegionSelect.text] autorelease];
    [self.DictionaryPicker setTag:1];
    [self.DictionaryPicker showInView:self.view];
}

-(void)showJobTypeSelect:(UIButton *)sender {
    [self cancelDicPicker];
    self.DictionaryPicker = [[[DictionaryPickerView alloc] initWithCustom:DictionaryPickerWithJobType pickerMode:DictionaryPickerModeMulti pickerInclude:DictionaryPickerIncludeParent delegate:self defaultValue:self.jobTypeSelect defaultName:self.lbJobTypeSelect.text] autorelease];
    [self.DictionaryPicker setTag:2];
    [self.DictionaryPicker showInView:self.view];
}

-(void)showIndustrySelect:(UIButton *)sender {
    [self cancelDicPicker];
    self.DictionaryPicker = [[[DictionaryPickerView alloc] initWithCommon:self pickerMode:DictionaryPickerModeMulti tableName:@"dcIndustry" defalutValue:self.industrySelect defaultName:self.lbIndustrySelect.text] autorelease];
    
    [self.DictionaryPicker setTag:3];
    NSLog(@"%d",[self.DictionaryPicker retainCount]);
    [self.DictionaryPicker showInView:self.view];
}

- (void)pickerDidChangeStatus:(DictionaryPickerView *)picker
                selectedValue:(NSString *)selectedValue
                 selectedName:(NSString *)selectedName
{
    switch (picker.tag) {
        case 1:
            if (selectedValue.length == 0) {
                [self.view makeToast:@"工作地点不能为空"];
                return;
            }
            self.regionSelect = selectedValue;
            self.lbRegionSelect.text = selectedName;
            break;
        case 2:
            self.jobTypeSelect = selectedValue;
            if (selectedValue.length == 0) {
                self.lbJobTypeSelect.text = @"所有职位";
            }
            else {
                self.lbJobTypeSelect.text = selectedName;
            }
            break;
        case 3:
            self.industrySelect = selectedValue;
            if (selectedValue.length == 0) {
                self.lbIndustrySelect.text = @"所有行业";
            }
            else {
                self.lbIndustrySelect.text = selectedName;
            }
            break;
        default:
            break;
    }
    [self cancelDicPicker];
}

- (void)searchJob
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    SearchListViewController *destinationController = (SearchListViewController*)[mainStoryboard
                                                                      instantiateViewControllerWithIdentifier: @"SearchListView"];
    
    destinationController.searchRegion = self.regionSelect;
    destinationController.searchJobType = self.jobTypeSelect;
    destinationController.searchIndustry = self.industrySelect;
    destinationController.searchKeyword = self.txtKeyWord.text;
    destinationController.searchRegionName = self.lbRegionSelect.text;
    destinationController.searchJobTypeName = self.lbJobTypeSelect.text;
    NSString *strSearchCondition = self.lbRegionSelect.text;
    if (self.jobTypeSelect.length > 0) {
        strSearchCondition = [strSearchCondition stringByAppendingFormat:@"+%@",self.lbJobTypeSelect.text];
    }
    if (self.industrySelect.length > 0) {
        strSearchCondition = [strSearchCondition stringByAppendingFormat:@"+%@",self.lbIndustrySelect.text];
    }
    destinationController.searchCondition = strSearchCondition;
    [self.navigationController pushViewController:destinationController animated:true];
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
    [_lbRegionSelect release];
    [_lbJobTypeSelect release];
    [_lbIndustrySelect release];
    [_regionSelect release];
    [_jobTypeSelect release];
    [_industrySelect release];
    [_DictionaryPicker release];
    [super dealloc];
}
@end
