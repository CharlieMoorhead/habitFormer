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
    
    //creating table view
    self.tableView = [[UITableView alloc] initWithFrame:[self.view frame] style:UITableViewStylePlain];
    self.tableView.backgroundColor = [utils backgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    //table view created
    
    //initializing habits arrays
    self.habits = [[NSMutableDictionary alloc] init];
    self.habitsToView = [[NSMutableArray alloc] init];
    [self loadDataFromDisk];
    [self refreshHabits];
    //habits array initialized
    
    [self setNavBarToDisplay];
}

//one section for each habit
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

//next two methods make it so the '-' delete button doesn't slide in while entering edit mode
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
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
    
    Habit *habit = (Habit *)[self.habits objectForKey:[self.habitsToView objectAtIndex:[indexPath section]]];
    
    cell.habitLabel.text = [habit name];
    
    //add 'done' button
    [cell.doneButton addTarget:self action:@selector(completeHabit:) forControlEvents:UIControlEventTouchDown];
    //'done' button
    
    //add 'delete' button
    [cell.deleteButton addTarget:self action:@selector(deleteHabit:) forControlEvents:UIControlEventTouchDown];
    //'delete' button
    
    //add days ago label
    if ([habit.lastCompletion compare:[self startingDate]] == NSOrderedSame)
    {
        cell.daysAgoLabel.text = @"never done";
    }
    else if ([utils daysBetween:habit.lastCompletion and:[NSDate date]] == 1)
    {
        cell.daysAgoLabel.text = @"last done: 1 day ago";
    }
    else
    {
        cell.daysAgoLabel.text =
        [NSString stringWithFormat:@"last done: %d days ago",
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

- (void)deleteHabit: (id)sender
{
    HabitCell *cell = (HabitCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger section = indexPath.section;
    NSString *habitKey = cell.habitLabel.text;
    
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
                                       //don't do it!!!
                                   }];
    UIAlertAction *deleteAction = [UIAlertAction
                                   actionWithTitle:@"Yes"
                                   style:UIAlertActionStyleDestructive
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self.tableView beginUpdates];
                                       [self.habits removeObjectForKey:habitKey];
                                       [self.habitsToView removeObjectAtIndex:section];
                                       [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:section]
                                                     withRowAnimation:UITableViewRowAnimationLeft];
                                       [self.tableView endUpdates];
                                   }];
    
    [deleteConfirmAlert addAction:cancelAction];
    [deleteConfirmAlert addAction:deleteAction];
    
    [self presentViewController:deleteConfirmAlert animated:YES completion:nil];
    //end confirm deleting
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



- (void)refreshHabits
{
    [self determineViewableHabitsForEditing:self.tableView.editing];
    [self.tableView reloadData];
    
    UIRefreshControl *refreshControl = (UIRefreshControl *)[self.view viewWithTag:999];
    [refreshControl endRefreshing];
}

- (void)completeHabit: (id)sender
{
    HabitCell *cell = (HabitCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger section = indexPath.section;
    NSString *habitKey = cell.habitLabel.text;
    Habit *h = [self.habits objectForKey:habitKey];
    h.lastCompletion = [NSDate date];
    
    [self.tableView beginUpdates];
    [self.habitsToView removeObjectAtIndex:section];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
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

- (void)determineViewableHabitsForEditing:(BOOL) editMode
{
    /*[self.habitsToView removeAllObjects];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastCompletion" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *allHabits = [[self.habits allValues] sortedArrayUsingDescriptors:sortDescriptors];
    
    for (Habit *habit in allHabits)
    {
        if ([self shouldViewHabit:habit] || editMode)
        {
            [self.habitsToView addObject:habit];
        }
    }*/
    
    NSArray *sortedHabitKeys = [[self.habits allKeys] sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
                         {
                             NSDate *dateA = ((Habit *)[self.habits valueForKey:a]).lastCompletion;
                             NSDate *dateB = ((Habit *)[self.habits valueForKey:b]).lastCompletion;
                             
                             return [dateA compare:dateB];
                         }];
    [self.habitsToView removeAllObjects];
    for (NSString *key in sortedHabitKeys)
    {
        if ([self shouldViewHabit:(Habit *)[self.habits objectForKey:key]] || editMode)
        {
            [self.habitsToView addObject:key];
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
    if (editing)
    {
        [self.tableView setEditing:editing animated:animated];
        [super setEditing:editing animated:animated];
        
        [self determineViewableHabitsForEditing:YES];
        if (self.habitsToView.count > self.tableView.numberOfSections)
        {//this makes sure ALL habits are viewable while editing
            [self.tableView beginUpdates];
            NSRange r = NSMakeRange(self.tableView.numberOfSections, self.habitsToView.count - self.tableView.numberOfSections);
            [self.tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:r] withRowAnimation:UITableViewRowAnimationLeft];
            [self.tableView endUpdates];
        }
    }
    else
    {
        if(!animated)
        {//this stops the animated transition to !editing mode
            [self.tableView reloadData];
        }
        else
        {
            [self determineViewableHabitsForEditing:NO];
            if (self.habitsToView.count < self.tableView.numberOfSections)
            {//this hides habits that have been completed in the last day
                [self.tableView beginUpdates];
                NSRange r = NSMakeRange(self.habitsToView.count, self.tableView.numberOfSections - self.habitsToView.count);
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndexesInRange:r] withRowAnimation:UITableViewRowAnimationLeft];
                [self.tableView endUpdates];
            }
        }
        
        [self.tableView setEditing:editing animated:animated];
        [super setEditing:editing animated:animated];
    }
}

// this goes off when another view pops back to the main view controller
// ** used to refresh the habits after coming back from another view  **
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self == viewController)
    {
        [self setEditing:NO animated:NO];
        [self refreshHabits];
    }
}

@end
