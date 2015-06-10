//
//  HabitDB.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 6/8/15.
//  Copyright (c) 2015 Charlie Moorhead. All rights reserved.
//

#import "HabitDB.h"
#import "utils.h"

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
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"habits.db"];
    
    NSString *insertQuery, *getQuery;
    insertQuery = [NSString stringWithFormat:
                   @"INSERT INTO Habits VALUES(NULL, '%@', '%@');",
                    name,
                    [utils getStringFromDate:[utils startingDate] format:self.dateFormat]];
    getQuery = [NSString stringWithFormat:@"select * from habits where name='%@'", name];
    [self.dbManager executeQuery:insertQuery];
    
    if(self.dbManager.affectedRows != 0)
    {
        NSArray *habitInfo;
        habitInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:getQuery]];
        if(habitInfo.count == 1)
        {
            NSString *name = habitInfo[0][1];
            NSDate *completionDate = [utils getDateFromString:habitInfo[0][2] format:self.dateFormat];
            newHabit = [[Habit alloc] initWithName:name andCompletion:completionDate];
            //newHabit = [[Habit alloc] init];
            //newHabit.name = habitInfo[0][1];
            //newHabit.lastCompletion = [utils getDateFromString:habitInfo[0][2] format:@"ddMMMyyyy HH:mm"];
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
-(BOOL)deleteHabit: (Habit *)habit
{
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"habits.db"];
    
    NSString *deleteQuery;
    deleteQuery = [NSString stringWithFormat:@"DELETE FROM Habits WHERE UPPER(name)=UPPER('%@')", habit.name];
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
-(BOOL)completeHabit: (Habit *)habit
{
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"habits.db"];
    
    [habit complete];
    
    NSString *updateQuery =
        [NSString stringWithFormat:@"UPDATE Habits SET lastCompletionDate='%@' WHERE name='%@'",
         [utils getStringFromDate:habit.lastCompletion format:self.dateFormat],
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
    // input: mutable array, output: mutable array of all habits, sorted by last completion date, ascending
-(void)getAllHabits: (NSMutableDictionary *)habitDict
{
    NSArray *habits;
    [habitDict removeAllObjects];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"habits.db"];
    
    NSString *selectQuery = @"SELECT * FROM Habits ORDER BY lastCompletionDate";
    
    habits = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:selectQuery]];
    
    for(NSArray *a in habits)
    {
        NSString *name = a[1];
        NSDate *completionDate = [utils getDateFromString:a[2] format:self.dateFormat];
        [habitDict setObject:[[Habit alloc] initWithName:name andCompletion:completionDate] forKey:name];
    }
}


//-get habit from name
    // input: name, output: habit
-(Habit *)getHabitFromName:(NSString *)name
{
    Habit *habit;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"habits.db"];
    
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM Habits WHERE UPPER(name)=UPPER('%@')",
                             name];
    
    NSArray *habitArray;
    habitArray = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:selectQuery]];
    
    if(habitArray.count == 1)
    {
        NSString *name = habitArray[0][1];
        NSDate *completionDate = [utils getDateFromString:habitArray[0][2] format:self.dateFormat];
        habit = [[Habit alloc] initWithName:name andCompletion:completionDate];
        //habit = [[Habit alloc] init];
        //habit.name = habitArray[0][1];
        //habit.lastCompletion = [utils getDateFromString:habitArray[0][2] format:@"ddMMMyyyy hh:mm"];
        return habit;
    }
    else
    {
        //didn't find it - habit is null
        return habit;
    }
}

@end
