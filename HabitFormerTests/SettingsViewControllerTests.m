//
//  SettingsViewControllerTests.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 7/27/15.
//  Copyright (c) 2015 Charlie Moorhead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HabitFormerAppDelegate.h"
#import "SettingsViewController.h"

@interface SettingsViewControllerTests : XCTestCase

@property (nonatomic,strong) UINavigationController *navController;
@property (nonatomic,strong) SettingsViewController *settingsViewController;

@end

@implementation SettingsViewControllerTests

- (void)setUp {
    [super setUp];
    
    HabitFormerAppDelegate *appDelegate = (HabitFormerAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIWindow *appWindow = [appDelegate window];
    self.navController = (UINavigationController *)[appWindow rootViewController];
    
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
    
    NSLog(@"%d", [self.settingsViewController.view.subviews count]);
}


@end
