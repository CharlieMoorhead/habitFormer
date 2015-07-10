//
//  SettingsViewController.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 9/30/14.
//  Copyright (c) 2014 Charlie Moorhead. All rights reserved.
//

#import "SettingsViewController.h"
#import "MainViewController.h"
#import "utils.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [utils backgroundColor];
    self.title = @"Settings";
    
    self.settingsView = [[UIView alloc] init];
    self.settingsView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.settingsView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.settingsView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0f
                                                           constant:0.0f
                              ]];//0
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.settingsView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0.0f
                              ]];//1
    
    //time label
    UIView *timeView = [[UIView alloc] init];
    timeView.translatesAutoresizingMaskIntoConstraints = NO;
    timeView.backgroundColor = [utils labelColor];
    [self.settingsView addSubview:timeView];
    [self.settingsView addConstraint:[NSLayoutConstraint constraintWithItem:timeView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0f
                                                                  constant:45.0f
                                      ]];//0
    [self.settingsView addConstraint:[NSLayoutConstraint constraintWithItem:timeView
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.settingsView
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1.0f
                                                                   constant:0.0f
                                      ]];//1
    [self.settingsView addConstraint:[NSLayoutConstraint constraintWithItem:timeView
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.settingsView
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0f
                                                                   constant:10.0f
                                      ]];//2
    [self.settingsView addConstraint:[NSLayoutConstraint constraintWithItem:timeView
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.settingsView
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0f
                                                                   constant:0.0f
                                      ]];//3
    
    UILabel *timeTitleLabel = [[UILabel alloc] init];
    timeTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    timeTitleLabel.text = @"daily reset time";
    [timeView addSubview:timeTitleLabel];
    [timeView addConstraint:[NSLayoutConstraint constraintWithItem:timeTitleLabel
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:timeView
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0f
                                                          constant:15.0f
                             ]];//0
    [timeView addConstraint:[NSLayoutConstraint constraintWithItem:timeTitleLabel
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:timeView
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f
                                                          constant:0.0f
                             ]];//1
    
    MainViewController *mainView = (MainViewController *)self.navigationController.viewControllers[0];
    self.timeViewLabel = [[UILabel alloc] init];
    self.timeViewLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.timeViewLabel.text = [utils getStringFromDate:mainView.resetTime format:@"hh:mm a"];
    [timeView addSubview:self.timeViewLabel];
    [timeView addConstraint:[NSLayoutConstraint constraintWithItem:self.timeViewLabel
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:timeView
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f
                                                          constant:0.0f
                             ]];//2
    [timeView addConstraint:[NSLayoutConstraint constraintWithItem:self.timeViewLabel
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:timeView
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0f
                                                          constant:-15.0f
                             ]];//3
    //end time label
    
    [self.settingsView bringSubviewToFront:timeView];
    
    UIView *timePickerHider = [[UIView alloc] init];
    timePickerHider.translatesAutoresizingMaskIntoConstraints = NO;
    timePickerHider.backgroundColor = [utils backgroundColor];
    [self.settingsView addSubview:timePickerHider];
    [self.settingsView addConstraint:[NSLayoutConstraint constraintWithItem:timePickerHider
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.settingsView
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0f
                                                                   constant:0.0f
                                      ]];//4
    [self.settingsView addConstraint:[NSLayoutConstraint constraintWithItem:timePickerHider
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:timeView
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0f
                                                                   constant:0.0f
                                      ]];//5
    [self.settingsView addConstraint:[NSLayoutConstraint constraintWithItem:timePickerHider
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.settingsView
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1.0f
                                                                   constant:0.0f
                                      ]];//6
    
    self.timePicker = [[UIDatePicker alloc] init];
    self.timePicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.timePicker.datePickerMode = UIDatePickerModeTime;
    self.timePicker.backgroundColor = [utils labelColor];
    
    self.timePicker.date = [utils getDateFromString:self.timeViewLabel.text format:@"hh:mm a"];
    
    [self.timePicker addTarget:self action:@selector(timePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.timePicker setUserInteractionEnabled:NO];
    [self.settingsView addSubview:self.timePicker];
    [self.settingsView sendSubviewToBack:self.timePicker];
    [self.settingsView addConstraint:[NSLayoutConstraint constraintWithItem:self.timePicker
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.settingsView
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1.0f
                                                                   constant:0.0f
                                      ]];//7
    [self.settingsView addConstraint:[NSLayoutConstraint constraintWithItem:self.timePicker
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f
                                                                   constant:162.0f
                                      ]];//8
    [self.settingsView addConstraint:[NSLayoutConstraint constraintWithItem:self.timePicker
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:timeView
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0f
                                                                   constant:0.0f
                                      ]];//9
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(togglePicker:)];
    [timeView addGestureRecognizer:tapGestureRecognizer];
    
}

- (void) timePickerValueChanged
{
    self.timeViewLabel.text = [utils getStringFromDate:[self.timePicker date] format:@"hh:mm a"];
    
    MainViewController *mainView = (MainViewController *)self.navigationController.viewControllers[0];
    mainView.resetTime = [self.timePicker date];
}

- (void) togglePicker: (id) sender
{
    UIView *timeView = ((UIGestureRecognizer *)sender).view;
    [timeView setUserInteractionEnabled:NO];
    
    if(self.timePicker.userInteractionEnabled == NO)
    {
        self.timePicker.date = [utils getDateFromString:self.timeViewLabel.text format:@"hh:mm a"];
        [self.timePicker addTarget:self action:@selector(timePickerValueChanged) forControlEvents:UIControlEventValueChanged];
        [self.settingsView layoutIfNeeded];
        [UIView animateWithDuration:0.6 animations:^{
            ((NSLayoutConstraint *)self.settingsView.constraints[9]).constant = self.timePicker.frame.size.height;
            [self.settingsView layoutIfNeeded];
        }completion:^(BOOL done){
            if (done)
            {
                [timeView setUserInteractionEnabled:YES];
                [self.timePicker setUserInteractionEnabled:YES];
            }
        }];
    }
    else
    {
        [self.timePicker removeTarget:self action:@selector(timePickerValueChanged) forControlEvents:UIControlEventValueChanged];
        [self.timePicker setUserInteractionEnabled:NO];
        [UIView animateWithDuration:0.6 animations:^{
            ((NSLayoutConstraint *)self.settingsView.constraints[9]).constant = 0.0f;
            [self.settingsView layoutIfNeeded];
        }completion:^(BOOL done){
            if (done)
            {
                [timeView setUserInteractionEnabled:YES];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
