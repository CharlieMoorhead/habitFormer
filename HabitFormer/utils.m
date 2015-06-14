//
//  utils.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 10/2/14.
//  Copyright (c) 2014 Charlie Moorhead. All rights reserved.
//

#import "utils.h"

@implementation utils


//normalize to always be in portrait mode.
//if the device is in landscape, return values that correspond to portrait instead
//i.e., if in portrait mode, the width is less than the height, so return width as width
//BUT if in landscape, the width is greater than the height, so return the height as the width
//this makes autoresizing masks work correctly
+ (CGFloat)fullWidth
{
    //CGRect fullScreenRect = [[UIScreen mainScreen] applicationFrame];
    //if(fullScreenRect.size.width < fullScreenRect.size.height)
    //{
    //    return fullScreenRect.size.width;
    //}
    //else
    //{
    //    return fullScreenRect.size.height;
    //}
    return [[UIScreen mainScreen] applicationFrame].size.width;
}

+ (CGFloat)fullHeight
{
    //CGRect fullScreenRect = [[UIScreen mainScreen] applicationFrame];
    //if(fullScreenRect.size.width > fullScreenRect.size.height)
    //{
    //    return fullScreenRect.size.width;
    //}
    //else
    //{
    //    return fullScreenRect.size.height;
    //}
    return [[UIScreen mainScreen] applicationFrame].size.height;
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

+ (NSDate *) getDateFromString:(NSString *)dateString format:(NSString *)formatString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *) getStringFromDate:(NSDate *)date format:(NSString *)formatString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *) startingDate
{
    return [self getDateFromString:@"01-jan-1900" format:@"dd-MMM-yyyy"];
}

+ (UIColor *) labelColor
{
    CGFloat red = 80;
    CGFloat green = 216;
    CGFloat blue = 215;
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1.0f];
}

+ (UIColor *) backgroundColor
{
    CGFloat red = 20;
    CGFloat green = 122;
    CGFloat blue = 165;
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1.0f];}

+ (UIColor *) textColor
{
    CGFloat red = 41;
    CGFloat green = 41;
    CGFloat blue = 50;
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1.0f];
}

+ (UIColor *) buttonColor
{
    CGFloat red = 71;
    CGFloat green = 64;
    CGFloat blue = 68;
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1.0f];
}

@end
