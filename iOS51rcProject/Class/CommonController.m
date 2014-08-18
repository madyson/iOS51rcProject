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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *thisDate = [dateFormatter dateFromString:dateString];
    [dateFormatter release];
    return thisDate;
}
@end
