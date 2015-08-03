//
//  UIView+Test.h
//  HabitFormer
//
//  Created by Charlie Moorhead on 8/3/15.
//  Copyright (c) 2015 Charlie Moorhead. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (Test)

+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

@end
