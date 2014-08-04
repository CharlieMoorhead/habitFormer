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
    CGFloat height = fullScreenRect.size.height - self.navigationController.navigationBar.frame.size.height;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, fullScreenRect.size.width, height)];
    //1 is added to scrollview.contentsize height so that you can always scroll a little bit,
    //so you can always activate the refresh control
    self.scrollView.contentSize = CGSizeMake(fullScreenRect.size.width,height+1);
    self.scrollView.backgroundColor = [UIColor colorWithRed:255/255.0f green:247/255.0f blue:145/255.0f alpha:1.0f];
    self.view = self.scrollView;
    //scroll view created
    
    //initializing habits array
    self.habits = [[NSMutableDictionary alloc] init];
    [self loadDataFromDisk];
    //habits array initialized
    
    //init habitSubviews array and displaying habits
    self.habitSubviews = [[NSMutableArray alloc] init];
    [self refreshHabits];
    //habitSubviews array initialized and habits displayed
    
    //new button on nav bar
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newHabit)];
    self.navigationItem.rightBarButtonItems = @[newButton];
    //end nav new button
    
    //add edit button on nav bar
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editHabits)];
    self.navigationItem.leftBarButtonItems = @[editButton];
    //end nav edit button
    
    //adding refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshHabits) forControlEvents:UIControlEventValueChanged];
    refreshControl.tag = 999;
    [self.view addSubview:refreshControl];
    //refresh added
}

//addNewHabit: called when returning from the new habit view
- (void)addNewHabit:(NewHabitViewController *)controller newHabitName:(NSString *)name
{
    [self createHabit:name];
}

- (void)createHabit:(NSString *)name
{
    if ([self.habits objectForKey:name] != nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                message:@"That habit already exists"
                                                delegate:nil
                                                cancelButtonTitle:@"Oh, ok"
                                                otherButtonTitles:nil];
        [alert show];
    }
    else if (self.habits.count >= 99)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                message:@"Maybe you should focus on\nyour 99 other habits..."
                                                delegate:nil
                                                cancelButtonTitle:@"Fine"
                                                otherButtonTitles:nil];
        
        [alert show];
    }
    else
    {
        Habit *h = [[Habit alloc] init];
        h.name = name;
        h.lastCompletion = [self startingDate];
        [self.habits setObject:h forKey:h.name];
        [self refreshHabits];
    }
}

- (void)displayHabit:(Habit *)habit editHabit:(BOOL) editHabit
{
    NSInteger labelHeight = 45;
    NSInteger labelBuffer = 10;
    NSInteger labelDelta = 10;
    
    UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, self.habitSubviews.count*(labelHeight + labelBuffer) + labelDelta, 320, labelHeight + labelBuffer)];
    UILabel *habitLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, labelHeight)];
    habitLabel.text = habit.name;

    habitLabel.textAlignment = NSTextAlignmentCenter;
    habitLabel.layer.cornerRadius = 5;
    habitLabel.layer.masksToBounds = YES;
    habitLabel.backgroundColor = [UIColor lightGrayColor];
    
    habitLabel.tag = self.habitSubviews.count+1;
    [labelView addSubview:habitLabel];
    
    if (editHabit)
    {
        //add 'delete' button
        UIButton *delete = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [delete setTitle:@"delete" forState:UIControlStateNormal];
        [delete sizeToFit];
        delete.center = CGPointMake(40, labelHeight / 2.0f);
        delete.tag = habitLabel.tag + 200;
        [delete addTarget:self action:@selector(deleteHabit:) forControlEvents:UIControlEventTouchDown];
        [labelView addSubview:delete];
        [labelView bringSubviewToFront:delete];
        //delete button
    }
    else
    {
    
        //add 'done' button
        UIButton *done = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [done setTitle:@"done" forState:UIControlStateNormal];
        [done sizeToFit];
        done.center = CGPointMake(285, labelHeight / 2.0f);
        done.tag = habitLabel.tag + 100;
        [done addTarget:self action:@selector(completeHabit:) forControlEvents:UIControlEventTouchDown];
        [labelView addSubview:done];
        [labelView bringSubviewToFront:done];
        //'done' button
    
        //add last completion date
        UILabel *lastCompletionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 0, 0)];
    
        if ([habit.lastCompletion compare:[self startingDate]] == NSOrderedSame)
        {
            lastCompletionLabel.text = @"Never done";
        }
        else if ([self daysBetween:habit.lastCompletion and:[NSDate date]] == 1)
        {
            lastCompletionLabel.text = @"Last done: 1 day ago";
        }
        else
        {
            lastCompletionLabel.text =
                [NSString stringWithFormat:@"Last done: %d days ago",
                [self daysBetween:habit.lastCompletion and:[NSDate date]]];
        }
    
        [lastCompletionLabel setFont:[UIFont systemFontOfSize:10]];
        [lastCompletionLabel sizeToFit];
        [labelView addSubview:lastCompletionLabel];
        //last completion date added
    }
    
    
    [self.habitSubviews addObject:labelView];
    if (self.habitSubviews.count*(labelHeight + labelBuffer) + labelDelta > self.scrollView.contentSize.height)
    {
        [self.scrollView setContentSize:CGSizeMake(320, self.habitSubviews.count*(labelHeight + labelBuffer) + labelDelta)];
    }
    [self.view addSubview:labelView];
    
}

- (void)refreshHabits
{
    [self removeAllHabits];
    
    [self showHabits:false];
    
    UIRefreshControl *refreshControl = (UIRefreshControl *)[self.view viewWithTag:999];
    [refreshControl endRefreshing];
    
}

- (void)editHabits
{
    [self removeAllHabits];
    [self showHabits:true];
    
    UIBarButtonItem *doneButton= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishEdit)];
    self.navigationItem.leftBarButtonItems = @[doneButton];
    
    [[self.view viewWithTag:999] removeFromSuperview];
}

- (void)deleteHabit: (id)sender
{
    NSInteger tag = [(UIButton*)sender tag];
    UILabel *lbl = (UILabel*)[self.view viewWithTag:tag%200];
    NSString *habitKey = lbl.text;
    
    [self.habits removeObjectForKey:habitKey];
    
    [self editHabits];
}

- (void)finishEdit
{
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editHabits)];
    self.navigationItem.leftBarButtonItems = @[editButton];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshHabits) forControlEvents:UIControlEventValueChanged];
    refreshControl.tag = 999;
    [self.view addSubview:refreshControl];
    
    [self refreshHabits];
}

- (void)showHabits: (BOOL)editHabits
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastCompletion" ascending:true];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSArray *allHabits = [[self.habits allValues] sortedArrayUsingDescriptors:sortDescriptors];
    for (Habit *habit in allHabits)
    {
        if (editHabits || [self shouldViewHabit:habit])
        {
            [self displayHabit:habit editHabit:editHabits];
        }
    }
}

- (void)removeAllHabits
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
    
    Habit *h = [self.habits objectForKey:habitKey];
    h.lastCompletion = [NSDate date];
    
    [self refreshHabits];
}

- (BOOL)shouldViewHabit: (Habit *)habit
{
    NSInteger cutoffHour = 0;
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

- (NSDate *)startingDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    return [dateFormatter dateFromString:@"01-jan-1900"];
}

//newHabit: push to the new habit view controller
- (void)newHabit
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

- (void)loadDataFromDisk
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

- (int)daysBetween:(NSDate *)date1 and:(NSDate *)date2
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    [calendar rangeOfUnit:unitFlags startDate:&fromDate interval:nil forDate:date1];
    [calendar rangeOfUnit:unitFlags startDate:&toDate interval:nil forDate:date2];
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:fromDate toDate:toDate options:0];
    
    return [components day];
}

- (void)test
{
    NSLog(@"hi");
    
}

@end
