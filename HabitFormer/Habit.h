//
//  Habit.h
//  HabitFormer
//
//  Created by Charlie Moorhead on 3/8/14.
//  Copyright (c) 2014 Charlie Moorhead. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Habit : NSObject

-(id)initWithName: (NSString *)newName;
-(id)initWithName: (NSString *)newName andCompletion:(NSDate *)newCompletion;
-(id)initWithName: (NSString *)newName andCompletion:(NSDate *)newCompletion andStreak:(NSInteger)streak;
-(void)completeAndExtendStreak: (BOOL)extend;

@property NSString *name;
@property NSInteger streak;
@property NSDate *lastCompletion;

@end