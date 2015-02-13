//
//  HabitCell.h
//  HabitFormer
//
//  Created by Charlie Moorhead on 2/1/15.
//  Copyright (c) 2015 Charlie Moorhead. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HabitCell : UITableViewCell

@property (nonatomic, strong) UILabel *habitLabel;
@property (nonatomic, strong) UILabel *daysAgoLabel;
@property (nonatomic, strong) UILabel *lastCompletionLabel;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *deleteButton;

@end
