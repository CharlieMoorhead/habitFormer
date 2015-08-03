//
//  HabitCellTests.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 7/10/15.
//  Copyright (c) 2015 Charlie Moorhead. All rights reserved.
//

#define TEST_HABIT_NAME @"test habit"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HabitFormerAppDelegate.h"
#import "MainViewController+Test.h"
#import "HabitCell.h"


@interface HabitCellTests : XCTestCase

@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) MainViewController *mainViewController;
@property (nonatomic,strong) HabitCell *cell;

@end

@implementation HabitCellTests

- (void)setUp {
    [super setUp];
    HabitFormerAppDelegate *appDelegate = (HabitFormerAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIWindow *appWindow = [appDelegate window];
    UINavigationController *navController = (UINavigationController *)[appWindow rootViewController];
    self.mainViewController = (MainViewController *)[navController delegate];
    self.table = self.mainViewController.tableView;
    
    [self.mainViewController createHabit:TEST_HABIT_NAME];
    for (HabitCell *cell in self.table.visibleCells)
    {
        if ([cell.habitLabel.text isEqualToString:TEST_HABIT_NAME])
        {
            self.cell = cell;
        }
    }
    
}

- (void)tearDown {
    
    for (HabitCell *cell in self.table.visibleCells)
    {
        if ([cell.habitLabel.text isEqualToString:TEST_HABIT_NAME])
        {
            [self.mainViewController deleteHabitWithName:cell.habitLabel.text
                                          atSectionIndex:[[self.table indexPathForCell:cell] section]];
        }
    }
    
    
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
}

- (void)testElementsExist
{
    XCTAssertNotNil(self.cell.habitLabel);
    XCTAssertNotNil(self.cell.daysAgoLabel);
    XCTAssertNotNil(self.cell.lastCompletionLabel);
    XCTAssertNotNil(self.cell.doneButton);
    XCTAssertNotNil(self.cell.deleteButton);
}

- (void)testConstraints
{
    XCTAssertEqual(self.cell.contentView.constraints.count, 14);
    
    NSLayoutConstraint *c = (NSLayoutConstraint *)self.cell.contentView.constraints[0];

    XCTAssertEqualObjects(c.firstItem, self.cell.habitLabel);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeCenterX);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.cell.contentView);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeCenterX);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 0.0f);

    c = (NSLayoutConstraint *)self.cell.contentView.constraints[1];
    
    XCTAssertEqualObjects(c.firstItem, self.cell.habitLabel);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeCenterY);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.cell.contentView);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeCenterY);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 0.0f);

    c = (NSLayoutConstraint *)self.cell.contentView.constraints[2];
    
    XCTAssertEqualObjects(c.firstItem, self.cell.daysAgoLabel);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeLeft);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.cell.contentView);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeLeft);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 15.0f);

    c = (NSLayoutConstraint *)self.cell.contentView.constraints[3];
    
    XCTAssertEqualObjects(c.firstItem, self.cell.daysAgoLabel);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeTop);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.cell.contentView);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeTop);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 2.0f);

    c = (NSLayoutConstraint *)self.cell.contentView.constraints[4];
    
    XCTAssertEqualObjects(c.firstItem, self.cell.lastCompletionLabel);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeRight);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.cell.contentView);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeRight);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, -15.0f);

    c = (NSLayoutConstraint *)self.cell.contentView.constraints[5];
    
    XCTAssertEqualObjects(c.firstItem, self.cell.lastCompletionLabel);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeTop);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.cell.contentView);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeTop);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 2.0f);

    c = (NSLayoutConstraint *)self.cell.contentView.constraints[6];
    
    XCTAssertEqualObjects(c.firstItem, self.cell.doneButton);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeWidth);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, nil);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeNotAnAttribute);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 50.0f);

    c = (NSLayoutConstraint *)self.cell.contentView.constraints[7];
    
    XCTAssertEqualObjects(c.firstItem, self.cell.doneButton);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeHeight);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.cell.contentView);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeHeight);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 0.0f);

    c = (NSLayoutConstraint *)self.cell.contentView.constraints[8];
    
    XCTAssertEqualObjects(c.firstItem, self.cell.doneButton);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeRight);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.cell.contentView);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeRight);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 0.0f);

    c = (NSLayoutConstraint *)self.cell.contentView.constraints[9];
    
    XCTAssertEqualObjects(c.firstItem, self.cell.doneButton);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeTop);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.cell.contentView);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeTop);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 0.0f);

    c = (NSLayoutConstraint *)self.cell.contentView.constraints[10];
    
    XCTAssertEqualObjects(c.firstItem, self.cell.deleteButton);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeWidth);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, nil);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeNotAnAttribute);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 50.0f);
    
    c = (NSLayoutConstraint *)self.cell.contentView.constraints[11];
    
    XCTAssertEqualObjects(c.firstItem, self.cell.deleteButton);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeHeight);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.cell.contentView);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeHeight);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 0.0f);
    
    c = (NSLayoutConstraint *)self.cell.contentView.constraints[12];
    
    XCTAssertEqualObjects(c.firstItem, self.cell.deleteButton);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeLeft);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.cell.contentView);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeLeft);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 0.0f);
    
    c = (NSLayoutConstraint *)self.cell.contentView.constraints[13];
    
    XCTAssertEqualObjects(c.firstItem, self.cell.deleteButton);
    XCTAssertEqual(c.firstAttribute, NSLayoutAttributeTop);
    XCTAssertEqual(c.relation, NSLayoutRelationEqual);
    XCTAssertEqualObjects(c.secondItem, self.cell.contentView);
    XCTAssertEqual(c.secondAttribute, NSLayoutAttributeTop);
    XCTAssertEqual(c.multiplier, 1.0f);
    XCTAssertEqual(c.constant, 0.0f);
}

- (void)testHabitLabel
{
    UIFont *expectedFont = [UIFont systemFontOfSize:17.0f];
    NSTextAlignment expectedAlighment = NSTextAlignmentCenter;
    UIColor *expectedTextColor = textColor;
    
    XCTAssertEqualObjects(self.cell.habitLabel.font, expectedFont);
    XCTAssertEqual(self.cell.habitLabel.textAlignment, expectedAlighment);
    XCTAssertEqualObjects(self.cell.habitLabel.textColor, expectedTextColor);
}

- (void)testDaysAgoLabel
{
    UIFont *expectedFont = [UIFont systemFontOfSize:10.0f];
    UIColor *expectedTextColor = textColor;
    
    XCTAssertEqualObjects(self.cell.daysAgoLabel.font, expectedFont);
    XCTAssertEqualObjects(self.cell.daysAgoLabel.textColor, expectedTextColor);
}

- (void)testLastCompletionLabel
{
    UIFont *expectedFont = [UIFont systemFontOfSize:10.0f];
    UIColor *expectedTextColor = textColor;
    
    XCTAssertEqualObjects(self.cell.lastCompletionLabel.font, expectedFont);
    XCTAssertEqualObjects(self.cell.lastCompletionLabel.textColor, expectedTextColor);
}

- (void)testDoneButton
{
    NSString *expectedTitleText = @"done";
    UIColor *expectedBackgroundColor = buttonColor;
    UIColor *expectedTitleTextColor = [UIColor whiteColor];
    UIFont *expectedTitleFont = [UIFont systemFontOfSize:12.0f];
    
    XCTAssertEqualObjects(self.cell.doneButton.titleLabel.text, expectedTitleText);
    XCTAssertEqualObjects(self.cell.doneButton.backgroundColor, expectedBackgroundColor);
    XCTAssertEqualObjects(self.cell.doneButton.titleLabel.textColor, expectedTitleTextColor);
    XCTAssertEqualObjects(self.cell.doneButton.titleLabel.font, expectedTitleFont);
}

- (void)testDeleteButton
{
    NSString *expectedTitleText = @"delete";
    UIColor *expectedBackgroundColor = buttonColor;
    UIColor *expectedTitleTextColor = [UIColor whiteColor];
    UIFont *expectedTitleFont = [UIFont systemFontOfSize:12.0f];
    
    XCTAssertEqualObjects(self.cell.deleteButton.titleLabel.text, expectedTitleText);
    XCTAssertEqualObjects(self.cell.deleteButton.backgroundColor, expectedBackgroundColor);
    XCTAssertEqualObjects(self.cell.deleteButton.titleLabel.textColor, expectedTitleTextColor);
    XCTAssertEqualObjects(self.cell.deleteButton.titleLabel.font, expectedTitleFont);
}

- (void)testSwitchToEditing
{
    CGFloat expectedDaysAgoAlpha = 0.0f;
    CGFloat expectedLastCompletionAlpha = 1.0f;
    CGFloat expectedDoneConstant = 50.0f;
    CGFloat expectedDeleteConstant = 0.0f;
    
    NSLayoutConstraint *doneConstraint = (NSLayoutConstraint *)self.cell.contentView.constraints[8];
    NSLayoutConstraint *deleteConstraint = (NSLayoutConstraint *)self.cell.contentView.constraints[12];
    
    [self.cell setEditing:YES];
    [self.cell layoutSubviews];
    
    XCTAssertEqual(self.cell.daysAgoLabel.alpha, expectedDaysAgoAlpha);
    XCTAssertEqual(self.cell.lastCompletionLabel.alpha, expectedLastCompletionAlpha);
    XCTAssertEqual(doneConstraint.constant, expectedDoneConstant);
    XCTAssertEqual(deleteConstraint.constant, expectedDeleteConstant);
}

- (void)testSwitchOutOfEditing
{
    CGFloat expectedDaysAgoAlpha = 1.0f;
    CGFloat expectedLastCompletionAlpha = 0.0f;
    CGFloat expectedDoneConstant = 0.0f;
    CGFloat expectedDeleteConstant = -50.0f;
    
    NSLayoutConstraint *doneConstraint = (NSLayoutConstraint *)self.cell.contentView.constraints[8];
    NSLayoutConstraint *deleteConstraint = (NSLayoutConstraint *)self.cell.contentView.constraints[12];
    
    [self.cell setEditing:NO];
    [self.cell layoutSubviews];
    
    XCTAssertEqual(self.cell.daysAgoLabel.alpha, expectedDaysAgoAlpha);
    XCTAssertEqual(self.cell.lastCompletionLabel.alpha, expectedLastCompletionAlpha);
    XCTAssertEqual(doneConstraint.constant, expectedDoneConstant);
    XCTAssertEqual(deleteConstraint.constant, expectedDeleteConstant);
}

@end
