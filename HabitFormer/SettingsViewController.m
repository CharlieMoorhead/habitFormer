//
//  SettingsViewController.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 9/30/14.
//  Copyright (c) 2014 Charlie Moorhead. All rights reserved.
//

#import "SettingsViewController.h"
#import "MainViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = backgroundColor;
    self.title = @"Settings";
    
    //self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    //time label
    self.timeView = [[UIView alloc] init];
    self.timeView.translatesAutoresizingMaskIntoConstraints = NO;
    self.timeView.backgroundColor = labelColor;
    [self.view addSubview:self.timeView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.timeView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0f
                                                                  constant:45.0f
                                      ]];//0
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.timeView
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1.0f
                                                                   constant:0.0f
                                      ]];//1
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.timeView
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0f
                                                                   constant:10.0f
                                      ]];//2
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.timeView
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0f
                                                                   constant:0.0f
                                      ]];//3
    
    self.timeTitleLabel = [[UILabel alloc] init];
    self.timeTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.timeTitleLabel setText:@"daily reset time"];
    [self.timeTitleLabel setTextColor:textColor];
    [self.timeView addSubview:self.timeTitleLabel];
    [self.timeView addConstraint:[NSLayoutConstraint constraintWithItem:self.timeTitleLabel
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.timeView
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0f
                                                          constant:15.0f
                             ]];//0
    [self.timeView addConstraint:[NSLayoutConstraint constraintWithItem:self.timeTitleLabel
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.timeView
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f
                                                          constant:0.0f
                             ]];//1
    
    MainViewController *mainView = (MainViewController *)self.navigationController.viewControllers[0];
    self.timeViewLabel = [[UILabel alloc] init];
    self.timeViewLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.timeViewLabel setText:[DateUtils getStringFromDate:mainView.resetTime format:@"hh:mm a"]];
    [self.timeViewLabel setTextColor:textColor];
    [self.timeView addSubview:self.timeViewLabel];
    [self.timeView addConstraint:[NSLayoutConstraint constraintWithItem:self.timeViewLabel
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.timeView
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f
                                                          constant:0.0f
                             ]];//2
    [self.timeView addConstraint:[NSLayoutConstraint constraintWithItem:self.timeViewLabel
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.timeView
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0f
                                                          constant:-15.0f
                             ]];//3
    //end time label
    
    [self.view bringSubviewToFront:self.timeView];
    
    self.timePickerHider = [[UIView alloc] init];
    self.timePickerHider.translatesAutoresizingMaskIntoConstraints = NO;
    self.timePickerHider.backgroundColor = backgroundColor;
    [self.view addSubview:self.timePickerHider];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.timePickerHider
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0f
                                                                   constant:0.0f
                                      ]];//4
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.timePickerHider
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.timeView
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0f
                                                                   constant:0.0f
                                      ]];//5
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.timePickerHider
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1.0f
                                                                   constant:0.0f
                                      ]];//6
    
    self.timePicker = [[UIDatePicker alloc] init];
    self.timePicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.timePicker.datePickerMode = UIDatePickerModeTime;
    self.timePicker.backgroundColor = labelColor;
    [self.timePicker setBackgroundColor:labelColor];
    [self.timePicker setTintColor:textColor];
    
    self.timePicker.date = [DateUtils getDateFromString:self.timeViewLabel.text format:@"hh:mm a"];
    
    [self.timePicker addTarget:self action:@selector(timePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.timePicker setUserInteractionEnabled:NO];
    [self.view addSubview:self.timePicker];
    [self.view sendSubviewToBack:self.timePicker];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.timePicker
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1.0f
                                                                   constant:0.0f
                                      ]];//7
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.timePicker
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f
                                                                   constant:162.0f
                                      ]];//8
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.timePicker
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.timeView
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0f
                                                                   constant:0.0f
                                      ]];//9
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(togglePicker:)];
    [self.timeView addGestureRecognizer:tapGestureRecognizer];
    
}

- (void) timePickerValueChanged
{
    self.timeViewLabel.text = [DateUtils getStringFromDate:[self.timePicker date] format:@"hh:mm a"];
    
    MainViewController *mainView = (MainViewController *)self.navigationController.viewControllers[0];
    mainView.resetTime = [self.timePicker date];
}

- (void) togglePicker: (id) sender
{
    [self.timeView setUserInteractionEnabled:NO];
    
    if(self.timePicker.userInteractionEnabled == NO)
    {
        //the next two lines reset the timepicker to the right time, and stop any rolling animation
        //I had to set the timepicker to the current date, otherwise the rolling animation wouldn't always be stopped
        //...for some reason I don't understand
        [self.timePicker setDate:[NSDate date] animated:NO];
        [self.timePicker setDate:[DateUtils getDateFromString:self.timeViewLabel.text format:@"hh:mm a"] animated:NO];
        
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.6 animations:^{
            ((NSLayoutConstraint *)self.view.constraints[9]).constant = self.timePicker.frame.size.height;
            [self.view layoutIfNeeded];
        }completion:^(BOOL done){
            if (done)
            {
                [self.timeView setUserInteractionEnabled:YES];
                [self.timePicker setUserInteractionEnabled:YES];
            }
        }];
    }
    else
    {
        [self.timePicker setUserInteractionEnabled:NO];
        [UIView animateWithDuration:0.6 animations:^{
            ((NSLayoutConstraint *)self.view.constraints[9]).constant = 0.0f;
            [self.view layoutIfNeeded];
        }completion:^(BOOL done){
            if (done)
            {
                [self.timeView setUserInteractionEnabled:YES];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
