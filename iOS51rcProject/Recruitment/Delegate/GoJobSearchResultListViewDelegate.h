//
//  GoJobSearchResultListViewDelegate.h
//  iOS51rcProject
//
//  Created by qlrc on 14-9-1.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GoJobSearchResultListViewDelegate <NSObject>
-(void) gotoJobSearchResultListView:(NSString*) strSearchRegion SearchJobType:(NSString*) strSearchJobType SearchIndustry:(NSString *) strSearchIndustry SearchKeyword:(NSString *) strSearchKeyword SearchRegionName:(NSString *) strSearchRegionName SearchJobTypeName:(NSString *) strSearchJobTypeName SearchCondition:(NSString *) strSearchCondition;
@end
