//
//  SettingsViewController.h
//  HabitFormer
//
//  Created by Charlie Moorhead on 9/30/14.
//  Copyright (c) 2014 Charlie Moorhead. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (nonatomic,strong) UIView *settingsView;
@property (nonatomic,strong) UILabel *timeViewLabel;
@property (nonatomic,strong) UIDatePicker *timePicker;

@end
