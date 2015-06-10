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
-(void)complete;

@property NSString *name;
@property NSDate *lastCompletion;

@end