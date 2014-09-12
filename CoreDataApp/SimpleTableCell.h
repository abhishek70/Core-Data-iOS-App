//
//  SimpleTableCell.h
//  CoreData
//
//  Created by Abhishek Desai on 11/6/13.
//  Copyright (c) 2013 Abhishek Desai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseLabel;
@property (strong, nonatomic) IBOutlet UILabel *assignmentLabel;

@end
