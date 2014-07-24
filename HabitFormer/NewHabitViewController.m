//
//  NewHabitViewController.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 6/5/14.
//  Copyright (c) 2014 Charlie Moorhead. All rights reserved.
//

#import "MainViewController.h"
#import "Habit.h"
#import "NewHabitViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface NewHabitViewController ()

@end

@implementation NewHabitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:247/255.0f blue:145/255.0f alpha:1.0f];
    self.title = @"New Habit";
    UIColor *labelColor = [UIColor lightGrayColor];
    
    //set up connecting label between name label and text field
    UILabel *connectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(43, 150, 10, 30)];
    connectionLabel.backgroundColor = labelColor;
    [self.view addSubview:connectionLabel];
    //end connection
    
    //set up name textfield
    self.name = [[UITextField alloc] initWithFrame:CGRectMake(48, 150, 262, 30)];
    self.name.backgroundColor = labelColor;
    self.name.delegate = self;
    self.name.layer.cornerRadius = 5;
    self.name.layer.masksToBounds = YES;
    [self.view addSubview:self.name];
    //end name text field
    
    //set up name label
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 38,30)];
    self.nameLabel.backgroundColor = labelColor;
    [self.nameLabel setFont:[UIFont systemFontOfSize:12]];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.text = @"name";
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.layer.cornerRadius = 5;
    self.nameLabel.layer.masksToBounds = YES;
    [self.view addSubview:self.nameLabel];
    //end name label
    
    //set up create button
    self.create = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.create setTitle:@"Create" forState:UIControlStateNormal];
    [self.create sizeToFit];
    self.create.center = CGPointMake(160, 210);
    [self.create addTarget:self action:@selector(createHabit) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.create];
    //end create button
}

-(void)createHabit {
    if (self.name.text.length == 0) {
        self.nameLabel.textColor = [UIColor redColor];
    }
    else
    {
        [self.delegate addNewHabit:self newHabitName:self.name.text];
        [[self navigationController] popToRootViewControllerAnimated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
