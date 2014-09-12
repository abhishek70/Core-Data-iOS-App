//
//  AddViewController.m
//  CoreDataApp
//
//  Created by Abhishek Desai on 9/11/14.
//  Copyright (c) 2014 Abhishek Desai. All rights reserved.
//

#import "AddViewController.h"
#import "AppDelegate.h"

@interface AddViewController ()

@end

@implementation AddViewController

@synthesize courseTextField;
@synthesize assignmentTextField;
@synthesize dueDateTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Add";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Save"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(saveRecord:)];
	
	self.navigationItem.rightBarButtonItem = rightButton; // Add button to right side of bar
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate date];
    NSString *dateString = [dateFormat stringFromDate:date];
    [dueDateTextField setText:dateString];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // Setting up the custom UIDatePicker
    UIDatePicker *myPicker = [[UIDatePicker alloc] init];
    myPicker.datePickerMode = UIDatePickerModeDate;
    // set picker frame, options, etc...
    // N.B. origin for the picker's frame should be 0,0
    
    [dueDateTextField setInputView:myPicker];
    [myPicker addTarget:self
              action:@selector(datePickerValueChanged:)
       forControlEvents:UIControlEventValueChanged];
    
}

/*
 * Fetching the date when the user changed any dates on the date picker
 */
- (void)datePickerValueChanged:(id)sender{
    
    UIDatePicker *picker = (UIDatePicker *)sender;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString = [dateFormat stringFromDate:[picker date]];
    
    [dueDateTextField setText:dateString];
}

/*
 * Function for hiding the keyboard when the user touches any part of the screen
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [dueDateTextField resignFirstResponder];
    [courseTextField resignFirstResponder];
    [assignmentTextField resignFirstResponder];
}

/*
 * Function for hiding the keyboard when the user click on the return button on the keyboard
 */
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == courseTextField) {
        [courseTextField resignFirstResponder];
    }
    if (theTextField == assignmentTextField) {
        [assignmentTextField resignFirstResponder];
    }
    return YES;
}

/*
 * Function for adding the record to the core data
 */
- (IBAction)saveRecord:(id)sender {
    
    BOOL success = NO;
    NSString *alertString = @"Data Insertion failed";
    
    if (courseTextField.text.length>0 &&assignmentTextField.text.length>0 &&
        dueDateTextField.text.length>0) {
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        NSManagedObject *newAssignmentRecord= [NSEntityDescription insertNewObjectForEntityForName:@"Assignmentlist" inManagedObjectContext:context];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *date = [dateFormatter dateFromString:dueDateTextField.text];
        
        [newAssignmentRecord setValue: courseTextField.text forKey:@"courseTextField"];
        [newAssignmentRecord setValue: assignmentTextField.text forKey:@"assignmentTextField"];
        [newAssignmentRecord setValue: date forKey:@"dueDateTextField"];
        courseTextField.text = @"";
        assignmentTextField.text = @"";
        dueDateTextField.text = @"";
        NSError *error;
        [context save:&error];
        success =YES;
        [dueDateTextField resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        alertString = @"Please enter value for all fields";
    }
    if (success == NO) {
        
        // Showing the Alert View for showing message
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:
                              alertString message:nil
                              delegate:nil
                              cancelButtonTitle:@"Close"
                              otherButtonTitles:nil];
        [alert show];
    }
}


@end
