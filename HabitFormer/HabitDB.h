//
//  HabitDB.h
//  HabitFormer
//
//  Created by Charlie Moorhead on 6/8/15.
//  Copyright (c) 2015 Charlie Moorhead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"
#import "Habit.h"

@interface HabitDB : NSObject

-(Habit *)createHabit: (NSString *)name;
-(BOOL)deleteHabit: (NSString *)name;
-(BOOL)completeHabit: (Habit *)habit;
-(Habit *)getHabitFromName: (NSString *)name;
-(NSMutableDictionary *)getAllHabits: (NSMutableDictionary *)habitDict;
-(void)validateDatabase;

@property (strong, nonatomic) DBManager *dbManager;
@property (strong, nonatomic) NSString *dateFormat;

@end
