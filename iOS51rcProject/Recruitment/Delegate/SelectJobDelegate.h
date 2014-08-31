//
//  SelectJobDelegate.h
//  iOS51rcProject
//
//  Created by qlrc on 14-8-31.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SelectJobDelegate <NSObject>
-(void) SetJob:(NSString *) cpID jobID:(NSString*)jobID JobName:(NSString*) jobName;
@end
