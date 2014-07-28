//
//  MainViewController.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 3/8/14.
//  Copyright (c) 2014 Charlie Moorhead. All rights reserved.
//

#import "NewHabitViewController.h"
#import "MainViewController.h"
#import "Habit.h"
#import <QuartzCore/QuartzCore.h>

@interface MainViewController ()

@end

@implementation MainViewController

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
    
    //creatng a scroll view
    CGRect fullScreenRect = [[UIScreen mainScreen] applicationFrame];
    self.scrollView = [[UIScrollView alloc] initWithFrame:fullScreenRect];
    self.scrollView.contentSize = CGSizeMake(320,0);
    self.scrollView.backgroundColor = [UIColor colorWithRed:255/255.0f green:247/255.0f blue:145/255.0f alpha:1.0f];
    self.view = self.scrollView;
    //scroll view created
    
    /*
    //creating main label
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    self.label.backgroundColor = [UIColor grayColor];
    self.label.text = @"Hello World!";
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];
    //main label created
    
    //adding tap recognicition to main label
    self.label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapLabel:)];
    [self.label addGestureRecognizer:tapGesture];
    //tap recognicition added
     */
    
    //initializing habits array
    self.habits = [[NSMutableDictionary alloc] init];
    [self loadDataFromDisk];
    //self.label.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.habits count]];
    //habits array initialized
    
    //init habitSubviews array
    self.habitSubviews = [[NSMutableArray alloc] init];
    [self viewAllHabits];
    //habitSubviews array initialized
    
    /*
    //new button
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [newButton setTitle:@"New" forState:UIControlStateNormal];
    [newButton sizeToFit];
    newButton.center = CGPointMake(245, 25);
    [newButton addTarget:self action:@selector(newHabit) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:newButton];
    //end new button
    */
    
    //new button on nav bar
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newHabit)];
    self.navigationItem.rightBarButtonItems = @[newButton];
    //end nav bar button
    
    //testing dates
    /*
    NSDate *d = [[NSDate alloc] init];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MMM-yy, HH:mm:ss"];
    
    NSDate *d2;
    d2 = [df dateFromString:@"17-Jun-14, 09:00:00"];
    
    
    NSLog([df dateFormat]);
    NSLog([df stringFromDate:d2]);
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSDayCalendarUnit fromDate:d];
    [dateComponents setDay:dateComponents.day + 3];
    
    d = [calendar dateFromComponents:dateComponents];
    NSLog([df stringFromDate:d]);
    
    NSLog([NSString stringWithFormat:@"%i", dateComponents.day]);
    
    Habit *h = [self.habits valueForKey:@"Cheeseburgers"];
    d = h.lastCompletion;
    NSLog(h.name);
    NSLog([df stringFromDate:d]);
    NSLog([df stringFromDate:[[self.habits valueForKey:@"Cheeseburgers"] lastCompletion]]);
    */
    //end testing dates
    
    /* testing sorting arrays
    NSArray *allHabits = [self.habits allValues];
    NSLog([NSString stringWithFormat:@"%i", allHabits.count]);
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastCompletion" ascending:false];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    allHabits = [allHabits sortedArrayUsingDescriptors:sortDescriptors];
    for (Habit *n in allHabits)
    {
        NSLog(n.name);
    }
    */
    
    
}

/*
- (void)didTapLabel:(UITapGestureRecognizer *)tapGesture {
    [self createHabit:@"Cheese"];
}
 */

//addNewHabit: called when returning from the new habit view
- (void)addNewHabit:(NewHabitViewController *)controller newHabitName:(NSString *)name
{
    [self createHabit:name];
}

- (void)createHabit:(NSString *)name
{
    Habit *h = [[Habit alloc] init];
    h.name = name;
    h.lastCompletion = [NSDate date];
    [self.habits setObject:h forKey:h.name];
    [self displayHabit:h];
}

- (void)displayHabit:(Habit *)habit
{
    NSInteger labelHeight = 45;
    NSInteger labelBuffer = 10;
    NSInteger labelDelta = 20;
    
    UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, self.habitSubviews.count*(labelHeight + labelBuffer) + labelDelta, 320, labelHeight + labelBuffer)];
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, labelHeight)];
    newLabel.text = habit.name;
    /*
    //testing to display completion date
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MMM-yy, HH:mm"];
    newLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:habit.lastCompletion]];
    //done testing
    */
    newLabel.textAlignment = NSTextAlignmentCenter;
    newLabel.layer.cornerRadius = 5;
    newLabel.layer.masksToBounds = YES;
    newLabel.backgroundColor = [UIColor lightGrayColor];
    
    newLabel.tag = self.habitSubviews.count+1;
    [labelView addSubview:newLabel];
    
    //add 'done' button
    UIButton *done = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [done setTitle:@"done" forState:UIControlStateNormal];
    [done sizeToFit];
    done.center = CGPointMake(260, labelHeight / 2.0f);
    done.tag = newLabel.tag + 100;
    [done addTarget:self action:@selector(completeHabit:) forControlEvents:UIControlEventTouchDown];
    [labelView addSubview:done];
    [labelView bringSubviewToFront:done];
    //'done' button
    
    //add last completion date
    UILabel *lastCompletionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 0, 0)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yy, HH:mm:ss"];
    lastCompletionLabel.text = [dateFormatter stringFromDate:habit.lastCompletion];
    
    [lastCompletionLabel setFont:[UIFont systemFontOfSize:10]];
    [lastCompletionLabel sizeToFit];
    [labelView addSubview:lastCompletionLabel];
    //last completion date
    
    [self.scrollView setContentSize:CGSizeMake(320, self.habitSubviews.count*(labelHeight + labelBuffer) + labelDelta)];
    [self.habitSubviews addObject:labelView];
    [self.view addSubview:labelView];
    
}

-(void) viewAllHabits
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastCompletion" ascending:true];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSArray *allHabits = [[self.habits allValues] sortedArrayUsingDescriptors:sortDescriptors];
    for (Habit *habit in allHabits)
    {
        if ([self shouldViewHabit:habit])
        {
            [self displayHabit:habit];
        }
    }
}

-(void) removeAllHabits
{
    for (UIView *view in self.habitSubviews) {
        [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [view removeFromSuperview];
    }
    [self.habitSubviews removeAllObjects];
}

- (void)completeHabit: (id)sender
{
    NSInteger tag = [(UIButton*)sender tag];
    UILabel *lbl = (UILabel*)[self.view viewWithTag:tag%100];
    NSString *habitKey = lbl.text;
    [self removeAllHabits];
    
    Habit *h = [self.habits objectForKey:habitKey];
    h.lastCompletion = [NSDate date];
    
    [self viewAllHabits];
}

- (BOOL)shouldViewHabit: (Habit *)habit
{
    NSInteger cutoffHour = 7;
    NSDate *cutoffDate = [NSDate alloc];
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
    cutoffDate = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:[NSDate date]]];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    dateComponents = [calendar components:NSHourCalendarUnit fromDate:[NSDate date]];
    
    if (dateComponents.hour < cutoffHour)
    {
        dateComponents.day = -1;
    }
    else
    {
        dateComponents.day = 0;
    }
    dateComponents.hour = cutoffHour;
    
    cutoffDate = [calendar dateByAddingComponents:dateComponents toDate:cutoffDate options:0];
    
    return [cutoffDate compare:habit.lastCompletion] == NSOrderedDescending;
}

//newHabit: push to the new habit view controller
-(void) newHabit
{
    NewHabitViewController *secondView = [[NewHabitViewController alloc] init];
    secondView.delegate = self;
    [self.navigationController pushViewController:secondView animated:YES];
}

- (NSString *)pathForDataFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *file = [documentsDirectory stringByAppendingPathComponent:@"HabitFormer.HabitStore"];
    return file;
}

-(void)loadDataFromDisk
{
    NSString *file = [self pathForDataFile];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
        self.habits = (NSMutableDictionary *)[NSKeyedUnarchiver unarchiveObjectWithFile:file];
        self.label.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.habits count]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
