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
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    self.title = @"Settings";
    
    self.settingsView = [[UIView alloc] initWithFrame:[self.view frame]];
    [self.settingsView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:self.settingsView];
    
    //time label
    UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 45)];
    timeView.backgroundColor = [utils labelColor];
    [timeView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.settingsView addSubview:timeView];
    
    UILabel *timeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 0, 0)];
    timeTitleLabel.text = @"daily reset time";
    [timeTitleLabel sizeToFit];
    timeTitleLabel.center = CGPointMake(timeTitleLabel.center.x, 45.0/2);
    [timeView addSubview:timeTitleLabel];
    
    
    MainViewController *mainView = (MainViewController *)self.navigationController.viewControllers[0];
    self.timeViewLabel = [[UILabel alloc] init];
    self.timeViewLabel.text = [utils getStringFromDate:mainView.resetTime format:@"hh:mm a"];
    [self.timeViewLabel sizeToFit];
    self.timeViewLabel.center = CGPointMake(self.timeViewLabel.center.x, 45.0/2);
    CGRect newFrame = self.timeViewLabel.frame;
    newFrame.origin.x = self.view.frame.size.width - 15 - newFrame.size.width;
    [self.timeViewLabel setFrame:newFrame];
    [self.timeViewLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    [timeView addSubview:self.timeViewLabel];
    //end time label
    
    [self.settingsView bringSubviewToFront:timeView];
    
    UIView *timePickerHider = [[UIView alloc] initWithFrame:CGRectMake(0,-200, self.view.frame.size.width ,210)];
    timePickerHider.backgroundColor = [utils backgroundColor];
    [timePickerHider setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
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
        self.timePicker = [[UIDatePicker alloc] init];
        self.timePicker.frame = CGRectMake(0, 54 - self.timePicker.frame.size.height, self.view.frame.size.width, 162);
        self.timePicker.datePickerMode = UIDatePickerModeTime;
        self.timePicker.backgroundColor = [utils labelColor];
        
        /*
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0, self.timePicker.frame.size.height, self.timePicker.frame.size.width, 1);
        bottomBorder.backgroundColor = [UIColor darkGrayColor].CGColor;
        [self.timePicker.layer addSublayer:bottomBorder];
         */
        
        self.timePicker.date = [utils getDateFromString:self.timeViewLabel.text format:@"hh:mm a"];
        
        [self.timePicker setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.settingsView addSubview:self.timePicker];
        [self.settingsView sendSubviewToBack:self.timePicker];
        
        [UIView animateWithDuration:0.6 animations:^{
            CGRect newFrame = self.timePicker.frame;
            newFrame.origin.y = 54;
            self.timePicker.frame = newFrame;
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
            CGRect newFrame = self.timePicker.frame;
            newFrame.origin.y = 54 - newFrame.size.height;
            self.timePicker.frame = newFrame;
        }completion:^(BOOL done){
            if (done)
            {
                [timeView setUserInteractionEnabled:YES];
                [self.timePicker removeFromSuperview];
            }
        }];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
