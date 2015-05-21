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


@interface MainViewController : UIViewController <NewHabitViewControllerDelegate,
                                                    UINavigationControllerDelegate,
                                                    UITableViewDataSource,
                                                    UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableDictionary *habits;
@property (nonatomic,strong) NSMutableArray *habitsToView;
@property (nonatomic,strong) NSDate *resetTime;

@property (nonatomic, strong) DBManager *dbManager;

@end
