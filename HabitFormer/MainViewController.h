//
//  MainViewController.h
//  HabitFormer
//
//  Created by Charlie Moorhead on 3/8/14.
//  Copyright (c) 2014 Charlie Moorhead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewHabitViewController.h"
#import "DBManager.h"
#import "HabitDB.h"


@interface MainViewController : UIViewController <NewHabitViewControllerDelegate,
                                                    UINavigationControllerDelegate,
                                                    UITableViewDataSource,
                                                    UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableDictionary *habits;
@property (nonatomic,strong) NSMutableArray *habitsToView;
@property (nonatomic,strong) HabitDB *habitDB;
@property (nonatomic,strong) NSDate *resetTime;
@property (nonatomic,strong) UIView *emptyView;

@end


@interface MainViewController (test)

- (NSInteger)createHabit:(NSString *)name;
- (void)deleteHabitWithName:(NSString *)name atSectionIndex:(NSInteger)section;

@end
