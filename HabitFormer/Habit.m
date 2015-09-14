//
//  Habit.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 3/8/14.
//  Copyright (c) 2014 Charlie Moorhead. All rights reserved.
//

#import "Habit.h"

@implementation Habit

@synthesize name, lastCompletion;

-(id)initWithName:(NSString *)newName
{
    self = [super init];
    self.name = newName;
    self.lastCompletion = [DateUtils startingDate];
    self.streak = 0;
    return self;
}

-(id)initWithName:(NSString *)newName andCompletion:(NSDate *)newCompletion
{
    self = [super init];
    self.name = newName;
    self.lastCompletion = newCompletion;
    self.streak = 0;
    return self;
}

-(id)initWithName:(NSString *)newName andCompletion:(NSDate *)newCompletion andStreak:(NSInteger)streak
{
    self = [super init];
    self.name = newName;
    self.lastCompletion = newCompletion;
    self.streak = streak;
    return self;
}

-(void)completeAndExtendStreak:(BOOL)extend
{
    NSDate *newCompletion;
    //I got some errors when directly using [NSDate date] as the new self.lastCompletion
    newCompletion =
        [DateUtils getDateFromString:[DateUtils getStringFromDate:[NSDate date]
                                                           format:@"yyyy-MM-dd HH:mm"]
                              format:@"yyyy-MM-dd HH:mm"];
    
    self.lastCompletion = newCompletion;
    
    if (extend)
    {
        self.streak = self.streak + 1;
    }
    else
    {
        self.streak = 1;
    }
}

@end