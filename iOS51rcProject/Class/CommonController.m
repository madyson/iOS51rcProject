//
//  CommonController.m
//  iOS51rcProject
//
//  Created by Lucifer on 14-8-15.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

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
@end
