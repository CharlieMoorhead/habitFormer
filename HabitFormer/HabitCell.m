//
//  HabitCell.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 2/1/15.
//  Copyright (c) 2015 Charlie Moorhead. All rights reserved.
//

#import "HabitCell.h"

@implementation HabitCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //add habit label
        self.habitLabel = [[UILabel alloc] init];
        self.habitLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.habitLabel setFont:[UIFont systemFontOfSize:17]];
        [self.habitLabel setTextAlignment:NSTextAlignmentCenter];
        [self.habitLabel setTextColor:textColor];
        [self.contentView addSubview:self.habitLabel];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.habitLabel
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterX
                                                                    multiplier:1.0f
                                                                      constant:0.0f
                                         ]];//0
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.habitLabel
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0f
                                                                      constant:0.0f
                                         ]];//1
        //habit label added
        
        //add days ago completed
        self.daysAgoLabel = [[UILabel alloc] init];
        self.daysAgoLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.daysAgoLabel setFont:[UIFont systemFontOfSize:10]];
        [self.daysAgoLabel setTextColor:textColor];
        [self.contentView addSubview:self.daysAgoLabel];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.daysAgoLabel
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0f
                                                                      constant:15.0f
                                         ]];//2
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.daysAgoLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f
                                                                      constant:2.0f
                                         ]];//3
        //days ago completed added
        
        //add last completion date
        self.lastCompletionLabel = [[UILabel alloc] init];
        self.lastCompletionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.lastCompletionLabel setFont:[UIFont systemFontOfSize:10]];
        [self.lastCompletionLabel setTextColor:textColor];
        [self.contentView addSubview:self.lastCompletionLabel];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lastCompletionLabel
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0f
                                                                      constant:-15.0f
                                         ]];//4
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lastCompletionLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f
                                                                      constant:2.0f
                                         ]];//5
        //last completion date added
        
        //add 'done' button
        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.doneButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.doneButton setTitle:@"done" forState:UIControlStateNormal];
        //[self.doneButton setBackgroundColor:[UIColor colorWithRed:0/255.0f green:150/255.0f blue:43/255.0f alpha:1.0f]];
        [self.doneButton setBackgroundColor:buttonColor];
        [self.doneButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        //[self.doneButton.titleLabel setTextColor:[UIColor colorWithRed:30/255.0f green:198/255.0f blue:20/255.0f alpha:1.0f]];
        [self.doneButton.titleLabel setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.doneButton];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.doneButton
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f
                                                                      constant:50.0f
                                         ]];//6
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.doneButton
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeHeight
                                                                    multiplier:1.0f
                                                                      constant:0.0f
                                         ]];//7
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.doneButton
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0f
                                                                      constant:0.0f
                                         ]];//8
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.doneButton
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f
                                                                      constant:0.0f
                                         ]];//9
        //'done' button added
        
        //add 'delete' button
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.deleteButton setTitle:@"delete" forState:UIControlStateNormal];
        //[self.deleteButton setBackgroundColor:[UIColor colorWithRed:147/255.0f green:18/255.0f blue:0/255.0f alpha:1.0f]];
        [self.deleteButton setBackgroundColor:buttonColor];
        [self.deleteButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        //[self.deleteButton.titleLabel setTextColor:[UIColor colorWithRed:30/255.0f green:198/255.0f blue:20/255.0f alpha:1.0f]];
        [self.deleteButton.titleLabel setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.deleteButton];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.deleteButton
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f
                                                                      constant:50.0f
                                         ]];//10
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.deleteButton
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeHeight
                                                                    multiplier:1.0f
                                                                      constant:0.0f
                                         ]];//11
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.deleteButton
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0f
                                                                      constant:0.0f
                                         ]];//12
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.deleteButton
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f
                                                                      constant:0.0f
                                         ]];//13
    }
    return self;
}

/*- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    
    //this is not really necessary at this point
    //
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
    //
    //hide the done button after it animates off view
 
    if (state == UITableViewCellStateEditingMask)
    {
        [self.doneButton setAlpha:0];
    }
 
}*/

- (void)layoutSubviews
{
    if(self.editing)
    {
        [self.daysAgoLabel setAlpha:0];
        [self.lastCompletionLabel setAlpha:1];
    }
    else
    {
        [self.daysAgoLabel setAlpha:1];
        [self.lastCompletionLabel setAlpha:0];
    }
    [self updateConstraints];
    [super layoutSubviews];
}

-(void)updateConstraints
{
    if (self.contentView.constraints.count > 12)
    {
        NSLayoutConstraint *doneConstraint = (NSLayoutConstraint *)self.contentView.constraints[8];
        NSLayoutConstraint *deleteConstraint = (NSLayoutConstraint *)self.contentView.constraints[12];
        if (self.editing)
        {
            doneConstraint.constant = 50.0f;
            deleteConstraint.constant = 0.0f;
        }
        else
        {
            doneConstraint.constant = 0.0f;
            deleteConstraint.constant = -50.0f;
        }
    }
    [super updateConstraints];
}



@end
