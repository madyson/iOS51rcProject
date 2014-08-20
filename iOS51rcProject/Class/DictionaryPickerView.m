#import "DictionaryPickerView.h"
#import <QuartzCore/QuartzCore.h>
#import "FMDB/FMDatabase.h"

#define kDuration 0.3

@interface DictionaryPickerView ()
{
    NSMutableArray *arrDictionaryL1;
    NSMutableArray *arrDictionaryL2;
    NSMutableArray *arrDictionaryL3;
    FMDatabase *db;
}

@end

@implementation DictionaryPickerView

@synthesize delegate = _delegate;
@synthesize pickerType = _pickerType;
@synthesize locatePicker = _locatePicker;
@synthesize btnSave = _btnSave;
@synthesize btnCancel = _btnCancel;

- (void)dealloc
{
    [db close];
    [db release];
    [_locatePicker release];
    [arrDictionaryL1 release];
    [arrDictionaryL2 release];
    [arrDictionaryL3 release];
    [_btnCancel release];
    [_btnSave release];
    [super dealloc];
}


- (id)initWithCustom:(DictionaryPickerType)pickerType
         pickerType:(DictionaryPickerMode)pickerMode
           delegate:(id <DictionaryPickerDelegate>)delegate
{
    
    self = [[[[NSBundle mainBundle] loadNibNamed:@"DictionaryPickerView" owner:self options:nil] objectAtIndex:0] retain];
    if (self) {
        self.delegate = delegate;
        self.pickerType = pickerType;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        //加载数据
        arrDictionaryL1 = [[NSMutableArray alloc] init];
        arrDictionaryL2 = [[NSMutableArray alloc] init];
        arrDictionaryL3 = [[NSMutableArray alloc] init];
        NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"dictionary.db"];
        
        db = [FMDatabase databaseWithPath:dbPath];
        [db open];
        [db retain];
        FMResultSet *provinceList = [db executeQuery:@"select * from dcregion where parentid=''"];
        int i = 0;
        while ([provinceList next]) {//有下一个的话，就取出它的数据，然后关闭数据库
            if (i == 0) {
                [self setRegionDictionary:[provinceList stringForColumn:@"_id"]];
            }
            NSDictionary *dicRegion = [[NSDictionary alloc] initWithObjectsAndKeys:
             [provinceList stringForColumn:@"_id"],@"regionid",
             [provinceList stringForColumn:@"description"],@"regionname"
             , nil];
            [arrDictionaryL1 addObject:dicRegion];
            [dicRegion release];
            i++;
        }
        [self.btnCancel addTarget:self action:@selector(cancelPicker) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btnSave addTarget:self action:@selector(savePicker) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
    
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    switch (self.pickerType) {
        case DictionaryPickerWithRegionL3:
            return 3;
            break;
        case DictionaryPickerWithRegionL2:
            return 2;
            break;
        case DictionaryPickerWithJobType:
            return 2;
            break;
        default:
            return 1;
            break;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            return [arrDictionaryL1 count];
            break;
        }
        case 1:
            return [arrDictionaryL2 count];
            break;
        case 2:
            if (self.pickerType == DictionaryPickerWithRegionL3) {
                return [arrDictionaryL3 count];
                break;
            }
        default:
            return 0;
            break;
    }
}

- (void)setRegionDictionary:(NSString *)parentid
{
    if ([parentid length] == 2) {
        [arrDictionaryL2 removeAllObjects];
        [arrDictionaryL3 removeAllObjects];
        int i = 0;
        FMResultSet *cityList = [db executeQuery:[NSString stringWithFormat:@"select * from dcregion where parentid=%@",parentid]];
        while ([cityList next]) {//有下一个的话，就取出它的数据，然后关闭数据库
            if (i == 0) {
                FMResultSet *districtList = [db executeQuery:[NSString stringWithFormat:@"select * from dcregion where parentid=%@",[cityList stringForColumn:@"_id"]]];
                while ([districtList next]) {//有下一个的话，就取出它的数据，然后关闭数据库
                    NSDictionary *dicRegion = [[NSDictionary alloc] initWithObjectsAndKeys:
                                           [districtList stringForColumn:@"_id"],@"regionid",
                                           [districtList stringForColumn:@"description"],@"regionname"
                                           ,nil];
                
                    [arrDictionaryL3 addObject:dicRegion];
                    [dicRegion release];
                }
            }
            NSDictionary *dicRegion = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [cityList stringForColumn:@"_id"],@"regionid",
                                   [cityList stringForColumn:@"description"],@"regionname"
                                   , nil];
            [arrDictionaryL2 addObject:dicRegion];
            [dicRegion release];
            i++;
        }
    }
    else {
        [arrDictionaryL3 removeAllObjects];
        FMResultSet *districtList = [db executeQuery:[NSString stringWithFormat:@"select * from dcregion where parentid=%@",parentid]];
        while ([districtList next]) {//有下一个的话，就取出它的数据，然后关闭数据库
            NSDictionary *dicRegion = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [districtList stringForColumn:@"_id"],@"regionid",
                                       [districtList stringForColumn:@"description"],@"regionname"
                                       ,nil];
            
            [arrDictionaryL3 addObject:dicRegion];
            [dicRegion release];
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (self.pickerType) {
        case DictionaryPickerWithRegionL3:
        {
            switch (component) {
                case 0:
                {
                    [self setRegionDictionary:[arrDictionaryL1[row] objectForKey:@"regionid"]];
                    [self.locatePicker reloadComponent:1];
                    [self.locatePicker reloadComponent:2];
                    [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                    [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                    break;
                }
                case 1:
                {
                    [self setRegionDictionary:[arrDictionaryL2[row] objectForKey:@"regionid"]];
                    [self.locatePicker reloadComponent:2];
                    [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case DictionaryPickerWithRegionL2:
        {
            if (component == 0) {
                [self setRegionDictionary:[arrDictionaryL1[row] objectForKey:@"regionid"]];
                [self.locatePicker reloadComponent:1];
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                break;
            }
        }
        default:
            break;
    }
    
    if([self.delegate respondsToSelector:@selector(pickerDidChangeStatus:)]) {
        [self.delegate pickerDidChangeStatus:self];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSString *strTitle;
    switch (self.pickerType) {
        case DictionaryPickerWithRegionL3:
        {
            switch (component) {
                case 0:
                    strTitle = [arrDictionaryL1[row] objectForKey:@"regionname"];
                    break;
                case 1:
                    strTitle = [arrDictionaryL2[row] objectForKey:@"regionname"];
                    break;
                case 2:
                    strTitle = [arrDictionaryL3[row] objectForKey:@"regionname"];
                    break;
                default:
                    strTitle =  @"";
                    break;
            }
            break;
        }
        case DictionaryPickerWithRegionL2:
        {
            switch (component) {
                case 0:
                    strTitle = [arrDictionaryL1[row] objectForKey:@"regionname"];
                    break;
                case 1:
                    strTitle = [arrDictionaryL2[row] objectForKey:@"regionname"];
                    break;
                default:
                    strTitle =  @"";
                    break;
            }
            break;
        }
        default:
            break;
    }
    UILabel *lbTest = [[UILabel alloc] init];
    lbTest.text = strTitle;
    lbTest.textAlignment = NSTextAlignmentCenter;
    return lbTest;
}


#pragma mark - animation

- (void)showInView:(UIView *) view
{
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    
}

- (void)cancelPicker
{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
}

@end
