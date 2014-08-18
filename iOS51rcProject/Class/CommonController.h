//
//  CommonController.h
//  iOS51rcProject
//
//  Created by Lucifer on 14-8-15.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonController : NSObject

+(CGSize)CalculateFrame:(NSString*) content
             fontDemond:(UIFont*) font
             sizeDemand:(CGSize) size;

+(NSDate *)dateFromString:(NSString *)dateString;
+(NSString *)getWeek:(NSDate *)date;
+(NSString *)stringFromDate:(NSDate *)date
                 formatType:(NSString *)formatType;
@end
