//
//  NewHabitViewController.h
//  HabitFormer
//
//  Created by Charlie Moorhead on 6/5/14.
//  Copyright (c) 2014 Charlie Moorhead. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NewHabitViewController;
@protocol NewHabitViewControllerDelegate <NSObject>

- (NSInteger)addNewHabit:(NewHabitViewController *)controller newHabitName:(NSString *)name;

@end

@interface NewHabitViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic,strong) UITextField *name;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIButton *create;

@property (nonatomic,weak) id <NewHabitViewControllerDelegate> delegate;

@end
