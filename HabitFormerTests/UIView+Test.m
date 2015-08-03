//
//  UIView+Test.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 8/3/15.
//  Copyright (c) 2015 Charlie Moorhead. All rights reserved.
//

#import "UIView+Test.h"

@implementation UIView (Test)


//forces an animation to complete immediately, so no waiting during testing!
+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
    if (animations) {
        animations();
    }
    if (completion) {
        completion(YES);
    }
}

@end
