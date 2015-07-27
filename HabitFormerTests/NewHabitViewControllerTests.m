//
//  NewHabitViewControllerTests.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 7/13/15.
//  Copyright (c) 2015 Charlie Moorhead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HabitFormerAppDelegate.h"
#import "NewHabitViewController.h"
#import "MainViewController.h"
#import <OCMock/OCMock.h>

@interface NewHabitViewControllerTests : XCTestCase

@property (nonatomic,strong) UINavigationController *navController;
@property (nonatomic,strong) NewHabitViewController *habitViewController;
@property (nonatomic,strong) DBManager *dbManager;

@end

@implementation NewHabitViewControllerTests

- (void)setUp {

    
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    HabitFormerAppDelegate *appDelegate = (HabitFormerAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIWindow *appWindow = [appDelegate window];
    self.navController = (UINavigationController *)[appWindow rootViewController];
    
    self.habitViewController = [[NewHabitViewController alloc] init];
    self.habitViewController.delegate = (MainViewController *)self.navController.topViewController;
    [self.navController pushViewController:self.habitViewController animated:NO];
    [self.habitViewController view];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"habits_test.db"];
    NSString *deleteAllQuery = @"DELETE FROM Habits";
    [self.dbManager executeQuery:deleteAllQuery];
    
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    [self.navController popToRootViewControllerAnimated:NO];
    
    NSString *deleteAllQuery = @"DELETE FROM Habits";
    [self.dbManager executeQuery:deleteAllQuery];
    
    [super tearDown];
}

- (void)testIsTopAndVisibleAfterPush
{
    XCTAssertEqualObjects([self.navController topViewController], self.habitViewController);
    XCTAssertEqualObjects([self.navController visibleViewController], self.habitViewController);
}

- (void)testViewAttributes
{
    NSString *expectedTitle = @"New Habit";
    UIColor *expectedBackgroundColor = backgroundColor;
    
    XCTAssertEqualObjects(self.habitViewController.title, expectedTitle);
    XCTAssertEqualObjects(self.habitViewController.view.backgroundColor, expectedBackgroundColor);
}

- (void)testElementsExist
{
    XCTAssertNotNil(self.habitViewController.name);
    XCTAssertNotNil(self.habitViewController.nameLabel);
    XCTAssertNotNil(self.habitViewController.create);
}


- (void)testNameTextField
{
    UITextField *nameTextField = self.habitViewController.name;
    UIColor *expectedBackgroundColor = labelColor;
    UIColor *expectedTextColor = textColor;
    NewHabitViewController *expectedDelegate = self.habitViewController;
    
    XCTAssertEqualObjects(nameTextField.backgroundColor, expectedBackgroundColor);
    XCTAssertEqualObjects(nameTextField.textColor, expectedTextColor);
    XCTAssertEqualObjects(nameTextField.delegate, expectedDelegate);
}

- (void)testNameLabel
{
    UILabel *nameLabel = self.habitViewController.nameLabel;
    
    UIColor *expectedBackgroundColor = labelColor;
    UIColor *expectedTextColor = textColor;
    UIFont *expectedFont = [UIFont systemFontOfSize:12];
    NSString *expectedText = @"name";
    NSTextAlignment expectedAlignment = NSTextAlignmentCenter;
    
    XCTAssertEqualObjects(nameLabel.backgroundColor, expectedBackgroundColor);
    XCTAssertEqualObjects(nameLabel.textColor, expectedTextColor);
    XCTAssertEqualObjects(nameLabel.font, expectedFont);
    XCTAssertEqualObjects(nameLabel.text, expectedText);
    XCTAssertEqual(nameLabel.textAlignment, expectedAlignment);
}

- (void)testCreateButton
{
    UIButton *createButton = self.habitViewController.create;
    
    UIColor *expectedTintColor = buttonColor;
    NSString *expectedTitle = @"Create";
    NSInteger expectedTargetCount = 1;
    NewHabitViewController *expectedTarget = self.habitViewController;
    UIControlEvents expectedControlEvents = UIControlEventTouchDown;
    NSInteger expectedActionCount = 1;
    NSInteger actualActionCount;
    NSString *expectedAction = @"createHabit";
    NSString *actualAction;
    
    
    XCTAssertEqualObjects(createButton.tintColor, expectedTintColor);
    XCTAssertEqualObjects(createButton.titleLabel.text, expectedTitle);
    XCTAssertEqual(createButton.allTargets.count, expectedTargetCount);
    XCTAssertTrue([createButton.allTargets containsObject:expectedTarget]);
    XCTAssertEqual(createButton.allControlEvents, expectedControlEvents);
    
    actualActionCount = [createButton actionsForTarget:expectedTarget
                                       forControlEvent:expectedControlEvents].count;
    actualAction = [createButton actionsForTarget:expectedTarget
                                  forControlEvent:expectedControlEvents][0];
    
    XCTAssertEqual(actualActionCount, expectedActionCount);
    XCTAssertEqualObjects(actualAction, expectedAction);
}


- (void)testConstraints
{
    XCTAssertEqual(self.habitViewController.view.constraints.count, 10);
    
    NSLayoutConstraint *c = (NSLayoutConstraint *)self.habitViewController.view.constraints[0];
    
    XCTAssertEqualObjects(c.firstItem, self.habitViewController.name);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeLeft);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.habitViewController.view);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeLeft);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 50.0f);

    c = (NSLayoutConstraint *)self.habitViewController.view.constraints[1];
    
    XCTAssertEqualObjects(c.firstItem, self.habitViewController.name);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeTop);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.habitViewController.view);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeTop);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 10.0f);

    c = (NSLayoutConstraint *)self.habitViewController.view.constraints[2];
    
    XCTAssertEqualObjects(c.firstItem, self.habitViewController.name);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeWidth);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.habitViewController.view);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeWidth);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, -50.0f);

    c = (NSLayoutConstraint *)self.habitViewController.view.constraints[3];
    
    XCTAssertEqualObjects(c.firstItem, self.habitViewController.name);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeHeight);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, nil);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeNotAnAttribute);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 45.0f);

    c = (NSLayoutConstraint *)self.habitViewController.view.constraints[4];
    
    XCTAssertEqualObjects(c.firstItem, self.habitViewController.nameLabel);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeLeft);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.habitViewController.view);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeLeft);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 0.0f);

    c = (NSLayoutConstraint *)self.habitViewController.view.constraints[5];
    
    XCTAssertEqualObjects(c.firstItem, self.habitViewController.nameLabel);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeTop);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.habitViewController.view);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeTop);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 10.0f);

    c = (NSLayoutConstraint *)self.habitViewController.view.constraints[6];
    
    XCTAssertEqualObjects(c.firstItem, self.habitViewController.nameLabel);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeWidth);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, nil);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeNotAnAttribute);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 50.0f);

    c = (NSLayoutConstraint *)self.habitViewController.view.constraints[7];
    
    XCTAssertEqualObjects(c.firstItem, self.habitViewController.nameLabel);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeHeight);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, nil);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeNotAnAttribute);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 45.0f);

    c = (NSLayoutConstraint *)self.habitViewController.view.constraints[8];
    
    XCTAssertEqualObjects(c.firstItem, self.habitViewController.create);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeTop);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.habitViewController.view);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeBottom);
    XCTAssertEqual(c.multiplier, 0.21f);
    XCTAssertEqual(c.constant, 0.0f);

    c = (NSLayoutConstraint *)self.habitViewController.view.constraints[9];
    
    XCTAssertEqualObjects(c.firstItem, self.habitViewController.create);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeCenterX);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.habitViewController.view);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeCenterX);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 0.0f);
}

- (void)testCreateHabit
{
    //returns:
    //  0   success
    //  4   too short (0 characters entered)
    //  3   too long
    //  2   too many habits (99 already exist)
    //  1   name is already used
    //
    
    NSString *nameTooLong = @"wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww";
    NSString *nameTooShort = @"";
    NSString *nameJustRight = @"yes";
    
    id mockHabitViewController = OCMPartialMock(self.habitViewController);
    OCMStub([mockHabitViewController displayAlert:[OCMArg any]]).andDo(nil);
    
    //too short (no name entered)
    self.habitViewController.name.text = nameTooShort;
    XCTAssertEqual([self.habitViewController createHabit], 4);
    
    //too long
    self.habitViewController.name.text = nameTooLong;
    XCTAssertEqual([self.habitViewController createHabit], 3);
    
    //successfully created
    self.habitViewController.name.text = nameJustRight;
    XCTAssertEqual([self.habitViewController createHabit], 0);
    
    //name already exists
    self.habitViewController.name.text = nameJustRight;
    XCTAssertEqual([self.habitViewController createHabit], 1);
    
    for(NSInteger i=2; i < 99; i++)
    {
        self.habitViewController.name.text = [NSString stringWithFormat:@"%@ %ld", nameJustRight, (long)i];
        [self.habitViewController createHabit];
    }
    
    //making the 99th habit
    self.habitViewController.name.text =[NSString stringWithFormat:@"%@ %ld", nameJustRight, (long)99];
    XCTAssertEqual([self.habitViewController createHabit], 0);
    
    //too many habits exist
    self.habitViewController.name.text = [NSString stringWithFormat:@"%@ %ld", nameJustRight, (long)100];
    XCTAssertEqual([self.habitViewController createHabit], 2);
}

- (void)testDisplayAlert
{
    id UIAlertViewMock = OCMClassMock([UIAlertView class]);
    [self.habitViewController displayAlert:UIAlertViewMock];
    OCMVerify([UIAlertViewMock show]);
    
}

@end
