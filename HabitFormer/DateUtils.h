//
//  DateUtils.h
//  HabitFormer
//
//  Created by Charlie Moorhead on 10/2/14.
//  Copyright (c) 2014 Charlie Moorhead. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject

+ (NSInteger)daysBetween:(NSDate *)date1 and:(NSDate *)date2;
+ (NSDate *) getDateFromString:(NSString *)dateString format:(NSString *)formatString;
+ (NSString *) getStringFromDate:(NSDate *)date format:(NSString *)formatString;
+ (NSDate *)startingDate;

@end
