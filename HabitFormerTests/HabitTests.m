//
//  HabitTests.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 7/10/15.
//  Copyright (c) 2015 Charlie Moorhead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Habit.h"

#define TEST_HABIT_NAME @"test habit cam"

@interface HabitTests : XCTestCase

@end

@implementation HabitTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testInitWithName
{
    NSString *testName = TEST_HABIT_NAME;
    Habit *testHabit = [[Habit alloc] initWithName:testName];
    
    XCTAssert(testHabit != NULL);
    XCTAssertEqualObjects(testHabit.name, testName);
    XCTAssertEqualObjects(testHabit.lastCompletion, [DateUtils startingDate]);
}

- (void)testInitWithNameAndCompletion
{
    NSString *testName = TEST_HABIT_NAME;
    NSDate *testDate = [NSDate date];
    
    Habit *testHabit = [[Habit alloc] initWithName:testName andCompletion:testDate];
    
    XCTAssert(testHabit != NULL);
    XCTAssertEqualObjects(testHabit.name, testName);
    XCTAssertEqualObjects(testHabit.lastCompletion, testDate);
}

- (void)testComplete
{
    Habit *testHabit = [[Habit alloc] initWithName:TEST_HABIT_NAME];
    
    NSDate *beforeDate = testHabit.lastCompletion;
    [testHabit complete];
    NSDate *afterDate = testHabit.lastCompletion;
    
    XCTAssertEqual([beforeDate compare:afterDate], NSOrderedAscending);
    
    
    
    
}

@end
