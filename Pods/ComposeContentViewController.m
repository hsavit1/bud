//
//  ComposeContentViewController.m
//  app
//
//  Created by Henry Savit on 10/18/14.
//  Copyright (c) 2014 KZ. All rights reserved.
//

#import "ComposeContentViewController.h"
#import "AppConstant.h"
#import <Parse/Parse.h>
#import "ProgressHUD.h"


@interface ComposeContentViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *inputAccView;
@property (nonatomic, strong) UILabel *maxCharLabel;


@end

@implementation ComposeContentViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.textArea becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Change Bio";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18], NSFontAttributeName, nil]];
    self.navigationItem.titleView.center = self.navigationController.navigationBar.center;
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    
//    self.inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0, CGRectGetMaxX(self.view.bounds), 40.0)];
//    [self.inputAccView setBackgroundColor:[UIColor colorWithRed:0.086 green:0.627 blue:0.522 alpha:1] /*#16a085*/];
//    [self.inputAccView setAlpha: 0.6];
//    self.maxCharLabel = [[UILabel alloc]initWithFrame:CGRectMake(270, 0.0f, 50.0f, 40.0f)];
//    self.maxCharLabel.text = [NSString stringWithFormat:@"%i", 200];
//    self.maxCharLabel.textColor = [UIColor whiteColor];
//    [self.maxCharLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24]];
//    [self.inputAccView addSubview:self.maxCharLabel];
    
    self.textArea.textColor = [UIColor lightGrayColor];
    
    PFUser *user = [PFUser currentUser];
    if ([self.senderCellNumber integerValue] == 1){
        NSString *string = user[@"bioDescription"];
        if (string.length == 0)
            self.textArea.placeholder = NSLocalizedString(@"Say something about yourself here", nil);
        else
            self.textArea.text = string;
    }
    else if ([self.senderCellNumber integerValue] == 5){
        NSString *string = user[@"education"];
        if (string.length == 0)
            self.textArea.placeholder = NSLocalizedString(@"Where did you go to school? What did you study?", nil);
        else
            self.textArea.text = string;
    }
    
    self.textArea.inputAccessoryView = self.inputAccView;
    self.textArea.delegate = self;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.textArea resignFirstResponder];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)doneButtonPressed:(id)sender {
    
    [ProgressHUD show:@"Please wait..."];
    
    PFQuery *userQuery = [PFQuery queryWithClassName:@"UserProfile"];
    [userQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    userQuery.limit = 1;
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *err){
        if (objects.count != 0) {
            if ([self.senderCellNumber integerValue] == 1){
                PFObject *userObj = objects[0];
                userObj[@"bio"] = self.textArea.text;
                [userObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        [ProgressHUD showSuccess:@"Saved."];
                    }
                    else{
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
            else if ([self.senderCellNumber integerValue] == 5){
                PFObject *userObj = objects[0];
                userObj[@"education"] = self.textArea.text;
                [userObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        [ProgressHUD showSuccess:@"Saved."];
                    }
                    else{
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];

}

- (void)textViewDidChange:(UITextView *)textView
{
    if(textView == self.textArea){
        self.maxCharLabel.text = [NSString stringWithFormat:@"%u", (200 - (int)textView.text.length) ];
        if (textView.text.length == 0) {
            if ([self.senderCellNumber integerValue] == 1)
                self.textArea.placeholder = NSLocalizedString(@"Say something about yourself here", nil);
            else if ([self.senderCellNumber integerValue] == 2)
                self.textArea.placeholder = NSLocalizedString(@"What are you smoking on?", nil);
            else if ([self.senderCellNumber integerValue] == 3)
                self.textArea.placeholder = NSLocalizedString(@"How often do you toke up?", nil);
            else if ([self.senderCellNumber integerValue] == 4)
                self.textArea.placeholder = NSLocalizedString(@"Elaborate on your equipment here", nil);
            }
        }
}

@end
