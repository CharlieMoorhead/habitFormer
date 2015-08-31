//
//  MainViewControllerTests.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 8/3/15.
//  Copyright (c) 2015 Charlie Moorhead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HabitFormerAppDelegate.h"
#import "MainViewController+Test.h"

@interface MainViewControllerTests : XCTestCase

@property (strong,nonatomic) MainViewController *mainViewController;
@property (strong,nonatomic) DBManager *dbManager;

@end

@implementation MainViewControllerTests

- (void)setUp {
    [super setUp];
    
    //HabitFormerAppDelegate *appDelegate = (HabitFormerAppDelegate *)[[UIApplication sharedApplication] delegate];
    //UIWindow *appWindow = [appDelegate window];
    //UINavigationController *navController = (UINavigationController *)[appWindow rootViewController];
    //self.mainViewController = (MainViewController *)[navController.viewControllers firstObject];
    self.mainViewController = [[MainViewController alloc] init];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"habits_test.db"];
    NSString *deleteAllQuery = @"DELETE FROM Habits";
    [self.dbManager executeQuery:deleteAllQuery];

    NSString *insertQuery = @"INSERT INTO Habits VALUES(NULL, 'test habit 1', '2015-01-01 01:01');";
    [self.dbManager executeQuery:insertQuery];
    
    insertQuery = @"INSERT INTO Habits VALUES(NULL, 'test habit 2', '2015-03-03 03:03');";
    [self.dbManager executeQuery:insertQuery];
    
    insertQuery = @"INSERT INTO Habits VALUES(NULL, 'test habit 3', '2015-02-02 02:02');";
    [self.dbManager executeQuery:insertQuery];
    
    [self.mainViewController viewDidLoad];
    [self.mainViewController.view layoutIfNeeded];
}

- (void)tearDown {
    
    NSString *deleteAllQuery = @"DELETE FROM Habits";
    [self.dbManager executeQuery:deleteAllQuery];
    
    [super tearDown];
}

- (void)testElementsExist
{
    XCTAssertNotNil(self.mainViewController.tableView);
    XCTAssertNotNil(self.mainViewController.emptyView);
    XCTAssertNotNil(self.mainViewController.habitDB);
    XCTAssertNotNil(self.mainViewController.habits);
    XCTAssertNotNil(self.mainViewController.habitsToView);
}

- (void)testTableView
{
    XCTAssertEqualObjects(self.mainViewController.tableView.backgroundColor, backgroundColor);
    XCTAssertEqual(self.mainViewController.tableView.separatorStyle, UITableViewCellSeparatorStyleNone);
    XCTAssertFalse(self.mainViewController.tableView.allowsSelection);
    XCTAssertEqualObjects(self.mainViewController.tableView.delegate, self.mainViewController);
    XCTAssertEqualObjects(self.mainViewController.tableView.dataSource, self.mainViewController);
}

- (void)testEmptyView
{
    XCTAssertEqual(self.mainViewController.emptyView.subviews.count,2);
    
    NSString *LabelText1 = @"You have no habits to complete";
    NSString *LabelText2 = @"Tap the upper right to form a new habit";
    UILabel *emptyLabel1 = (UILabel *)self.mainViewController.emptyView.subviews[0];
    UILabel *emptyLabel2 = (UILabel *)self.mainViewController.emptyView.subviews[1];
    
    BOOL firstLabelHasCorrectText = [emptyLabel1.text isEqual:LabelText1] || [emptyLabel1.text  isEqual:LabelText2];
    BOOL secondLabelHasCorrectText = [emptyLabel1.text isEqual:LabelText1] || [emptyLabel1.text  isEqual:LabelText2];
    
    XCTAssertTrue(firstLabelHasCorrectText);
    XCTAssertTrue(secondLabelHasCorrectText);
    XCTAssertNotEqualObjects(emptyLabel1.text, emptyLabel2.text);
    
    XCTAssertEqual(emptyLabel1.textAlignment, NSTextAlignmentCenter);
    XCTAssertEqualObjects(emptyLabel1.font, [UIFont systemFontOfSize:17]);
    XCTAssertEqualObjects(emptyLabel1.textColor, textColor);
    
    XCTAssertEqual(emptyLabel2.textAlignment, NSTextAlignmentCenter);
    XCTAssertEqualObjects(emptyLabel2.font, [UIFont systemFontOfSize:15]);
    XCTAssertEqualObjects(emptyLabel2.textColor, textColor);
}

- (void)testHabitArrays
{
    XCTAssertEqual(self.mainViewController.habits.count, 3);
    XCTAssertEqual(self.mainViewController.habitsToView.count, 3);
}

- (void)testNumberOfSectionsInTableView
{
    XCTAssertEqual(self.mainViewController.tableView.numberOfSections, self.mainViewController.habitsToView.count);
}

- (void)testNumberOfRowsInSection
{
    XCTAssertEqual([self.mainViewController.tableView numberOfRowsInSection:0], 1);
    XCTAssertEqual([self.mainViewController.tableView numberOfRowsInSection:1], 1);
    XCTAssertEqual([self.mainViewController.tableView numberOfRowsInSection:2], 1);
    
}

- (void)testViewForHeaderInSection
{
    UITableViewHeaderFooterView *header = [self.mainViewController.tableView headerViewForSection:0];
    XCTAssertEqualObjects(header.backgroundView.backgroundColor, [UIColor clearColor]);
    XCTAssertEqual(header.frame.size.height, 10.0f);
}

/*
 //next two methods make it so the '-' delete button doesn't slide in while entering edit mode
 - (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return NO;
 }
 
 - (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return UITableViewCellEditingStyleNone;
 }
 
 -(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return 44.0f;
 }

*/



@end
