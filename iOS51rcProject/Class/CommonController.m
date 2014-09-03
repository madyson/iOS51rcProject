#import "CommonController.h"

@implementation CommonController

+(CGSize)CalculateFrame:(NSString *) content
             fontDemond:(UIFont *) font
             sizeDemand:(CGSize) size
{
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize labelSize = [content boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return labelSize;
}

+(NSDate *)dateFromString:(NSString *)dateString{
    NSRange indexOfLength = [dateString rangeOfString:@"T" options:NSCaseInsensitiveSearch];
    if(indexOfLength.length > 0) {
        dateString = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    }
    indexOfLength = [dateString rangeOfString:@"+" options:NSCaseInsensitiveSearch];
    if(indexOfLength.length > 0) {
        dateString = [dateString substringToIndex:19];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *thisDate = [dateFormatter dateFromString:dateString];
    [dateFormatter release];
    return thisDate;
}

+(NSString *)stringFromDate:(NSDate *)date
                 formatType:(NSString *)formatType
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@",formatType]];
    NSString *thisDate = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return thisDate;
}

//是否是空字符串
+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

//检查密码格式
+ (BOOL)checkPassword:(NSString *) strPsd
{
    NSString *passwordreg=@"^[a-zA-Z0-9\\-_\\.]+$";
    NSPredicate *passreg = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordreg];
    BOOL ispassWordMatch = [passreg evaluateWithObject:strPsd];
    if(!(ispassWordMatch)){      
        return false;
    }else{
        return true;
    }
}

//验证邮箱
- (BOOL)checkEmail:(NSString *) strEmail
{
    BOOL result = true;
    NSString * regex = @"^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    NSString *emailReg=@"^[\\.\\-_].*$";
    NSPredicate *email=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
    BOOL isEmail=[email evaluateWithObject:strEmail];
    BOOL isMatch = [pred evaluateWithObject:strEmail];
    if(!isMatch){
        //[Dialog alert:@"邮箱格式不正确"];
        result = false;
    }
    if(isEmail){
        result = false;
    }
    
    return result;
}

/*手机号码验证 MODIFIED BY HELENSONG*/
-(BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\\\d)\\\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\\\d{3})\\\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+(NSString *)getWeek:(NSDate *)date{
    //return @"";
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:date];
    NSString *strWeek = @"";
    NSInteger week = [comps weekday];
    switch (week){
        case 1:
            strWeek = @"周日";
            break;
        case 2:
            strWeek = @"周一";
            break;
        case 3:
            strWeek = @"周二";
            break;
        case 4:
            strWeek = @"周三";
            break;
        case 5:
            strWeek = @"周四";
            break;
        case 6:
            strWeek = @"周五";
            break;
        case 7:
            strWeek = @"周六";
            break;
        default:
            strWeek = @"周日";
            break;
    }
    [calendar release];
    return strWeek;
}

//获得学历
+(NSString*) GetEduByID:(NSString *) eduID{
    NSString *strEdu = @" ";
    switch ([eduID intValue]){
        case 1:
            strEdu = @"初中";
            break;
        case 2:
            strEdu = @"高中";
            break;
        case 3:
            strEdu = @"中技";
            break;
        case 4:
            strEdu = @"中专";
            break;
        case 5:
            strEdu = @"大专";
            break;
        case 6:
            strEdu = @"本科";
            break;
        case 7:
            strEdu = @"硕士";
            break;
        case 8:
            strEdu = @"博士";
            break;
        default:
            strEdu =@"未知";
            break;
    }
    return strEdu;
}

//获得工资
+(NSString*) GetSalary:(NSString *) dcSalaryID{
    NSString *strSalary = @" ";
    switch ([dcSalaryID intValue]){
        case 1:
            strSalary = @"500以上";
            break;
        case 2:
            strSalary = @"1000以上";
            break;
        case 3:
            strSalary = @"1500以上";
            break;
        case 4:
            strSalary = @"2000以上";
            break;
        case 5:
            strSalary = @"3000以上";
            break;
        case 6:
            strSalary = @"4000以上";
            break;
        case 7:
            strSalary = @"6000以上";
            break;
        case 8:
            strSalary = @"8000以上";
            break;
        case 9:
            strSalary = @"15000以上";
            break;
        case 10:
            strSalary = @"20000以上";
            break;
        case 11:
            strSalary = @"500以上";
            break;
        case 100:
            strSalary = @"面议";
            break;
        default:
            strSalary =@"未知";
            break;
    }
    return strSalary;
}

+(NSString *)getDictionaryDesc:(NSString *)value
               tableName:(NSString *)tableName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"dictionary.db"];
    NSString *strDesc = @"";
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    FMResultSet *dictionaryList = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where _id=%@",tableName,value]];
    while ([dictionaryList next]) {
        strDesc = [dictionaryList stringForColumn:@"description"];
    }
    [db close];
    return strDesc;
}

+(BOOL)hasParentOfRegion:(NSString *)regionId
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"dictionary.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    FMResultSet *regionList = [db executeQuery:[NSString stringWithFormat:@"select * from dcRegion where parentid=%@",regionId]];
    BOOL hasRow = [regionList next];
    [db close];
    return hasRow;
}

+(void) execSql:(NSString *)sql
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"dictionary.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    [db executeUpdate:sql];
    [db close];
}

+(FMResultSet *) querySql:(NSString *)sql
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"dictionary.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    
    FMResultSet *queryList = [db executeQuery:sql];
    return queryList;
}

@end
