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
@synthesize pickerDictionary = _pickerDictionary;
@synthesize btnSave = _btnSave;
@synthesize btnCancel = _btnCancel;
@synthesize selectValue = _selectValue;
@synthesize selectName = _selectName;
@synthesize selectTableName = _selectTableName;

- (void)dealloc
{
    [db close];
    [db release];
    [_pickerDictionary release];
    [_btnCancel release];
    [_btnSave release];
    [_selectValue release];
    [_selectName release];
    [_selectTableName release];
    [arrDictionaryL1 release];
    [arrDictionaryL2 release];
    [arrDictionaryL3 release];
    [super dealloc];
}


- (id)initWithCustom:(DictionaryPickerType)pickerType
         pickerType:(DictionaryPickerMode)pickerMode
           delegate:(id <DictionaryPickerDelegate>)delegate
        defaultValue:(NSString *)defaultValue
{
    self = [[[[NSBundle mainBundle] loadNibNamed:@"DictionaryPickerView" owner:self options:nil] objectAtIndex:0] retain];
    if (self) {
        self.delegate = delegate;
        self.pickerType = pickerType;
        self.pickerMode = pickerMode;
        self.pickerDictionary.dataSource = self;
        self.pickerDictionary.delegate = self;
        [self.btnCancel addTarget:self action:@selector(cancelPicker) forControlEvents:UIControlEventTouchUpInside];
        [self.btnSave addTarget:self action:@selector(savePicker) forControlEvents:UIControlEventTouchUpInside];
        self.selectValue = defaultValue;
        [self setupDictionary];
    }
    return self;
}

- (id)initWithCommon:(id <DictionaryPickerDelegate>)delegate
           tableName:(NSString *)tableName
        defalutValue:(NSString *)defaultValue
{
    self = [[[[NSBundle mainBundle] loadNibNamed:@"DictionaryPickerView" owner:self options:nil] objectAtIndex:0] retain];
    if (self) {
        self.delegate = delegate;
        self.pickerType = DictionaryPickerWithCommon;
        self.pickerMode = DictionaryPickerOne;
        self.pickerDictionary.dataSource = self;
        self.pickerDictionary.delegate = self;
        [self.btnCancel addTarget:self action:@selector(cancelPicker) forControlEvents:UIControlEventTouchUpInside];
        [self.btnSave addTarget:self action:@selector(savePicker) forControlEvents:UIControlEventTouchUpInside];
        self.selectValue = defaultValue;
        self.selectTableName = tableName;
        [self setupDictionary];
    }
    return self;
}

- (id)initWithDictionary:(id <DictionaryPickerDelegate>)delegate
       defaultArray:(NSMutableArray *)defaultArray
            defalutValue:(NSString *)defaultValue
{
    self = [[[[NSBundle mainBundle] loadNibNamed:@"DictionaryPickerView" owner:self options:nil] objectAtIndex:0] retain];
    if (self) {
        self.delegate = delegate;
        self.pickerType = DictionaryPickerWithCommon;
        self.pickerMode = DictionaryPickerOne;
        self.pickerDictionary.dataSource = self;
        self.pickerDictionary.delegate = self;
        [self.btnCancel addTarget:self action:@selector(cancelPicker) forControlEvents:UIControlEventTouchUpInside];
        [self.btnSave addTarget:self action:@selector(savePicker) forControlEvents:UIControlEventTouchUpInside];
        self.selectValue = defaultValue;
        arrDictionaryL1 = [defaultArray retain];
    }
    return self;
}

- (void) setupDictionary
{
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
    
    switch (self.pickerType) {
        case DictionaryPickerWithRegionL3:
        {
            [self setRegionDictionary:@""];
            break;
        }
        case DictionaryPickerWithRegionL2:
        {
            [self setRegionDictionary:@""];
            break;
        }
        case DictionaryPickerWithJobType:
        {
            [self setJobTypeDictionary:@""];
        }
        case DictionaryPickerWithCommon:
        {
            [self setCommonDictionary];
        }
        default:
            break;
    }
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
            return [arrDictionaryL3 count];
            break;
        default:
            return 0;
            break;
    }
}

- (void)setJobTypeDictionary:(NSString *)parentid
{
    if ([parentid length] == 0) {
        FMResultSet *jobTypeList = [db executeQuery:@"select * from dcjobtype where parentid is null and _id<>0"];
        int i = 0;
        while ([jobTypeList next]) {
            if (i == 0) {
                [self setJobTypeDictionary:[jobTypeList stringForColumn:@"_id"]];
            }
            NSDictionary *dicJobType = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [jobTypeList stringForColumn:@"_id"],@"id",
                                       [jobTypeList stringForColumn:@"description"],@"value"
                                       , nil];
            [arrDictionaryL1 addObject:dicJobType];
            [dicJobType release];
            i++;
        }
    }
    else if ([parentid length] == 2) {
        [arrDictionaryL2 removeAllObjects];
        int i = 0;
        FMResultSet *cityList = [db executeQuery:[NSString stringWithFormat:@"select * from dcjobtype where parentid=%@",parentid]];
        while ([cityList next]) {//有下一个的话，就取出它的数据，然后关闭数据库
            NSDictionary *dicJobType = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [cityList stringForColumn:@"_id"],@"id",
                                       [cityList stringForColumn:@"description"],@"value"
                                       , nil];
            [arrDictionaryL2 addObject:dicJobType];
            [dicJobType release];
            i++;
        }
    }
}

- (void)setRegionDictionary:(NSString *)parentid
{
    if ([parentid length] == 0) {
        FMResultSet *provinceList = [db executeQuery:@"select * from dcregion where parentid=''"];
        int i = 0;
        while ([provinceList next]) {
            if (i == 0) {
                if (self.pickerType == DictionaryPickerWithRegionL2 && [self isMunicipality:[provinceList stringForColumn:@"_id"]]) {
                    
                }
                else {
                    [self setRegionDictionary:[provinceList stringForColumn:@"_id"]];
                }
                
            }
            NSDictionary *dicRegion = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [provinceList stringForColumn:@"_id"],@"id",
                                       [provinceList stringForColumn:@"description"],@"value"
                                       , nil];
            [arrDictionaryL1 addObject:dicRegion];
            [dicRegion release];
            i++;
        }
    }
    else if ([parentid length] == 2) {
        [arrDictionaryL2 removeAllObjects];
        int i = 0;
        FMResultSet *cityList = [db executeQuery:[NSString stringWithFormat:@"select * from dcregion where parentid=%@",parentid]];
        while ([cityList next]) {//有下一个的话，就取出它的数据，然后关闭数据库
            if (i == 0 && self.pickerType == DictionaryPickerWithRegionL3) {
                [self setRegionDictionary:[cityList stringForColumn:@"_id"]];
            }
            NSDictionary *dicRegion = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [cityList stringForColumn:@"_id"],@"id",
                                   [cityList stringForColumn:@"description"],@"value"
                                   , nil];
            [arrDictionaryL2 addObject:dicRegion];
            [dicRegion release];
            i++;
        }
    }
    else if ([parentid length] == 4) {
        [arrDictionaryL3 removeAllObjects];
        FMResultSet *districtList = [db executeQuery:[NSString stringWithFormat:@"select * from dcregion where parentid=%@",parentid]];
        while ([districtList next]) {//有下一个的话，就取出它的数据，然后关闭数据库
            NSDictionary *dicRegion = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [districtList stringForColumn:@"_id"],@"id",
                                       [districtList stringForColumn:@"description"],@"value"
                                       ,nil];
            
            [arrDictionaryL3 addObject:dicRegion];
            [dicRegion release];
        }
    }
}

- (void)setCommonDictionary
{
    FMResultSet *commonList = [db executeQuery:[NSString stringWithFormat:@"select * from %@",self.selectTableName]];
    int i = 0;
    while ([commonList next]) {
        if (i == 0) {
            [self setJobTypeDictionary:[commonList stringForColumn:@"_id"]];
        }
        NSDictionary *dicCommon = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [commonList stringForColumn:@"_id"],@"id",
                                   [commonList stringForColumn:@"description"],@"value"
                                   , nil];
        [arrDictionaryL1 addObject:dicCommon];
        [dicCommon release];
        i++;
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
                    [self setRegionDictionary:[arrDictionaryL1[row] objectForKey:@"id"]];
                    [self.pickerDictionary reloadComponent:1];
                    [self.pickerDictionary reloadComponent:2];
                    [self.pickerDictionary selectRow:0 inComponent:1 animated:YES];
                    [self.pickerDictionary selectRow:0 inComponent:2 animated:YES];
                    break;
                }
                case 1:
                {
                    [self setRegionDictionary:[arrDictionaryL2[row] objectForKey:@"id"]];
                    [self.pickerDictionary reloadComponent:2];
                    [self.pickerDictionary selectRow:0 inComponent:2 animated:YES];
                    break;
                }
                case 3:
                {
                    
                }
                default:
                    break;
            }
            break;
        }
        case DictionaryPickerWithRegionL2:
        {
            if (component == 0) {
                if ([self isMunicipality:[arrDictionaryL1[row] objectForKey:@"id"]]) {
                    [arrDictionaryL2 removeAllObjects];
                }
                else{
                    [self setRegionDictionary:[arrDictionaryL1[row] objectForKey:@"id"]];
                }
                [self.pickerDictionary reloadComponent:1];
                [self.pickerDictionary selectRow:0 inComponent:1 animated:YES];
                break;
            }
        }
        case DictionaryPickerWithJobType:
        {
            if (component == 0) {
                [self setJobTypeDictionary:[arrDictionaryL1[row] objectForKey:@"id"]];
                [self.pickerDictionary reloadComponent:1];
                [self.pickerDictionary selectRow:0 inComponent:1 animated:YES];
                break;
            }
        }
        default:
            break;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSString *strTitle;
    switch (component) {
        case 0:
            strTitle = [arrDictionaryL1[row] objectForKey:@"value"];
            break;
        case 1:
            strTitle = [arrDictionaryL2[row] objectForKey:@"value"];
            break;
        case 2:
            strTitle = [arrDictionaryL3[row] objectForKey:@"value"];
            break;
        default:
            strTitle =  @"";
            break;
    }
    UILabel *lbTitle = [[UILabel alloc] init];
    lbTitle.text = strTitle;
    lbTitle.textAlignment = NSTextAlignmentCenter;
    lbTitle.userInteractionEnabled = true;
    return lbTitle;
}

- (void)itemClick 
{
    NSLog(@"123123123");
}

- (void)savePicker
{
    if ([self.delegate respondsToSelector:@selector(pickerDidChangeStatus:selectValue:selectName:)]) {
        if (self.pickerMode == DictionaryPickerOne) {
            NSDictionary *dicSelected;
            if ([arrDictionaryL3 count] > 0) {
                dicSelected = arrDictionaryL3[[self.pickerDictionary selectedRowInComponent:2]];
            }
            else if ([arrDictionaryL2 count] > 0) {
                dicSelected = arrDictionaryL2[[self.pickerDictionary selectedRowInComponent:1]];
            }
            else {
                dicSelected = arrDictionaryL1[[self.pickerDictionary selectedRowInComponent:0]];
            }
            
            [self.delegate pickerDidChangeStatus:self selectValue:[NSString stringWithFormat:@"%@",dicSelected[@"id"]] selectName:[NSString stringWithFormat:@"%@",dicSelected[@"value"]]];
        }
    }
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

- (BOOL)isMunicipality:(NSString *)regionId //是否是直辖市
{
    if ([regionId isEqual:@"10"]|[regionId isEqual:@"11"]|[regionId isEqual:@"30"]|[regionId isEqual:@"60"]|[regionId isEqual:@"90"]|[regionId isEqual:@"91"]|[regionId isEqual:@"92"]|[regionId isEqual:@"93"]) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
