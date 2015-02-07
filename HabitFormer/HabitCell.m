//
//  HabitCell.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 2/1/15.
//  Copyright (c) 2015 Charlie Moorhead. All rights reserved.
//

#import "HabitCell.h"
#import "utils.h"

@implementation HabitCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //add habit label
        self.habitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [utils fullWidth], 44)];
        [self.habitLabel setFont:[UIFont systemFontOfSize:17]];
        [self.habitLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:self.habitLabel];
        //habit label added
        
        //add days ago completed
        self.daysAgoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, 12)];
        [self.daysAgoLabel setFont:[UIFont systemFontOfSize:10]];
        [self.daysAgoLabel setTextColor:[utils subtitleColor]];
        [self.contentView addSubview:self.daysAgoLabel];
        //days ago completed added
        
        //add last completion date
        self.lastCompletionLabel = [[UILabel alloc] initWithFrame:CGRectMake([utils fullWidth]-120-15, 0, 120, 12)];
        [self.lastCompletionLabel setFont:[UIFont systemFontOfSize:10]];
        [self.lastCompletionLabel setTextColor:[utils subtitleColor]];
        [self.lastCompletionLabel setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.lastCompletionLabel];
        //last completion date added
        
        //add 'done' button
        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.doneButton setTitle:@"done" forState:UIControlStateNormal];
        [self.doneButton setBackgroundColor:[UIColor colorWithRed:0/255.0f green:150/255.0f blue:43/255.0f alpha:1.0f]];
        self.doneButton.frame = CGRectMake(self.frame.size.width-50, 0, 50, self.frame.size.height);
        [self.doneButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.doneButton.titleLabel setTextColor:[UIColor colorWithRed:30/255.0f green:198/255.0f blue:20/255.0f alpha:1.0f]];
        [self.contentView addSubview:self.doneButton];
        //'done' button added
    }
    return self;
}

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    
    //show the done button before it animates back into view
    if (state == UITableViewCellStateDefaultMask)
    {
        [self.doneButton setAlpha:1];
    }
}

- (void)didTransitionToState:(UITableViewCellStateMask)state
{
    [super didTransitionToState:state];
    
    //hide the done button after it animates off view
    if (state == UITableViewCellStateEditingMask)
    {
        [self.doneButton setAlpha:0];
    }
}

- (void)layoutSubviews
{
    if(self.editing)
    {
        [self.habitLabel setFrame:CGRectMake(0-38, 0, [utils fullWidth], 44)];
        
        [self.daysAgoLabel setAlpha:0];
        [self.daysAgoLabel setFrame:CGRectMake(15-38, 0, 120, 12)];
        
        [self.lastCompletionLabel setAlpha:1];
        [self.lastCompletionLabel setFrame:CGRectMake([utils fullWidth]-120-15-38, 0, 120, 12)];
        
        [self.doneButton setFrame:CGRectMake(self.frame.size.width-50+12, 0, 50, self.frame.size.height)];
    }
    else
    {
        [self.habitLabel setFrame:CGRectMake(0, 0, [utils fullWidth], 44)];

        [self.daysAgoLabel setAlpha:1];
        [self.daysAgoLabel setFrame:CGRectMake(15, 0, 120, 12)];
        
        [self.lastCompletionLabel setAlpha:0];
        [self.lastCompletionLabel setFrame:CGRectMake([utils fullWidth]-120-15, 0, 120, 12)];
        
        [self.doneButton setFrame:CGRectMake(self.frame.size.width-50, 0, 50, self.frame.size.height)];
    }
    
    [super layoutSubviews];
}


@end
