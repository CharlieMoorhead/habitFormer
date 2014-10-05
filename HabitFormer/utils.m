//
//  utils.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 10/2/14.
//  Copyright (c) 2014 Charlie Moorhead. All rights reserved.
//

#import "utils.h"

@implementation utils

+ (CGFloat)fullWidth
{
    CGRect fullScreenRect = [[UIScreen mainScreen] applicationFrame];
    CGFloat width = fullScreenRect.size.width;
    return width;
}

+ (CGFloat)fullHeight
{
    CGRect fullScreenRect = [[UIScreen mainScreen] applicationFrame];
    CGFloat height = fullScreenRect.size.height;// - self.navigationController.navigationBar.frame.size.height;
    return height;
}

+ (NSInteger)daysBetween:(NSDate *)date1 and:(NSDate *)date2
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    [calendar rangeOfUnit:unitFlags startDate:&fromDate interval:nil forDate:date1];
    [calendar rangeOfUnit:unitFlags startDate:&toDate interval:nil forDate:date2];
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:fromDate toDate:toDate options:0];
    
    return [components day];
}

@end
