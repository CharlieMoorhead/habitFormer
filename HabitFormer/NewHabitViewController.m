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

@interface NewHabitViewController ()

@end

@implementation NewHabitViewController

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = backgroundColor;
    self.title = @"New Habit";
    
    //set up name textfield
    self.name = [[UITextField alloc] init];
    self.name.translatesAutoresizingMaskIntoConstraints = NO;
    self.name.backgroundColor = labelColor;
    self.name.textColor = textColor;
    self.name.delegate = self;
    [self.view addSubview:self.name];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.name
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:50.0f
                              ]];//0
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.name
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:10.0f
                              ]];//1
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.name
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:-50.0f
                              ]];//2
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.name
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0f
                                                           constant:45.0f
                              ]];//3
    //end name text field
    
    //set up name label
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.backgroundColor = labelColor;
    [self.nameLabel setFont:[UIFont systemFontOfSize:12]];
    self.nameLabel.textColor = textColor;
    self.nameLabel.text = @"name";
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.nameLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:0.0f
                              ]];//4
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:10.0f
                              ]];//5
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0f
                                                           constant:50.0f
                              ]];//6
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0f
                                                           constant:45.0f
                              ]];//7
    //end name label
    
    //set up create button
    self.create = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.create.translatesAutoresizingMaskIntoConstraints = NO;
    [self.create setTintColor:buttonColor];
    [self.create setTitle:@"Create" forState:UIControlStateNormal];
    [self.create addTarget:self action:@selector(createHabit) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.create];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.create
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:0.21f
                                                           constant:0.0f
                              ]];//8
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.create
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0.0f
                              ]];//9
    //end create button
}

//returns:
//  0   success
//  4   too short (0 characters entered)
//  3   too long
//  2   too many habits (99 already exist)
//  1   name is already used
//
-(NSInteger)createHabit {
    NSString *habitName = [self.name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    if (habitName.length == 0) {
        UIAlertController *tooShortController = [UIAlertController alertControllerWithTitle:@"please enter a name"
                                                                                    message:nil
                                                                             preferredStyle:UIAlertControllerStyleAlert];
        [tooShortController addAction:okAction];
        
        [self presentViewController:tooShortController
                           animated:YES
                         completion:nil
         ];
        
        return 4;
    }
    else
    {
        NSInteger statusCode = [self.delegate addNewHabit:self newHabitName:habitName];
        
        switch (statusCode) {
            case 1: //name is already used
            {
                UIAlertController *inUseController = [UIAlertController alertControllerWithTitle:@"that habit already exists"
                                                                                          message:nil
                                                                                   preferredStyle:UIAlertControllerStyleAlert
                                                      ];
                [inUseController addAction:okAction];
                
                [self presentViewController:inUseController
                                   animated:YES
                                 completion:nil
                 ];
                
                return 1;
                break;
            }
                
            case 2: //already 99 habits
            {
                UIAlertController *tooManyController = [UIAlertController alertControllerWithTitle:@"maybe you should focus on\nyour 99 other habits"
                                                                                           message:nil
                                                                                    preferredStyle:UIAlertControllerStyleAlert
                                                        ];
                [tooManyController addAction:okAction];
                
                [self presentViewController:tooManyController
                                   animated:YES
                                 completion:nil
                 ];
                
                return 2;
                break;
            }
            
            case 3: //name is too long to be displayed
            {
                UIAlertController *tooLongController = [UIAlertController alertControllerWithTitle:@"that name is too long"
                                                                                           message:nil
                                                                                    preferredStyle:UIAlertControllerStyleAlert
                                                        ];
                [tooLongController addAction:okAction];
                
                [self presentViewController:tooLongController
                                   animated:YES
                                 completion:nil
                 ];

                return 3;
                break;
            }
                
            case 0: //habit created successfully
            default:
                [[self navigationController] popToRootViewControllerAnimated:YES];
                return 0;
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

@end
