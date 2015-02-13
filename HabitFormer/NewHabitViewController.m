//
//  NewHabitViewController.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 6/5/14.
//  Copyright (c) 2014 Charlie Moorhead. All rights reserved.
//


#import "NewHabitViewController.h"
#import "MainViewController.h"
#import "Habit.h"
#import "utils.h"

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
    
    self.view.backgroundColor = [utils backgroundColor];
    self.title = @"New Habit";
    UIColor *labelColor = [utils labelColor];
    
    /*//set up connecting label between name label and text field
    UILabel *connectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(43, 150, 10, 30)];
    connectionLabel.backgroundColor = labelColor;
    [self.view addSubview:connectionLabel];
    *///end connection
    
    //set up name textfield
    self.name = [[UITextField alloc] initWithFrame:CGRectMake(50, 150, [utils fullWidth] - 50, 45)];
    self.name.backgroundColor = labelColor;
    self.name.delegate = self;
    [self.view addSubview:self.name];
    //end name text field
    
    //set up name label
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 50, 45)];
    self.nameLabel.backgroundColor = labelColor;
    [self.nameLabel setFont:[UIFont systemFontOfSize:12]];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.text = @"name";
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.nameLabel];
    //end name label
    
    //set up create button
    self.create = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.create setTitle:@"Create" forState:UIControlStateNormal];
    [self.create setFrame:CGRectMake(0, 210, [utils fullWidth], 20)];
    [self.create.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.create addTarget:self action:@selector(createHabit) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.create];
    //end create button
}

-(void)createHabit {
    NSString *habitName = [self.name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (habitName.length == 0) {
        UIAlertController *tooShortAlert = [UIAlertController
                                         alertControllerWithTitle:nil
                                         message:@"Please enter a name"
                                         preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"of course"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       //of course...
                                   }];
        
        [tooShortAlert addAction:okAction];
        
        [self presentViewController:tooShortAlert animated:YES completion:nil];
    }
    else
    {
        NSInteger statusCode = [self.delegate addNewHabit:self newHabitName:habitName];
        
        switch (statusCode) {
            case 1: //name is already used
            {
                UIAlertController *inUseAlert = [UIAlertController
                                                 alertControllerWithTitle:nil
                                                 message:@"That habit already exists!"
                                                 preferredStyle:UIAlertControllerStyleAlert];
                
                
                UIAlertAction *okAction = [UIAlertAction
                                           actionWithTitle:@"oh, ok"
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                               //okay...
                                           }];
                
                [inUseAlert addAction:okAction];
                
                [self presentViewController:inUseAlert animated:YES completion:nil];
                break;
            }
                
            case 2: //already 99 habits
            {
                UIAlertController *tooManyAlert = [UIAlertController
                                                   alertControllerWithTitle:nil
                                                   message:@"Maybe you should focus on\nyour 99 other habits"
                                                   preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction
                                           actionWithTitle:@"fine"
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                               //fine...
                                           }];
                
                [tooManyAlert addAction:okAction];
                
                [self presentViewController:tooManyAlert animated:YES completion:nil];
                break;
            }
            
            case 3: //name is too long to be displayed
            {
                UIAlertController *tooLongAlert = [UIAlertController
                                                   alertControllerWithTitle:nil
                                                   message:@"That name is too long"
                                                   preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction
                                           actionWithTitle:@"ok"
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                               //Ok...
                                           }];
                
                [tooLongAlert addAction:okAction];
                
                [self presentViewController:tooLongAlert animated:YES completion:nil];
                break;
            }
                
            case 0: //habit created successfully
            default:
                [[self navigationController] popToRootViewControllerAnimated:YES];
                break;
        }
        
        
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
