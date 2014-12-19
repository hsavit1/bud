//
//  FivePeopleYouMeetInHeaven.m
//  app
//
//  Created by Henry Savit on 10/28/14.
//  Copyright (c) 2014 KZ. All rights reserved.
//

#import "SixStonersYouMeetInHeaven.h"
#import "EditProfileDetailViewController.h"
#import "ProgressHUD.h"

@implementation SixStonersYouMeetInHeaven

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:242/255. green:242/255. blue:246/255. alpha:1.0]];

    self.user = [PFUser currentUser];
    
}

- (IBAction)saveButton:(id)sender {

    [ProgressHUD show:@"Please wait..."];
    
//    NSString *field0 = [NSString stringWithFormat:@"1. %@", self.person0.text];
//    NSString *field1 = [NSString stringWithFormat:@"2. %@", self.person2.text];
//    NSString *field2 = [NSString stringWithFormat:@"3. %@", self.person3.text];
//    NSString *field3 = [NSString stringWithFormat:@"4. %@", self.person4.text];
//    NSString *field4 = [NSString stringWithFormat:@"5. %@", self.person1.text];
//    NSString *field5 = [NSString stringWithFormat:@"6. %@", self.person5.text];
//    
//
    
    PFQuery *userQuery = [PFQuery queryWithClassName:@"UserProfile"];
    [userQuery whereKey:@"user" equalTo:self.user];
    userQuery.limit = 1;
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(objects.count != 0){
            NSArray *stringsArray = [[NSArray alloc] initWithObjects:self.person0.text, self.person1.text, self.person2.text, self.person3.text, self.person4.text, self.person5.text, nil];
            NSString *joinedString = [stringsArray componentsJoinedByString:@" "];
            PFObject *userObj = objects[0];
            userObj[@"sixPeople"] = joinedString;
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
        else{
            //no user
            [ProgressHUD showError:@"Network Error"];
        }
    }];
}

@end
