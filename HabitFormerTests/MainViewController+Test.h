//
//  MainViewController+Test.h
//  HabitFormer
//
//  Created by Charlie Moorhead on 8/3/15.
//  Copyright (c) 2015 Charlie Moorhead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainViewController.h"

@interface MainViewController (Test)

- (NSInteger)createHabit:(NSString *)name;
- (void)deleteHabitWithName:(NSString *)name atSectionIndex:(NSInteger)section;

@end