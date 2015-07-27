//
//  HabitDBTests.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 7/11/15.
//  Copyright (c) 2015 Charlie Moorhead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HabitDB.h"

#define TEST_HABIT_NAME @"test habit cam"

@interface HabitDBTests : XCTestCase

@property (nonatomic,strong) DBManager *dbManager;
@property (nonatomic,strong) HabitDB *habitDB;

@end

@implementation HabitDBTests

- (void)setUp {
    [super setUp];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"habits_test.db"];
    
    NSString *deleteAllQuery = @"DELETE FROM Habits";
    [self.dbManager executeQuery:deleteAllQuery];
    
    self.habitDB = [[HabitDB alloc] init];

    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    
    NSString *deleteAllQuery = @"DELETE FROM Habits";
    [self.dbManager executeQuery:deleteAllQuery];
    
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit
{
    XCTAssertNotNil(self.habitDB);
}

- (void)testHabitCreationAndDeletion
{
    Habit *newHabit;
    
    NSString *selectQuery = @"SELECT COUNT(name) FROM Habits";
    NSArray *habitCountArray = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:selectQuery]];
    NSInteger originalHabitCount = [habitCountArray[0][0] integerValue];
    NSInteger currentHabitCount;
    
    newHabit = [self.habitDB createHabit:TEST_HABIT_NAME];
    XCTAssertNotNil(newHabit);
    habitCountArray = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:selectQuery]];
    currentHabitCount = [habitCountArray[0][0] integerValue];
    XCTAssertEqual(currentHabitCount, originalHabitCount + 1);
    
    XCTAssertTrue([self.habitDB deleteHabit:TEST_HABIT_NAME]);
    habitCountArray = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:selectQuery]];
    currentHabitCount = [habitCountArray[0][0] integerValue];
    XCTAssertEqual(currentHabitCount, originalHabitCount);
    
    XCTAssertFalse([self.habitDB deleteHabit:TEST_HABIT_NAME]);
}

- (void)testGetHabitFromName
{
    Habit *newHabit;
    Habit *retrievedHabit;
    NSString *expectedName;
    NSDate *expectedLastCompletion;
    
    
    newHabit = [self.habitDB createHabit:TEST_HABIT_NAME];
    expectedName = newHabit.name;
    expectedLastCompletion = newHabit.lastCompletion;
    
    retrievedHabit = [self.habitDB getHabitFromName:TEST_HABIT_NAME];

    XCTAssertEqualObjects(retrievedHabit.name, expectedName);
    XCTAssertEqualObjects(retrievedHabit.lastCompletion, expectedLastCompletion);
}

- (void)testGetAllHabits
{
    NSMutableDictionary *habitDict;
    Habit *expectedHabit1;
    Habit *expectedHabit2;
    Habit *expectedHabit3;
    NSString *expectedName1;
    NSString *expectedName2;
    NSString *expectedName3;
    NSDate *expectedLastCompletion1;
    NSDate *expectedLastCompletion2;
    NSDate *expectedLastCompletion3;
    
    expectedName1 = [NSString stringWithFormat:@"%@ 1", TEST_HABIT_NAME];
    expectedName2 = [NSString stringWithFormat:@"%@ 2", TEST_HABIT_NAME];
    expectedName3 = [NSString stringWithFormat:@"%@ 3", TEST_HABIT_NAME];
    
    expectedHabit1 = [self.habitDB createHabit:expectedName1];
    expectedHabit2 = [self.habitDB createHabit:expectedName2];
    expectedHabit3 = [self.habitDB createHabit:expectedName3];
    
    [self.habitDB completeHabit:expectedHabit2];
    
    expectedLastCompletion1 = expectedHabit1.lastCompletion;
    expectedLastCompletion2 = expectedHabit2.lastCompletion;
    expectedLastCompletion3 = expectedHabit3.lastCompletion;
    
    habitDict = [self.habitDB getAllHabits:habitDict];
    
    expectedHabit1 = (Habit *)[habitDict objectForKey:expectedName1];
    expectedHabit2 = (Habit *)[habitDict objectForKey:expectedName2];
    expectedHabit3 = (Habit *)[habitDict objectForKey:expectedName3];
    
    XCTAssertNotNil(expectedHabit1);
    XCTAssertNotNil(expectedHabit2);
    XCTAssertNotNil(expectedHabit3);
    
    XCTAssertEqualObjects(expectedHabit1.name, expectedName1);
    XCTAssertEqualObjects(expectedHabit2.name, expectedName2);
    XCTAssertEqualObjects(expectedHabit3.name, expectedName3);
    
    XCTAssertEqual([expectedHabit1.lastCompletion compare:expectedLastCompletion1], NSOrderedSame);
    XCTAssertEqual([expectedHabit2.lastCompletion compare:expectedLastCompletion2], NSOrderedSame);
    XCTAssertEqual([expectedHabit3.lastCompletion compare:expectedLastCompletion3], NSOrderedSame);

}

- (void)testComplete
{
    Habit *habit;
    NSDate *firstDate;
    NSDate *secondDate;
    
    habit = [self.habitDB createHabit:TEST_HABIT_NAME];
    firstDate = habit.lastCompletion;
    
    XCTAssertTrue([self.habitDB completeHabit:habit]);
    
    habit = [self.habitDB getHabitFromName:TEST_HABIT_NAME];
    secondDate = habit.lastCompletion;
    
    XCTAssertEqual([firstDate compare:secondDate], NSOrderedAscending);
}

@end
