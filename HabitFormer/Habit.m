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
    self.lastCompletion = [NSDate date];
    return self;
}

-(id)initWithName:(NSString *)newName andCompletion:(NSDate *)newCompletion
{
    self = [super init];
    self.name = newName;
    self.lastCompletion = newCompletion;
    return self;
}

-(void)complete
{
    self.lastCompletion = [NSDate date];
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.lastCompletion forKey:@"lastCompletion"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.name = (NSString *)[aDecoder decodeObjectForKey:@"name"];
    self.lastCompletion = (NSDate *)[aDecoder decodeObjectForKey:@"lastCompletion"];
    return self;
}

@end