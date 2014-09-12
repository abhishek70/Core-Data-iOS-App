//
//  SimpleTableCell.m
//  CoreData
//
//  Created by Abhishek Desai on 11/6/13.
//  Copyright (c) 2013 Abhishek Desai. All rights reserved.
//

#import "SimpleTableCell.h"

@implementation SimpleTableCell
@synthesize dueDateLabel=_dueDateLabel;
@synthesize courseLabel=_courseLabel;
@synthesize assignmentLabel=_assignmentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
