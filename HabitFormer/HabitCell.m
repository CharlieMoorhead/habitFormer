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
        self.habitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
        [self.habitLabel setFont:[UIFont systemFontOfSize:17]];
        [self.habitLabel setTextAlignment:NSTextAlignmentCenter];
        [self.habitLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:self.habitLabel];
        //habit label added
        
        //add days ago completed
        self.daysAgoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, 12)];
        [self.daysAgoLabel setFont:[UIFont systemFontOfSize:10]];
        [self.daysAgoLabel setTextColor:[utils textColor]];
        [self.contentView addSubview:self.daysAgoLabel];
        //days ago completed added
        
        //add last completion date
        self.lastCompletionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-120-15, 0, 120, 12)];
        [self.lastCompletionLabel setFont:[UIFont systemFontOfSize:10]];
        [self.lastCompletionLabel setTextColor:[utils textColor]];
        [self.lastCompletionLabel setTextAlignment:NSTextAlignmentRight];
        [self.lastCompletionLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [self.contentView addSubview:self.lastCompletionLabel];
        //last completion date added
        
        //add 'done' button
        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.doneButton setTitle:@"done" forState:UIControlStateNormal];
        //[self.doneButton setBackgroundColor:[UIColor colorWithRed:0/255.0f green:150/255.0f blue:43/255.0f alpha:1.0f]];
        [self.doneButton setBackgroundColor:[utils buttonColor]];
        self.doneButton.frame = CGRectMake(self.frame.size.width-50, 0, 50, self.frame.size.height);
        [self.doneButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        //[self.doneButton.titleLabel setTextColor:[UIColor colorWithRed:30/255.0f green:198/255.0f blue:20/255.0f alpha:1.0f]];
        [self.doneButton.titleLabel setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.doneButton];
        //'done' button added
        
        //add 'delete' button
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton setTitle:@"delete" forState:UIControlStateNormal];
        //[self.deleteButton setBackgroundColor:[UIColor colorWithRed:147/255.0f green:18/255.0f blue:0/255.0f alpha:1.0f]];
        [self.deleteButton setBackgroundColor:[utils buttonColor]];
        self.deleteButton.frame = CGRectMake(0, 0, 50, self.frame.size.height);
        [self.deleteButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        //[self.deleteButton.titleLabel setTextColor:[UIColor colorWithRed:30/255.0f green:198/255.0f blue:20/255.0f alpha:1.0f]];
        [self.deleteButton.titleLabel setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.deleteButton];
    }
    return self;
}

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    
    //this is not really necessary at this point
    //  but it probably doesn't hurt anything
    //show the done button before it animates back into view
    if (state == UITableViewCellStateDefaultMask)
    {
        [self.doneButton setAlpha:1];
    }
}

- (void)didTransitionToState:(UITableViewCellStateMask)state
{
    [super didTransitionToState:state];
    
    //this is not really necessary at this point
    //  but it probably doesn't hurt anything
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
        [self.daysAgoLabel setAlpha:0];
        
        [self.lastCompletionLabel setAlpha:1];
        
        [self.doneButton setFrame:CGRectMake(self.frame.size.width, 0, 50, self.frame.size.height)];
        
        [self.deleteButton setFrame:CGRectMake(0, 0, 50, self.frame.size.height)];
    }
    else
    {
        [self.daysAgoLabel setAlpha:1];
        
        [self.lastCompletionLabel setAlpha:0];
        
        [self.doneButton setFrame:CGRectMake(self.frame.size.width-50, 0, 50, self.frame.size.height)];
        
        [self.deleteButton setFrame:CGRectMake(-50, 0, 50, self.frame.size.height)];
    }
    
    //[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, [utils fullWidth], self.frame.size.height)];
    
    [super layoutSubviews];
}


@end
