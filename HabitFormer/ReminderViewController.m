//
//  ReminderViewController.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 11/23/15.
//  Copyright © 2015 Charlie Moorhead. All rights reserved.
//

#import "ReminderViewController.h"
#import "DateUtils.h"

@interface ReminderViewController ()

@end

@implementation ReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:self.habit.name];
    [self.view setBackgroundColor:backgroundColor];
    
    UIView *reminderSettingView = [[UIView alloc] init];
    reminderSettingView.translatesAutoresizingMaskIntoConstraints = NO;
    [reminderSettingView setBackgroundColor:labelColor];
    
    [self.view addSubview:reminderSettingView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:reminderSettingView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0.0f
                              ]];//0
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:reminderSettingView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0f
                                                           constant:50.0f
                              ]];//1
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:reminderSettingView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:0.0f
                              ]];//2
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:reminderSettingView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:10.0f
                              ]];//3
    
    UILabel *reminderLabel = [[UILabel alloc] init];
    reminderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [reminderLabel setText:@"daily reminder"];
    [reminderLabel setTextColor:textColor];
    [reminderSettingView addSubview:reminderLabel];
    
    [reminderSettingView addConstraint:[NSLayoutConstraint constraintWithItem:reminderLabel
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:reminderSettingView
                                                                    attribute:NSLayoutAttributeHeight
                                                                   multiplier:1.0f
                                                                     constant:0.0f
                                        ]];//1
    [reminderSettingView addConstraint:[NSLayoutConstraint constraintWithItem:reminderLabel
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:reminderSettingView
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f
                                                                     constant:0.0f
                                        ]];//2
    [reminderSettingView addConstraint:[NSLayoutConstraint constraintWithItem:reminderLabel
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:reminderSettingView
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0f
                                                                     constant:15.0f
                                        ]];//3
    
    self.toggle = [[UISwitch alloc] init];
    self.toggle.translatesAutoresizingMaskIntoConstraints = NO;
    [self.toggle setTintColor:buttonColor];
    [self.toggle setOnTintColor:buttonColor];
    [self.toggle addTarget:self action:@selector(toggleReminder) forControlEvents:UIControlEventValueChanged];
    
    [reminderSettingView addSubview:self.toggle];
    [reminderSettingView addConstraint:[NSLayoutConstraint constraintWithItem:self.toggle
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:reminderSettingView
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0f
                                                                     constant:-15.0f
                                        ]];
    [reminderSettingView addConstraint:[NSLayoutConstraint constraintWithItem:self.toggle
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:reminderSettingView
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0f
                                                                     constant:0.0f
                                        ]];
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    [self.datePicker setDate:[DateUtils getDateFromString:@"00:00:00" format:@"HH:mm:ss"]];
    [self.datePicker setDatePickerMode:UIDatePickerModeTime];
    [self.datePicker setBackgroundColor:labelColor];
    [self.datePicker setTintColor:textColor];
    [self.datePicker addTarget:self action:@selector(changeReminder) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.datePicker];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.datePicker
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:reminderSettingView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:0.0f
                              ]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.datePicker
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0.0f
                              ]];
    
    NSArray *scheduledNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in scheduledNotifications)
    {
        if ([[notification alertBody] isEqualToString:[self reminderText]])
        {
            self.reminder = notification;
            [self.toggle setOn:YES];
            [self.datePicker setDate:[notification fireDate]];
        }
    }
}

-(void)toggleReminder
{
    if(self.toggle.on)
    {
        self.reminder = [[UILocalNotification alloc] init];
        self.reminder.fireDate = [self.datePicker date];
        self.reminder.alertBody = [self reminderText];
        self.reminder.repeatInterval = NSDayCalendarUnit;
        //localNotification.timeZone = [NSTimeZone defaultTimeZone];
        [[UIApplication sharedApplication] scheduleLocalNotification:self.reminder];
    }
    else
    {
        [self cancelNotification:[self reminderText]];
    }
    
}

-(void)changeReminder
{
    if(self.toggle.on)
    {
        NSArray *s = [[UIApplication sharedApplication] scheduledLocalNotifications];
        [self cancelNotification:[self.reminder alertBody]];
        [self.reminder setFireDate:self.datePicker.date];
        [[UIApplication sharedApplication] scheduleLocalNotification:self.reminder];
        s = [[UIApplication sharedApplication] scheduledLocalNotifications];
        int i = 1;
    }
}

- (NSString *)reminderText
{
    return [NSString stringWithFormat:@"Don't forget: '%@'", self.habit.name];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) cancelNotification: (NSString *)alertBody
{
    NSArray *scheduledNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in scheduledNotifications)
    {
        if ([[notification alertBody] isEqualToString:alertBody])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
