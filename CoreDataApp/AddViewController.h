//
//  AddViewController.h
//  CoreDataApp
//
//  Created by Abhishek Desai on 9/11/14.
//  Copyright (c) 2014 Abhishek Desai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddViewController : UIViewController

// Setting up the fields used in the form
@property (strong, nonatomic) IBOutlet UITextField *courseTextField;
@property (strong, nonatomic) IBOutlet UITextField *assignmentTextField;
@property (strong, nonatomic) IBOutlet UITextField *dueDateTextField;

@end
