//
//  SettingsViewControllerTests.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 7/27/15.
//  Copyright (c) 2015 Charlie Moorhead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MainViewController.h"
#import "HabitFormerAppDelegate.h"
#import "SettingsViewController+Test.h"
#import "UIView+Test.h"

@interface SettingsViewControllerTests : XCTestCase

@property (nonatomic,strong) UINavigationController *navController;
@property (nonatomic,strong) SettingsViewController *settingsViewController;
@property (nonatomic,strong) NSDate *testDate;

@end

@implementation SettingsViewControllerTests

- (void)setUp {
    [super setUp];
    
    HabitFormerAppDelegate *appDelegate = (HabitFormerAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIWindow *appWindow = [appDelegate window];
    self.navController = (UINavigationController *)[appWindow rootViewController];
    
    self.testDate = [DateUtils getDateFromString:@"05:00 PM" format:@"hh:mm a"];
    MainViewController *mainView = (MainViewController *)self.navController.viewControllers[0];
    mainView.resetTime = self.testDate;
    
    self.settingsViewController = [[SettingsViewController alloc] init];
    [self.navController pushViewController:self.settingsViewController animated:NO];
    [self.settingsViewController view];
}

- (void)tearDown {
    
    [self.navController popToRootViewControllerAnimated:NO];
    
    [super tearDown];
}

- (void)testIsTopAndVisibleAfterPush
{
    XCTAssertEqualObjects([self.navController topViewController], self.settingsViewController);
    XCTAssertEqualObjects([self.navController visibleViewController], self.settingsViewController);
}

- (void)testViewAttributes
{
    NSString *expectedTitle = @"Settings";
    UIColor *expectedBackgroundColor = backgroundColor;
    
    XCTAssertEqualObjects(self.settingsViewController.title, expectedTitle);
    XCTAssertEqualObjects(self.settingsViewController.view.backgroundColor, expectedBackgroundColor);
}

- (void)testElementsExist
{
    XCTAssertNotNil(self.settingsViewController.timeView);
    XCTAssertNotNil(self.settingsViewController.timeViewLabel);
    XCTAssertNotNil(self.settingsViewController.timeTitleLabel);
    XCTAssertNotNil(self.settingsViewController.timePicker);
    XCTAssertNotNil(self.settingsViewController.timePickerHider);
}

- (void)testTimeView
{
    XCTAssertEqualObjects(self.settingsViewController.timeView.backgroundColor, labelColor);
    XCTAssertEqual(self.settingsViewController.timeView.subviews.count, 2);
    XCTAssertEqual(self.settingsViewController.timeView.gestureRecognizers.count, 1);
}

- (void)testTimeTitleLabel
{
    XCTAssertEqualObjects(self.settingsViewController.timeTitleLabel.textColor, textColor);
    XCTAssertEqualObjects(self.settingsViewController.timeTitleLabel.text, @"daily reset time");
}

- (void)testTimeViewLabel
{
    XCTAssertEqualObjects(self.settingsViewController.timeViewLabel.textColor, textColor);
    XCTAssertEqualObjects(self.settingsViewController.timeViewLabel.text, @"05:00 PM");
}

- (void)testTimePickerHider
{
    XCTAssertEqualObjects(self.settingsViewController.timePickerHider.backgroundColor, backgroundColor);
}

- (void)testTimePicker
{
    UIColor *timePickerBackgroundColor = ((UIView*)[self.settingsViewController.timePicker.subviews firstObject]).backgroundColor;
    NSArray *timePickerActions = [self.settingsViewController.timePicker actionsForTarget:self.settingsViewController
                                                                          forControlEvent:UIControlEventValueChanged];
    
    XCTAssertEqual(self.settingsViewController.timePicker.datePickerMode, UIDatePickerModeTime);
    XCTAssertEqualObjects(timePickerBackgroundColor, labelColor);
    XCTAssertEqualObjects(self.settingsViewController.timePicker.tintColor, textColor);
    XCTAssertEqualObjects(self.settingsViewController.timePicker.date, self.testDate);
    XCTAssertEqualObjects([timePickerActions firstObject], @"timePickerValueChanged");
    
}

- (void)testConstraints
{
    XCTAssertEqual(self.settingsViewController.view.constraints.count, 10);
    XCTAssertEqual(self.settingsViewController.timeView.constraints.count, 4);
    
    NSLayoutConstraint *c = (NSLayoutConstraint *)self.settingsViewController.view.constraints[0];

    c = (NSLayoutConstraint *)self.settingsViewController.view.constraints[0];
    XCTAssertEqualObjects(c.firstItem, self.settingsViewController.timeView);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeHeight);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertNil(c.secondItem);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeNotAnAttribute);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 45.0f);

    c = (NSLayoutConstraint *)self.settingsViewController.view.constraints[1];
    XCTAssertEqualObjects(c.firstItem, self.settingsViewController.timeView);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeWidth);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.settingsViewController.view);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeWidth);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 0.0f);

    c = (NSLayoutConstraint *)self.settingsViewController.view.constraints[2];
    XCTAssertEqualObjects(c.firstItem, self.settingsViewController.timeView);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeTop);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.settingsViewController.view);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeTop);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 10.0f);

    c = (NSLayoutConstraint *)self.settingsViewController.view.constraints[3];
    XCTAssertEqualObjects(c.firstItem, self.settingsViewController.timeView);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeLeft);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.settingsViewController.view);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeLeft);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 0.0f);

    c = (NSLayoutConstraint *)self.settingsViewController.view.constraints[4];
    XCTAssertEqualObjects(c.firstItem, self.settingsViewController.timePickerHider);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeTop);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.settingsViewController.view);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeTop);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 0.0f);

    c = (NSLayoutConstraint *)self.settingsViewController.view.constraints[5];
    XCTAssertEqualObjects(c.firstItem, self.settingsViewController.timePickerHider);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeBottom);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.settingsViewController.timeView);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeTop);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 0.0f);

    c = (NSLayoutConstraint *)self.settingsViewController.view.constraints[6];
    XCTAssertEqualObjects(c.firstItem, self.settingsViewController.timePickerHider);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeWidth);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.settingsViewController.view);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeWidth);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 0.0f);

    c = (NSLayoutConstraint *)self.settingsViewController.view.constraints[7];
    XCTAssertEqualObjects(c.firstItem, self.settingsViewController.timePicker);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeWidth);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.settingsViewController.view);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeWidth);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 0.0f);

    c = (NSLayoutConstraint *)self.settingsViewController.view.constraints[8];
    XCTAssertEqualObjects(c.firstItem, self.settingsViewController.timePicker);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeHeight);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertNil(c.secondItem);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeNotAnAttribute);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 162.0f);

    c = (NSLayoutConstraint *)self.settingsViewController.view.constraints[9];
    XCTAssertEqualObjects(c.firstItem, self.settingsViewController.timePicker);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeBottom);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.settingsViewController.timeView);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeBottom);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 0.0f);
    
    c = (NSLayoutConstraint *)self.settingsViewController.timeView.constraints[0];
    XCTAssertEqualObjects(c.firstItem, self.settingsViewController.timeTitleLabel);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeLeft);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.settingsViewController.timeView);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeLeft);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 15.0f);

    c = (NSLayoutConstraint *)self.settingsViewController.timeView.constraints[1];
    XCTAssertEqualObjects(c.firstItem, self.settingsViewController.timeTitleLabel);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeCenterY);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.settingsViewController.timeView);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeCenterY);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 0.0f);

    c = (NSLayoutConstraint *)self.settingsViewController.timeView.constraints[2];
    XCTAssertEqualObjects(c.firstItem, self.settingsViewController.timeViewLabel);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeCenterY);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.settingsViewController.timeView);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeCenterY);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 0.0f);
    
    c = (NSLayoutConstraint *)self.settingsViewController.timeView.constraints[3];
    XCTAssertEqualObjects(c.firstItem, self.settingsViewController.timeViewLabel);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeRight);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.settingsViewController.timeView);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeRight);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, -15.0f);

}

- (void)testTimePickerValueChanged
{
    NSString *testDateString = @"12:34 PM";
    NSDate *testDate = [DateUtils getDateFromString:testDateString format:@"hh:mm a"];
    MainViewController *mainView = (MainViewController *)self.navController.viewControllers[0];
    
    [self.settingsViewController.timePicker setDate:testDate];
    
    [self.settingsViewController.timePicker sendActionsForControlEvents:UIControlEventValueChanged];
    
    XCTAssertEqualObjects(self.settingsViewController.timeViewLabel.text, testDateString);
    XCTAssertEqualObjects(mainView.resetTime, testDate);
    
}

- (void)testTogglePicker
{
    NSLayoutConstraint *c = (NSLayoutConstraint *)self.settingsViewController.view.constraints[9];
    
    [self.settingsViewController togglePicker:nil];
    
    XCTAssertEqual(c.constant, self.settingsViewController.timePicker.frame.size.height);
    XCTAssertTrue(self.settingsViewController.timeView.userInteractionEnabled);
    XCTAssertTrue(self.settingsViewController.timePicker.userInteractionEnabled);
    
    [self.settingsViewController togglePicker:nil];
    
    XCTAssertEqual(c.constant, 0.0f);
    XCTAssertTrue(self.settingsViewController.timeView.userInteractionEnabled);
    XCTAssertFalse(self.settingsViewController.timePicker.userInteractionEnabled);
    
    
}

@end
