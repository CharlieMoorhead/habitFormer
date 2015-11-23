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
        [self.doneButton setBackgroundColor:buttonColor];
        [self.doneButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
        [self.deleteButton setBackgroundColor:buttonColor];
        [self.deleteButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
        //delete button added
        
        //add edit button
        self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.editButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.editButton setTitle:@">" forState:UIControlStateNormal];
        [self.editButton setTitleColor:buttonColor forState:UIControlStateNormal];
        [self.editButton.titleLabel setFont:[UIFont systemFontOfSize:25]];
        [self.contentView addSubview:self.editButton];
        [self.contentView sendSubviewToBack:self.editButton];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.editButton
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0f
                                                                      constant:0.0f
                                         ]];//14
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.editButton
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0f
                                                                      constant:0.0
                                         ]];//15
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
