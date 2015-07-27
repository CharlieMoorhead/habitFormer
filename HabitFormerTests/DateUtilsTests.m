//
//  DateUtilsTests.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 7/10/15.
//  Copyright (c) 2015 Charlie Moorhead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DateUtils.h"

@interface DateUtilsTests : XCTestCase

@end

@implementation DateUtilsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDaysBetween
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ddMMMyy"];
    NSString *dateString1 = @"01JAN15";
    NSString *dateString2 = @"02JAN15";
    NSString *dateString3 = @"31DEC14";
    
    NSDate *date1 = [dateFormatter dateFromString:dateString1];
    NSDate *date2 = [dateFormatter dateFromString:dateString1];
    NSDate *date3 = [dateFormatter dateFromString:dateString2];
    NSDate *date4 = [dateFormatter dateFromString:dateString3];
    
    XCTAssertEqual([DateUtils daysBetween:date1 and:date2], 0);
    XCTAssertEqual([DateUtils daysBetween:date1 and:date3], 1);
    XCTAssertEqual([DateUtils daysBetween:date1 and:date4], -1);
}

- (void)testGetDateFromString
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:5];
    [dateComponents setMonth:6];
    [dateComponents setYear:2015];
    NSDate *expectedDate = [[NSCalendar autoupdatingCurrentCalendar] dateFromComponents:dateComponents];
    
    NSString *testDateString = @"05Jun2015";
    NSString *testDateFormat = @"ddMMMyyyy";
    
    XCTAssertEqualObjects([DateUtils getDateFromString:testDateString format:testDateFormat], expectedDate);
}

- (void)testGetStringFromDate
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:5];
    [dateComponents setMonth:6];
    [dateComponents setYear:2015];
    NSDate *testDate = [[NSCalendar autoupdatingCurrentCalendar] dateFromComponents:dateComponents];
    
    NSString *testDateFormat = @"ddMMMyyyy";
    NSString *expectedDateString = @"05Jun2015";
    
    XCTAssertEqualObjects([DateUtils getStringFromDate:testDate format:testDateFormat], expectedDateString);
}

- (void)testStartingDate
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:1];
    [dateComponents setMonth:1];
    [dateComponents setYear:1900];
    NSDate *expectedDate = [[NSCalendar autoupdatingCurrentCalendar] dateFromComponents:dateComponents];
    
    XCTAssertEqualObjects([DateUtils startingDate], expectedDate);
}

@end
