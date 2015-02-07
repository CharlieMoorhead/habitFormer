//
//  MainViewController.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 3/8/14.
//  Copyright (c) 2014 Charlie Moorhead. All rights reserved.
//

#import "MainViewController.h"
#import "SettingsViewController.h"
#import "Habit.h"
#import "HabitCell.h"
#import "utils.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //NSLog(NSHomeDirectory()); //uncomment to find where to delete the iphone simulator data
    
    /*
    //creatng a scroll view
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [utils fullWidth], [self fullHeight])];
    //1 is added to scrollview.contentsize height so that you can always scroll a little bit,
    //so you can always activate the refresh control
    self.scrollView.contentSize = CGSizeMake([utils fullWidth],[self fullHeight]+1);
    self.scrollView.backgroundColor = [UIColor colorWithRed:255/255.0f green:247/255.0f blue:145/255.0f alpha:1.0f];
    self.view = self.scrollView;
    //scroll view created
     */
    
    //creating table view
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [utils fullWidth], [utils fullHeight]) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [utils backgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //self.view = self.tableView;//
    [self.view addSubview:self.tableView];
    //table view created
    
    //initializing habits arrays
    self.habits = [[NSMutableDictionary alloc] init];
    self.habitsToView = [[NSMutableArray alloc] init];
    [self loadDataFromDisk];
    [self refreshHabits];
    //habits array initialized
    
    //init habitSubviews array and displaying habits
    //self.habitSubviews = [[NSMutableArray alloc] init];
    //[self refreshHabits]; //it now refreshes because of the uinavigation controller delegate method
    //habitSubviews array initialized and habits displayed
    
    [self setNavBarToDisplay];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return self.habitsToView.count;
}

//each 'section' is a single cell so that there is whitespace between each cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//defines the height of the buffer between habit cells
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

//this is the buffer between habit cells
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

//every habit should be deletable
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//makes the cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    HabitCell *cell = (HabitCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[HabitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell setBackgroundColor:[utils labelColor]];
    [cell.contentView setBackgroundColor:[utils labelColor]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    
    Habit *habit = (Habit *)[self.habitsToView objectAtIndex:[indexPath section]];
    
    cell.habitLabel.text = [habit name];
    
    //add 'done' button
    cell.doneButton.tag = [indexPath section];
    [cell.doneButton addTarget:self action:@selector(completeHabit:) forControlEvents:UIControlEventTouchDown];
    //'done' button
    
    //add days ago label
    if ([habit.lastCompletion compare:[self startingDate]] == NSOrderedSame)
    {
        cell.daysAgoLabel.text = @"Never done";
    }
    else if ([utils daysBetween:habit.lastCompletion and:[NSDate date]] == 1)
    {
        cell.daysAgoLabel.text = @"Last done: 1 day ago";
    }
    else
    {
        cell.daysAgoLabel.text =
        [NSString stringWithFormat:@"Last done: %d days ago",
         (int)[utils daysBetween:habit.lastCompletion and:[NSDate date]]];
    }
    //days ago label added
    
    //add last completion date
    if ([habit.lastCompletion compare:[self startingDate]] == NSOrderedSame)
    {
        cell.lastCompletionLabel.text = @"never done";
    }
    else
    {
        cell.lastCompletionLabel.text =
            [NSString stringWithFormat:@"last: %@", [utils getStringFromDate:habit.lastCompletion format:@"MM/dd/yy hh:mma"]];
    }
    //last completion date added
    
    return cell;
}

//deletes the cells
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [tableView beginUpdates];
        Habit *habit = (Habit *)[self.habitsToView objectAtIndex:[indexPath section]];
        [self.habits removeObjectForKey:habit.name];
        [self determineViewableHabits:YES];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:[indexPath section]] withRowAnimation:UITableViewRowAnimationBottom];
        [tableView endUpdates];
    }
    else
    {
        //shouldn't be able to get here
    }
}

//addNewHabit: called when returning from the new habit view
- (NSInteger)addNewHabit:(NewHabitViewController *)controller newHabitName:(NSString *)name
{
    return [self createHabit:name];
}


//createHabit:  returns 0 on if succesfully adds habit
//              returns 1 if name is already used
//              returns 2 if there's 99 habits already
//              returns 3 if the name would be too long to display
- (NSInteger)createHabit:(NSString *)name
{
    if ([self.habits objectForKey:name] != nil)
    {//habit already exists
        return 1;
    }
    else if (self.habits.count >= 99)
    {//already 99 habits
        return 2;
    }
    else if
        ([name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}].width > [utils fullWidth] - 100)
    {//habit name would be too long to display
        return 3;
    }
    else
    {//no problems here
        Habit *h = [[Habit alloc] init];
        h.name = name;
        h.lastCompletion = [self startingDate];
        [self.habits setObject:h forKey:h.name];
        [self.tableView reloadData];
        return 0;
    }
}

- (void)displayHabit:(Habit *)habit editHabit:(BOOL) editHabit
{
    NSInteger labelHeight = 45;
    NSInteger labelBuffer = 10; //space between the top habit label and the nav bar
    NSInteger labelDelta = 10; //space between each habit label
    
    UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, self.habitSubviews.count*(labelHeight + labelBuffer) + labelDelta, [utils fullWidth], labelHeight + labelBuffer)];
    UILabel *habitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [utils fullWidth], labelHeight)];
    habitLabel.text = habit.name;

    habitLabel.textAlignment = NSTextAlignmentCenter;
    habitLabel.backgroundColor = [UIColor lightGrayColor];
    habitLabel.textAlignment = NSTextAlignmentCenter;
    
    /*
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, habitLabel.frame.size.height-1, habitLabel.frame.size.width, 1);
    bottomBorder.backgroundColor = [UIColor darkGrayColor].CGColor;
    [habitLabel.layer addSublayer:bottomBorder];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0, 0, habitLabel.frame.size.width, 1);
    topBorder.backgroundColor = [UIColor darkGrayColor].CGColor;
    [habitLabel.layer addSublayer:topBorder];
     */
    
    habitLabel.tag = self.habitSubviews.count+1;
    
    [labelView addSubview:habitLabel];
    
    if (editHabit)
    {
        //add 'delete' button
        UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
        [delete setTitle:@"delete" forState:UIControlStateNormal];
        [delete setBackgroundColor:[UIColor colorWithRed:147/255.0f green:18/255.0f blue:0/255.0f alpha:1.0f]];
        delete.frame = CGRectMake(0, 0, 50, labelHeight);// - 2.0f);
        delete.center = CGPointMake(25, labelHeight / 2.0f);
        [delete.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [delete.titleLabel setTextColor:[UIColor colorWithRed:223/255.0f green:27/255.0f blue:0/255.0f alpha:1.0f]];
        delete.tag = habitLabel.tag + 200;
        [delete addTarget:self action:@selector(deleteHabit:) forControlEvents:UIControlEventTouchDown];
        [labelView addSubview:delete];
        [labelView bringSubviewToFront:delete];
        //delete button
        
        //add last completion date
        UILabel *lastCompletionLabel = [[UILabel alloc] init];
        
        if ([habit.lastCompletion compare:[self startingDate]] == NSOrderedSame)
        {
            lastCompletionLabel.text = @"never done";
        }
        else
        {
            lastCompletionLabel.text = [NSString stringWithFormat:@"last: %@", [utils getStringFromDate:habit.lastCompletion format:@"MM/dd/yy hh:mma"]];
        }
        
        [lastCompletionLabel setFont:[UIFont systemFontOfSize:10]];
        [lastCompletionLabel sizeToFit];
        lastCompletionLabel.frame = CGRectMake([utils fullWidth]-15-lastCompletionLabel.frame.size.width, lastCompletionLabel.frame.origin.y, lastCompletionLabel.frame.size.width, lastCompletionLabel.frame.size.height);
        [labelView addSubview:lastCompletionLabel];
        //last completion date added
        
    }
    else
    {
        //add 'done' button
        UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
        [done setTitle:@"done" forState:UIControlStateNormal];
        [done setBackgroundColor:[UIColor colorWithRed:0/255.0f green:150/255.0f blue:43/255.0f alpha:1.0f]];
        done.frame = CGRectMake(0, 0, 50, labelHeight);// - 2.0f);
        done.center = CGPointMake([utils fullWidth] - 25, labelHeight / 2.0f);
        [done.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [done.titleLabel setTextColor:[UIColor colorWithRed:30/255.0f green:198/255.0f blue:20/255.0f alpha:1.0f]];
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
        else if ([utils daysBetween:habit.lastCompletion and:[NSDate date]] == 1)
        {
            lastCompletionLabel.text = @"Last done: 1 day ago";
        }
        else
        {
            lastCompletionLabel.text =
                [NSString stringWithFormat:@"Last done: %d days ago",
                (int)[utils daysBetween:habit.lastCompletion and:[NSDate date]]];
        }
    
        [lastCompletionLabel setFont:[UIFont systemFontOfSize:10]];
        [lastCompletionLabel sizeToFit];
        [labelView addSubview:lastCompletionLabel];
        //last completion date added
    }
    
    
    [self.habitSubviews addObject:labelView];
    if (self.habitSubviews.count*(labelHeight + labelBuffer) + labelDelta > [self fullHeight])
    {
        [self.scrollView setContentSize:CGSizeMake([utils fullWidth],
                                                   self.habitSubviews.count*(labelHeight + labelBuffer) + labelDelta)];
    }
    else
    {
        [self.scrollView setContentSize:CGSizeMake([utils fullWidth], [self fullHeight] + 1)];
    }
    [self.view addSubview:labelView];
    
}

- (void)refreshHabits
{
    //[self removeAllHabits];
    
    //[self showHabits:NO];
    
    [self determineViewableHabits:self.tableView.editing];
    [self.tableView reloadData];
    
    UIRefreshControl *refreshControl = (UIRefreshControl *)[self.view viewWithTag:999];
    [refreshControl endRefreshing];
}

- (void)refreshAfterExitingEditMode
{
    [self determineViewableHabits:NO];
    [self.tableView reloadData];
    
    UIRefreshControl *refreshControl = (UIRefreshControl *)[self.view viewWithTag:999];
    [refreshControl endRefreshing];
}

- (void)editHabits
{
    [self removeAllHabits];
    [self showHabits:YES];
    
    UIBarButtonItem *doneButton= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishEdit)];
    self.navigationItem.leftBarButtonItems = @[doneButton];
    
    self.navigationItem.rightBarButtonItems = @[];
    
    [[self.view viewWithTag:999] removeFromSuperview];
}

- (void)deleteHabit: (id)sender
{
    NSInteger tag = [(UIButton*)sender tag];
    UILabel *lbl = (UILabel*)[self.view viewWithTag:tag%200];
    NSString *habitKey = lbl.text;
    
    //confirm deleting
    UIAlertController *deleteConfirmAlert = [UIAlertController
                                             alertControllerWithTitle:[NSString stringWithFormat:@"Delete \"%@\"", habitKey]
                                             message:@"Are you sure?"
                                             preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       //nop!
                                   }];
    UIAlertAction *deleteAction = [UIAlertAction
                                   actionWithTitle:@"Yes"
                                   style:UIAlertActionStyleDestructive
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self.habits removeObjectForKey:habitKey];
                                       [self editHabits];
                                   }];
    
    [deleteConfirmAlert addAction:cancelAction];
    [deleteConfirmAlert addAction:deleteAction];
    
    [self presentViewController:deleteConfirmAlert animated:YES completion:nil];
    //end confirm deleting
    
}

- (void)finishEdit
{
    [self setNavBarToDisplay];
    [self refreshHabits];
}

- (void)showHabits: (BOOL)editHabits
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastCompletion" ascending:YES];
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
    //UILabel *lbl = (UILabel*)[self.view viewWithTag:tag%100];
    //NSString *habitKey = lbl.text;
    HabitCell *cell = (HabitCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:tag]];
    NSString *habitKey = cell.habitLabel.text;
    Habit *h = [self.habits objectForKey:habitKey];
    h.lastCompletion = [NSDate date];
    [self refreshHabits];
}

- (BOOL)shouldViewHabit: (Habit *)habit
{
    NSDate *cutoffDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
    cutoffDate = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:[NSDate date]]];
    
    NSDateComponents *currentTime = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date]];
    NSDateComponents *cutoffTime = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:self.resetTime];
    
    
    //if it is currently earlier in the day than the cutoff time, remove a day from the cutoff date
    //* for some reason this is really trippy for me to think about
    //* I may not be very smart
    //* Example:    current time - 4am on 13-Feb-15
    //*             cutoff time  - 8am
    //*             since the current time is before the cutoff time,
    //*             we want to compare with the previous date's 8am,
    //*             so one day is subtracted, and the cutoff datetime should be: 8am on 12-Feb-15
    //* Pefectly explained
    if (currentTime.hour + (1.0f/60)*currentTime.minute < cutoffTime.hour + (1.0f/60)*cutoffTime.minute)
    {
        currentTime.day = -1;
    }
    else
    {
        currentTime.day = 0;
    }
    currentTime.hour = cutoffTime.hour;
    currentTime.minute = cutoffTime.minute;
    
    cutoffDate = [calendar dateByAddingComponents:currentTime toDate:cutoffDate options:0];
    return [cutoffDate compare:habit.lastCompletion] == NSOrderedDescending;
    
}

- (void)determineViewableHabits:(BOOL) editMode
{
    [self.habitsToView removeAllObjects];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastCompletion" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *allHabits = [[self.habits allValues] sortedArrayUsingDescriptors:sortDescriptors];
    
    for (Habit *habit in allHabits)
    {
        if ([self shouldViewHabit:habit] || editMode)
        {
            [self.habitsToView addObject:habit];
        }
    }
}

//a date from eons ago to be used as a stand-in for 'never been done'
- (NSDate *)startingDate
{
    return [utils getDateFromString:@"01-jan-1900" format:@"dd-MMM-yyyy"];
}

//newHabit: push to the new habit view controller
- (void)pushToNewHabitView
{
    NewHabitViewController *newHabitView = [[NewHabitViewController alloc] init];
    newHabitView.delegate = self;
    [self.navigationController pushViewController:newHabitView animated:YES];
}

//settingsVew: push to the settings view controller
- (void)pushToSettingsView
{
    SettingsViewController *settingsView = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:settingsView animated:YES];
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
        NSMutableDictionary *data = (NSMutableDictionary *)[NSKeyedUnarchiver unarchiveObjectWithFile:file];
        
        if ([data objectForKey:@"habits"] != nil)
        {
            self.habits = [data objectForKey:@"habits"];
        }
        else
        {
            self.habits = [[NSMutableDictionary alloc] init];
        }
        
        if ([data objectForKey:@"resetTime"] != nil)
        {
            self.resetTime = [data objectForKey:@"resetTime"];
        }
        else
        {
            self.resetTime = [utils getDateFromString:@"12:00 am" format:@"hh:mm a"];
        }
    }
    else
    {
        self.habits = [[NSMutableDictionary alloc] init];
        
        self.resetTime = [utils getDateFromString:@"12:00 am" format:@"hh:mm a"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//returns the full height of the frame below the nav bar
- (CGFloat)fullHeight
{
    return [utils fullHeight] - self.navigationController.navigationBar.frame.size.height;
    
}

//sets up the nav bar
- (void)setNavBarToDisplay
{
    //new button on nav bar
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(pushToNewHabitView)];
    self.navigationItem.rightBarButtonItems = @[newButton];
    //end nav new button
    
    //add edit button on nav bar
    //UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
    //                               initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
    //                               target:self
    //                               action:@selector(editHabits)];
    //self.navigationItem.leftBarButtonItems = @[editButton];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //end nav edit button
    
    //add settings button on nav bar
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"\u2699"
                                       style:UIBarButtonItemStyleBordered
                                       target:self
                                       action:@selector(pushToSettingsView)];
    [settingsButton setTitleTextAttributes:@{
                                             NSFontAttributeName: [UIFont systemFontOfSize:22]
                                             }forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItems = @[newButton, settingsButton];
    //end settings button
    
    
    //adding refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                       action:@selector(refreshHabits)
             forControlEvents:UIControlEventValueChanged];
    refreshControl.tag = 999;
    [self.tableView addSubview:refreshControl];
    //refresh added
    
}

//tells the tableview to switch to editing mode
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    //if exiting edit mode, remove the rows that shouldn't be viewed
    // before the animation starts
    if (!editing)
    {
        [CATransaction begin];
        [self refreshAfterExitingEditMode];
        [CATransaction commit];
    }
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [self refreshHabits];
    }];
    [self.tableView setEditing:editing animated:animated];
    [super setEditing:editing animated:animated];
    [CATransaction commit];
}


// this goes off when another view pops back to the main view controller
// ** used to refresh the habits after coming back from another view  **
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self == viewController)
    {
        [self refreshHabits];
    }
}

@end
