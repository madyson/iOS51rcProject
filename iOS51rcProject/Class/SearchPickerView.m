#import "SearchPickerView.h"
#import "FMDatabase.h"
#import "CommonController.h"
#import "Toast+UIView.h"

@interface SearchPickerView ()
{
    NSMutableArray *arrDictionaryL1;
    NSMutableArray *arrDictionaryL2;
    NSMutableArray *arrDictionaryL3;
    FMDatabase *db;
}

@end

@implementation SearchPickerView

- (id)initWithSearchRegionFilter:(id <SearchPickerDelegate>)delegate
                     selectValue:(NSString *)selectValue
                      selectName:(NSString *)selectName
                    defalutValue:(NSString *)defaultValue
{
    self = [[[[NSBundle mainBundle] loadNibNamed:@"DictionaryPickerView" owner:self options:nil] objectAtIndex:0] retain];
    if (self) {
        self.pickerType = DictionaryPickerWithSearchRegion;
        self.pickerInclude = DictionaryPickerIncludeParent;
        [self connectDbAndInit];
        if ([selectValue rangeOfString:@","].location == NSNotFound) {
            [self setRegionDictionary:selectValue];
            if (arrDictionaryL3.count > 0) {
                arrDictionaryL1 = [arrDictionaryL2 mutableCopy];
                [arrDictionaryL2 removeAllObjects];
                [arrDictionaryL3 removeAllObjects];
            }
            else if (arrDictionaryL2.count > 0) {
                arrDictionaryL1 = [arrDictionaryL2 mutableCopy];
                [arrDictionaryL2 removeAllObjects];
            }
            [arrDictionaryL1 insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                                            @"",@"id",
                                            @"全部工作地点",@"value", nil] autorelease] atIndex:0];
        }
        //        NSMutableArray *arrFilter = [[NSMutableArray alloc] init];
        //        NSArray *arrRegionFilter = [selectValue componentsSeparatedByString:@","];
        //        NSArray *arrRegionNameFilter = [selectValue componentsSeparatedByString:@" "];
        //        for (int i=0; i<arrRegionFilter.count; i++) {
        //            [arrFilter addObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
        //                                   arrRegionFilter[i],@"id",
        //                                   arrRegionNameFilter[i],@"value", nil] autorelease]];
        //        }
    }
    return self;
}

-(void)connectDbAndInit
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"dictionary.db"];
    
    db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    [db retain];
    
    //加载数据
    arrDictionaryL1 = [[NSMutableArray alloc] init];
    arrDictionaryL2 = [[NSMutableArray alloc] init];
    arrDictionaryL3 = [[NSMutableArray alloc] init];
}

- (void)setRegionDictionary:(NSString *)parentid
{
    if ([parentid length] == 0) {
        FMResultSet *provinceList = [db executeQuery:@"select * from dcregion where parentid=''"];
        int i = 0;
        while ([provinceList next]) {
            NSDictionary *dicRegion = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [provinceList stringForColumn:@"_id"],@"id",
                                       [provinceList stringForColumn:@"description"],@"value"
                                       , nil];
            [arrDictionaryL1 addObject:dicRegion];
            [dicRegion release];
            //加载市
            if (i == 0) {
                [self setRegionDictionary:[provinceList stringForColumn:@"_id"]];
            }
            i++;
        }
    }
    else if ([parentid length] == 2) {
        [arrDictionaryL2 removeAllObjects];
        if (self.pickerType == DictionaryPickerWithRegionL2 && [self isMunicipality:parentid]) {
            return;
        }
        int i = 0;
        if (self.pickerInclude == DictionaryPickerIncludeParent) {
            for (i=0; i<arrDictionaryL1.count; i++) {
                if ([arrDictionaryL1[i][@"id"] compare:parentid options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                    break;
                }
            }
            if (i<arrDictionaryL1.count) {
                NSDictionary *dicParent = arrDictionaryL1[i];
                [arrDictionaryL2 addObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                                             dicParent[@"id"],@"id",
                                             [NSString stringWithFormat:@"全部%@",dicParent[@"value"]],@"value"
                                             , nil] autorelease]];
            }
        }
        i = 0;
        FMResultSet *cityList = [db executeQuery:[NSString stringWithFormat:@"select * from dcregion where parentid=%@",parentid]];
        while ([cityList next]) {//有下一个的话，就取出它的数据，然后关闭数据库
            NSDictionary *dicRegion = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [cityList stringForColumn:@"_id"],@"id",
                                       [cityList stringForColumn:@"description"],@"value"
                                       , nil];
            [arrDictionaryL2 addObject:dicRegion];
            [dicRegion release];
            //加载区
            if (i == 0) {
                [self setRegionDictionary:[cityList stringForColumn:@"_id"]];
            }
            i++;
        }
    }
    else if ([parentid length] == 4) {
        [arrDictionaryL3 removeAllObjects];
        if (self.pickerType == DictionaryPickerWithRegionL2) {
            return;
        }
        if (self.pickerType == DictionaryPickerWithRegionL3 && [self isMunicipality:[parentid substringToIndex:2]]) {
            return;
        }
        int i = 0;
        if (self.pickerInclude == DictionaryPickerIncludeParent) {
            for (i=0; i<arrDictionaryL2.count; i++) {
                if ([arrDictionaryL2[i][@"id"] compare:parentid options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                    break;
                }
            }
            if (i<arrDictionaryL2.count) {
                NSDictionary *dicParent = arrDictionaryL2[i];
                [arrDictionaryL3 addObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                                             dicParent[@"id"],@"id",
                                             [NSString stringWithFormat:@"全部%@",dicParent[@"value"]],@"value"
                                             , nil] autorelease]];
            }
        }
        
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

- (void)showInView:(UIView *)view
{
    [self.viewMultiTop setHidden:false];
    [self.viewMultiBottom setHidden:false];
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    if (self.pickerInclude == DictionaryPickerIncludeParent) {
        [self.pickerDictionary selectRow:1 inComponent:1 animated:YES];
        if (self.pickerType == DictionaryPickerWithRegionL3) {
            [self.pickerDictionary selectRow:1 inComponent:2 animated:YES];
        }
    }
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
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
