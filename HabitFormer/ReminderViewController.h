//
//  ReminderViewController.h
//  HabitFormer
//
//  Created by Charlie Moorhead on 11/23/15.
//  Copyright © 2015 Charlie Moorhead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Habit.h"

@interface ReminderViewController : UIViewController

@property Habit *habit;
@property UILocalNotification *reminder;
@property UISwitch *toggle;
@property UIDatePicker *datePicker;

@end
