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
#import <QuartzCore/QuartzCore.h>

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:247/255.0f blue:145/255.0f alpha:1.0f];
    self.title = @"Settings";
    
    self.settingsView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    self.navigationController.navigationBar.frame.size.height +
                                                                        [UIApplication sharedApplication].statusBarFrame.size.height,
                                                                    [utils fullWidth],
                                                                    [self fullHeight])];
    [self.view addSubview:self.settingsView];
    
    //time label
    UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, [utils fullWidth], 45)];
    timeView.backgroundColor = [UIColor lightGrayColor];
    
    [self.settingsView addSubview:timeView];
    
    UILabel *timeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 0, 0)];
    timeTitleLabel.text = @"daily reset time";
    [timeTitleLabel sizeToFit];
    timeTitleLabel.center = CGPointMake(timeTitleLabel.center.x, 45.0/2);
    [timeView addSubview:timeTitleLabel];
    
    self.timeViewLabel = [[UILabel alloc] init];
    
    MainViewController *mainView = (MainViewController *)self.navigationController.viewControllers[0];
    
    
    self.timeViewLabel.text = [utils getStringFromDate:mainView.resetTime format:@"hh:mm a"];
    [self.timeViewLabel sizeToFit];
    self.timeViewLabel.center = CGPointMake(self.timeViewLabel.center.x, 45.0/2);
    self.timeViewLabel.frame = CGRectMake([utils fullWidth] - 15 - self.timeViewLabel.frame.size.width, self.timeViewLabel.frame.origin.y, self.timeViewLabel.frame.size.width, self.timeViewLabel.frame.size.height);
    
    [timeView addSubview:self.timeViewLabel];
    //end time label
    
    [self.settingsView bringSubviewToFront:timeView];
    
    UIView *timePickerHider = [[UIView alloc] initWithFrame:CGRectMake(0,-200, [utils fullWidth] ,210)];
    timePickerHider.backgroundColor = [UIColor colorWithRed:255/255.0f green:247/255.0f blue:145/255.0f alpha:1.0f];
    [self.settingsView addSubview:timePickerHider];
    
    /*//testing border
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, timeView.frame.size.height, timeView.frame.size.width, 1);
    bottomBorder.backgroundColor = [UIColor darkGrayColor].CGColor;
    [timeView.layer addSublayer:bottomBorder];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0, 0, timeView.frame.size.width, 1);
    topBorder.backgroundColor = [UIColor darkGrayColor].CGColor;
    [timeView.layer addSublayer:topBorder];
    *///end border test
    
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
    
    if (self.timePicker.superview == nil)
    {
        self.timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, -1000, 0, 0)];
        self.timePicker.frame = CGRectMake(0, 55 - self.timePicker.frame.size.height, 0, 0);
        self.timePicker.datePickerMode = UIDatePickerModeTime;
        self.timePicker.backgroundColor = [UIColor lightGrayColor];
        
        /*
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0, self.timePicker.frame.size.height, self.timePicker.frame.size.width, 1);
        bottomBorder.backgroundColor = [UIColor darkGrayColor].CGColor;
        [self.timePicker.layer addSublayer:bottomBorder];
         */
        
        self.timePicker.date = [utils getDateFromString:self.timeViewLabel.text format:@"hh:mm a"];
        
        [self.settingsView addSubview:self.timePicker];
        [self.settingsView sendSubviewToBack:self.timePicker];
        
        [UIView animateWithDuration:0.6 animations:^{
            self.timePicker.frame = CGRectMake(0, 55, 0, 0);
        }completion:^(BOOL done){
            if (done)
            {
                [timeView setUserInteractionEnabled:YES];
                [self.timePicker addTarget:self action:@selector(timePickerValueChanged) forControlEvents:UIControlEventValueChanged];
            }
        }];
        
    }
    else
    {
        [self.timePicker removeTarget:self action:@selector(timePickerValueChanged) forControlEvents:UIControlEventValueChanged];
        [UIView animateWithDuration:0.6 animations:^{
            self.timePicker.frame = CGRectMake(0,55-self.timePicker.frame.size.height, 0, 0);
        }completion:^(BOOL done){
            if (done)
            {
                [timeView setUserInteractionEnabled:YES];
                [self.timePicker removeFromSuperview];
            }
        }];
    }
    
    
}

- (CGFloat)fullHeight
{
    return [utils fullHeight] - self.navigationController.navigationBar.frame.size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
