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
#import "HabitDB.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //NSLog(NSHomeDirectory()); //uncomment to find the iphone simulator data path
    
    //creating table view
    self.tableView = [[UITableView alloc] init];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"ReusableHeaderOrFooter"];
    [self.view addSubview:self.tableView];
    
    //tableView created
    
    //constraints for tableView


    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0f
                                                           constant:0.0f
                              ]];//0
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0.0f
                              ]];//1
    //end constraints for tableView
    
    //load data (refreshTime) from disk
    [self loadDataFromDisk];
    //end load data
    
    //initializing habits arrays
    self.habitDB = [[HabitDB alloc] init];
    [self.habitDB validateDatabase];
    self.habits = [[NSMutableDictionary alloc] init];
    self.habits = [self.habitDB getAllHabits:self.habits];
    self.habitsToView = [[NSMutableArray alloc] init];
    [self refreshHabits];
    //habits array initialized
    
    [self setNavBarToDisplay];

    //initialize view to display if tableview is currently empty
    self.emptyView = [[UIView alloc] init];
    self.emptyView.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel *emptyLabel1 = [[UILabel alloc] init];
    emptyLabel1.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel *emptyLabel2 = [[UILabel alloc] init];
    emptyLabel2.translatesAutoresizingMaskIntoConstraints = NO;
    
    [emptyLabel1 setText:@"You have no habits to complete"];
    [emptyLabel1 setTextAlignment:NSTextAlignmentCenter];
    [emptyLabel1 setFont:[UIFont systemFontOfSize:17]];
    [emptyLabel1 setTextColor:textColor];
    
    [emptyLabel2 setText:@"Tap the upper right to form a new habit"];
    [emptyLabel2 setTextAlignment:NSTextAlignmentCenter];
    [emptyLabel2 setFont:[UIFont systemFontOfSize:15]];
    [emptyLabel2 setTextColor:textColor];
    
    [self.emptyView addSubview:emptyLabel1];
    [self.emptyView addSubview:emptyLabel2];
    
    //constraints for emptyLabel1
    [self.emptyView addConstraint:[NSLayoutConstraint constraintWithItem:emptyLabel1
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.emptyView
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0f
                                                                constant:0.0f
                                   ]];//0
    [self.emptyView addConstraint:[NSLayoutConstraint constraintWithItem:emptyLabel1
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.emptyView
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:0.6f
                                                                constant:0.0f
                                   ]];//1
    //end constraints for emptyLabel1
    
    //constraints for emptyLabel2
    [self.emptyView addConstraint:[NSLayoutConstraint constraintWithItem:emptyLabel2
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.emptyView
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0f
                                                                constant:0.0f
                                   ]];//2
    [self.emptyView addConstraint:[NSLayoutConstraint constraintWithItem:emptyLabel2
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:emptyLabel1
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0f
                                                                constant:50.0f
                                   ]];//3
    //end constraints for emptyLabel2
    
    [self.view addSubview:self.emptyView];
    
    //constraints for emptyView
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.emptyView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0f
                                                           constant:0.0f
                              ]];//2
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.emptyView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0.0f
                              ]];//3
    //end constraints for emptyView
    
    //empty view initialized
}

//one section for each viewable habit
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
    static NSString *headerIdentifier = @"ReusableHeaderOrFooter";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    headerView.backgroundView = [[UIView alloc] init];
    headerView.backgroundView.backgroundColor = [UIColor clearColor];

    return headerView;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

//makes the cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Habit *habit = (Habit *)[self.habits objectForKey:[self.habitsToView objectAtIndex:[indexPath section]]];
    
    NSString *cellIdentifier = [habit name];
    
    HabitCell *cell = (HabitCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[HabitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    [cell setBackgroundColor:labelColor];
    [cell.contentView setBackgroundColor:labelColor];
    [cell.habitLabel setText:[habit name]];
    
    //add 'done' button
    [cell.doneButton addTarget:self action:@selector(completeHabit:) forControlEvents:UIControlEventTouchDown];
    //'done' button
    
    //add 'delete' button
    [cell.deleteButton addTarget:self action:@selector(deleteHabit:) forControlEvents:UIControlEventTouchDown];
    //'delete' button
    
    //add days ago label
    if ([habit.lastCompletion compare:[DateUtils startingDate]] == NSOrderedSame)
    {
        cell.daysAgoLabel.text = @"never done";
    }
    else if ([DateUtils daysBetween:habit.lastCompletion and:[NSDate date]] == 1)
    {
        if ([self shouldExtendStreak:habit])
        {
            cell.daysAgoLabel.text = [NSString stringWithFormat:@"streak: %ld", (long)habit.streak];
        }
        else
        {
            cell.daysAgoLabel.text = @"last done: 1 day ago";
        }
    }
    else
    {
        if ([self shouldExtendStreak:habit])
        {
            cell.daysAgoLabel.text = [NSString stringWithFormat:@"streak: %ld", (long)habit.streak];
        }
        else
        {
            cell.daysAgoLabel.text =
                [NSString stringWithFormat:@"last done: %d days ago",
                (int)[DateUtils daysBetween:habit.lastCompletion and:[NSDate date]]];
        }
    }
    //days ago label added
    
    //add last completion date
    if ([habit.lastCompletion compare:[DateUtils startingDate]] == NSOrderedSame)
    {
        cell.lastCompletionLabel.text = @"never done";
    }
    else
    {
        cell.lastCompletionLabel.text =
            [NSString stringWithFormat:@"last: %@", [DateUtils getStringFromDate:habit.lastCompletion format:@"MM/dd/yy hh:mma"]];
    }
    //last completion date added
    
    return cell;
}

- (void)deleteHabit: (id)sender
{
    UIButton *deleteButton = (UIButton *)sender;
    HabitCell *cell = (HabitCell *)[[deleteButton superview] superview];
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
                                       [self deleteHabitWithName:habitKey atSectionIndex:section];
                                   }];
    
    [deleteConfirmAlert addAction:cancelAction];
    [deleteConfirmAlert addAction:deleteAction];
    
    //following required for iPad
    deleteConfirmAlert.popoverPresentationController.sourceView = cell;
    deleteConfirmAlert.popoverPresentationController.sourceRect = deleteButton.frame;
    //done with iPad code
    
    [self presentViewController:deleteConfirmAlert animated:YES completion:nil];
    //end confirm deleting
}

- (void)deleteHabitWithName:(NSString *)name atSectionIndex:(NSInteger)section
{
    [self.tableView beginUpdates];
    [self.habitDB deleteHabit:name];
    [self.habits removeObjectForKey:name];
    [self.habitsToView removeObjectAtIndex:section];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:section]
                  withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
    [self isTableViewEmpty];
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
    CGFloat widthLimit;
    if(self.view.frame.size.width < self.view.frame.size.height)
    {//the name should be small enough to display when in portrait mode
        widthLimit = self.view.frame.size.width - 100;
    }
    else
    {
        widthLimit = self.view.frame.size.height - 100;
    }
    
    if ([self.habits objectForKey:name] != nil)
    {//habit already exists
        return 1;
    }
    else if (self.habits.count >= 99)
    {//already 99 habits
        return 2;
    }
    
    else if
        ([name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}].width > widthLimit)
    {//habit name would be too long to display
        return 3;
    }
    else
    {//no problems here
        Habit *h;
        h = [self.habitDB createHabit:name];
        [self.habits setObject:h forKey:name];
        [self.habitsToView addObject:h];
        //[self.tableView reloadData];
        [self refreshHabits];
        return 0;
    }
}



- (void)refreshHabits
{
    [self determineViewableHabitsForEditing:self.tableView.editing];
    [self.tableView reloadData];
    //[self isTableViewEmpty];
    
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
    [self.habitDB completeHabit:h andExtendStreak:[self shouldExtendStreak:h]];
    [self displayMessageBar:[NSString stringWithFormat:@"days in a row for '%@': %ld", h.name, (long)h.streak]];
    
    [self.tableView beginUpdates];
    [self.habitsToView removeObjectAtIndex:section];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
    
    [self isTableViewEmpty];
}

- (BOOL)shouldViewHabit: (Habit *)habit
{
    NSDate *cutoffDate;
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSUInteger preservedComponents = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    cutoffDate = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:[NSDate date]]];
    
    NSDateComponents *currentTime = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
    NSDateComponents *cutoffTime = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self.resetTime];
    
    
    //if it is currently earlier in the day than the cutoff time, remove a day from the cutoff date
    //* for some reason this is really trippy for me to think about
    //* I may not be very smart
    //* Example:    current time: 4am on 13-Feb-15
    //*             cutoff time:  8am
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

- (BOOL)shouldExtendStreak: (Habit *)habit
{
    NSDate *cutoffDate;
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSUInteger preservedComponents = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    cutoffDate = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:[NSDate date]]];
    
    NSDateComponents *currentTime = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
    NSDateComponents *cutoffTime = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self.resetTime];
    
    
    //if it is currently earlier in the day than the cutoff time, remove a day from the cutoff date
    //* for some reason this is really trippy for me to think about
    //* I may not be very smart
    //* Example:    current time: 4am on 13-Feb-15
    //*             cutoff time:  8am
    //*             since the current time is before the cutoff time,
    //*             we want to compare with the previous date's 8am,
    //*             so one day is subtracted, and the cutoff datetime should be: 8am on 12-Feb-15
    //* Pefectly explained
    if (currentTime.hour + (1.0f/60)*currentTime.minute < cutoffTime.hour + (1.0f/60)*cutoffTime.minute)
    {
        currentTime.day = -2;
    }
    else
    {
        currentTime.day = -1;
    }
    currentTime.hour = cutoffTime.hour;
    currentTime.minute = cutoffTime.minute;
    
    cutoffDate = [calendar dateByAddingComponents:currentTime toDate:cutoffDate options:0];
    return [cutoffDate compare:habit.lastCompletion] == NSOrderedAscending;
}

- (void)determineViewableHabitsForEditing:(BOOL) editMode
{
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
        
        if ([data objectForKey:@"resetTime"] != nil)
        {
            self.resetTime = [data objectForKey:@"resetTime"];
        }
        else
        {
            self.resetTime = [DateUtils getDateFromString:@"12:00 am" format:@"hh:mm a"];
        }
    }
    else
    {
        self.resetTime = [DateUtils getDateFromString:@"12:00 am" format:@"hh:mm a"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//sets up the nav bar
- (void)setNavBarToDisplay
{
    self.navigationController.navigationBar.translucent = NO;
    
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
                                       style:UIBarButtonItemStylePlain
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
        [self isTableViewEmpty];
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
        [CATransaction begin];
        [CATransaction setCompletionBlock: ^{
            [self isTableViewEmpty];
        }];
        
        [self.tableView setEditing:editing animated:animated];
        [super setEditing:editing animated:animated];

        
        [CATransaction commit];
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

-(void)isTableViewEmpty
{
    if(self.habitsToView.count == 0)
    {
        
        [self.emptyView setHidden:NO];
        [UIView animateWithDuration:0.1 animations:^{
            [self.emptyView setAlpha:1.0f];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.1 animations:^{
            [self.emptyView setAlpha:0.0f];
        }completion:^(BOOL done){
            if (done)
            {
                [self.emptyView setHidden:YES];
            }
        }];
    }
}

-(void)displayMessageBar: (NSString *)message
{
    UILabel *messageBar = [[UILabel alloc] init];
    messageBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [messageBar setText:message];
    [messageBar setAlpha:0.90f];
    [messageBar setTextColor:[UIColor whiteColor]];
    [messageBar setTextAlignment:NSTextAlignmentCenter];
    [messageBar setBackgroundColor:textColor];
    [messageBar setUserInteractionEnabled:YES];
    [self.view addSubview:messageBar];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:messageBar
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0.0f
                              ]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:messageBar
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0f
                                                           constant:25.0f
                              ]];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:messageBar
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f
                                                                      constant:-25.0f
                                         ];
    [self.view addConstraint:topConstraint];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:messageBar
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:0.0f
                              ]];

    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        [topConstraint setConstant:0.0f];
        [self.view layoutIfNeeded];
    }completion:^(BOOL done){
       //done
    }];
    NSArray *parameters = @[messageBar, topConstraint];
    
    [self performSelector:@selector(dismissMessageBar:) withObject:parameters afterDelay:4.0];
}

-(void)dismissMessageBar: (NSArray *)parameters
{
    UILabel *messageBar = (UILabel *)[parameters objectAtIndex:0];
    NSLayoutConstraint *topConstraint = (NSLayoutConstraint *)[parameters objectAtIndex:1];
    
    [UIView animateWithDuration:0.5 animations:^{
        [topConstraint setConstant:-25.0f];
        [self.view layoutIfNeeded];
    }completion:^(BOOL done){
        [messageBar removeFromSuperview];
    }];
}

@end
