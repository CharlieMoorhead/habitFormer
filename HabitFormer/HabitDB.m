//
//  HabitDB.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 6/8/15.
//  Copyright (c) 2015 Charlie Moorhead. All rights reserved.
//

#ifdef TEST
#define HABIT_DB_FILENAME @"habits_test.db"
#else
#define HABIT_DB_FILENAME @"habits.db"
#endif

#import "HabitDB.h"
#import <sqlite3.h>

@implementation HabitDB

-(id)init
{
    self = [super init];
    self.dateFormat = @"yyyy-MM-dd HH:mm";
    return self;
}

//-create habit
    // input: name, output: habit
-(Habit *)createHabit: (NSString *)name
{
    Habit *newHabit;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:HABIT_DB_FILENAME];
    
    NSString *insertQuery, *getQuery;
    
    //testing <<<<<<<<<<<<<<<<<<<<<<<<
    
    //testing >>>>>>>>>>>>>>>>>>>>>>>>>
    insertQuery = [NSString stringWithFormat:
                   @"INSERT INTO Habits VALUES(NULL, '%@', '%@', '0');",
                    name,
                    [DateUtils getStringFromDate:[DateUtils startingDate] format:self.dateFormat]];
    getQuery = [NSString stringWithFormat:@"select * from habits where name='%@'", name];
    [self.dbManager executeQuery:insertQuery];
    
    if(self.dbManager.affectedRows != 0)
    {
        NSArray *habitInfo;
        habitInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:getQuery]];
        if(habitInfo.count == 1)
        {
            NSString *name = habitInfo[0][1];
            NSDate *completionDate = [DateUtils getDateFromString:habitInfo[0][2] format:self.dateFormat];
            newHabit = [[Habit alloc] initWithName:name andCompletion:completionDate];
            return newHabit;
        }
        else
        {
            //newHabit is still null
            return newHabit;
        }
    }
    else
    {
        //newHabit is still null
        return newHabit;
    }
}


//-delete habit
    // input: name, output: did it work?
-(BOOL)deleteHabit: (NSString *)name
{
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:HABIT_DB_FILENAME];
    
    NSString *deleteQuery;
    deleteQuery = [NSString stringWithFormat:@"DELETE FROM Habits WHERE UPPER(name)=UPPER('%@')", name];
    [self.dbManager executeQuery:deleteQuery];
    
    if([self.dbManager affectedRows] == 1)
    {
        //it worked!
        return YES;
    }
    else
    {
        //it failed?
        return NO;
    }
}

//-complete habit
    // input name, output: did it work?
-(BOOL)completeHabit:(Habit *)habit andExtendStreak:(BOOL)extend
{
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:HABIT_DB_FILENAME];
    
    [habit completeAndExtendStreak:extend];
    
    
    NSString *updateQuery =
        [NSString stringWithFormat:@"UPDATE Habits SET lastCompletionDate='%@', streak=%ld WHERE name='%@'",
         [DateUtils getStringFromDate:habit.lastCompletion format:self.dateFormat],
         (long)habit.streak,
         habit.name];
    [self.dbManager executeQuery:updateQuery];
    
    if([self.dbManager affectedRows] == 1)
    {
        //it worked!
        return YES;
    }
    else
    {
        //it failed?
        return NO;
    }
}

//-get viewable habit array
    // input: mutable array, output: updated mutable array


//-get all habits
    // input: mutable dict, output: mutable dict of all habits
-(NSMutableDictionary *)getAllHabits: (NSMutableDictionary *)habitDict
{
    NSArray *habits;
    if (habitDict == nil)
    {
        habitDict = [[NSMutableDictionary alloc] init];
    }
    [habitDict removeAllObjects];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:HABIT_DB_FILENAME];
    
    NSString *selectQuery = @"SELECT * FROM Habits ORDER BY lastCompletionDate";
    
    habits = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:selectQuery]];
    
    for(NSArray *a in habits)
    {
        NSString *name = a[1];
        NSDate *completionDate = [DateUtils getDateFromString:a[2] format:self.dateFormat];
        NSInteger streak = [a[3] integerValue];
        [habitDict setObject:[[Habit alloc] initWithName:name andCompletion:completionDate andStreak:streak] forKey:name];
    }
    
    return habitDict;
}


//-get habit from name
    // input: name, output: habit
-(Habit *)getHabitFromName:(NSString *)name
{
    Habit *habit;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:HABIT_DB_FILENAME];
    
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM Habits WHERE UPPER(name)=UPPER('%@')",
                             name];
    
    NSArray *habitArray;
    habitArray = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:selectQuery]];
    
    if(habitArray.count == 1)
    {
        NSString *name = habitArray[0][1];
        NSDate *completionDate = [DateUtils getDateFromString:habitArray[0][2] format:self.dateFormat];
        NSInteger streak = [habitArray[0][3] integerValue];
        habit = [[Habit alloc] initWithName:name andCompletion:completionDate andStreak:streak];
        return habit;
    }
    else
    {
        //didn't find it - habit is null
        return habit;
    }
}

-(void)validateDatabase
{
    NSString *query;
    NSArray *tables;
    NSArray *sqlInfo;
    NSMutableArray *columns;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:HABIT_DB_FILENAME];
    
    //Checking if tables exist
    tables = [[NSArray alloc] initWithObjects:@"Habits", @"Completions", nil];
    
    for (NSString *tableName in tables)
    {
        query = [NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='%@'", tableName];
        if ([[[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]] count] == 1)
        {
            //table exists
            //everything's fine
        }
        else
        {
            //table does not exist
            [self initializeDatabase];
        };
    }
    //Tables exist!
    
    //Checking if 'Habits' table has 'streak' column
    columns = [[NSMutableArray alloc] init];
    
    query = @"pragma table_info(Habits)";
    sqlInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    for (NSArray *row in sqlInfo)
    {
        [columns addObject:row[1]];
    }
    
    if (![columns containsObject:@"streak"])
    {
        //column does not exist
        query = @"ALTER TABLE Habits ADD streak integer DEFAULT 0";
        [self.dbManager executeQuery:query];
    }
    //'streak' exists!
    
    //FOR TESTING
    //[self addTestValues];
}

-(BOOL)initializeDatabase
{
    
    NSString *createHabitsQuery = @"CREATE TABLE Habits(habitID integer, name text NOT NULL, lastCompletionDate text, PRIMARY KEY(habitID))";
    
    NSString *createCompletionsQuery = @"CREATE TABLE Completions(completionID integer, habitID integer NOT NULL, completionDate text NOT NULL, PRIMARY KEY(completionID), FOREIGN KEY(habitID) REFERENCES Habits(habitID))";
    
    NSString *createHabitIndexQuery = @"CREATE UNIQUE INDEX HIndex ON Habits(name)";
    
    NSString *addStreakColumnQuery = @"ALTER TABLE Habits ADD streak integer DEFAULT 0";
    
    [self.dbManager executeQuery:createHabitsQuery];
    [self.dbManager executeQuery:createCompletionsQuery];
    [self.dbManager executeQuery:createHabitIndexQuery];
    [self.dbManager executeQuery:addStreakColumnQuery];
    
    return YES;
}

-(void)addTestValues
{
    //yyyy-MM-dd HH:mm"
    NSString *query0 = @"DELETE FROM Habits WHERE name='test habit'";
    NSString *query1 = @"INSERT INTO Habits VALUES(NULL, 'test habit', '2015-09-13 00:01', 0)";
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:HABIT_DB_FILENAME];
    
    [self.dbManager executeQuery:query0];
    [self.dbManager executeQuery:query1];
    
}

@end
