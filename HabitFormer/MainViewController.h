//
//  MainViewController.h
//  HabitFormer
//
//  Created by Charlie Moorhead on 3/8/14.
//  Copyright (c) 2014 Charlie Moorhead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewHabitViewController.h"

@interface MainViewController : UIViewController <NewHabitViewControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableDictionary *habits;
@property (nonatomic,strong) NSMutableArray *habitSubviews;
@property (nonatomic,strong) NSDate *resetTime;

@end
