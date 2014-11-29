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

    if([self.navigationController.viewControllers[1] isKindOfClass:[EditProfileDetailViewController class]]){
        self.navigationController.navigationItem.rightBarButtonItem = nil;
        self.user = [PFUser currentUser];
    }

    if (!self.user[@"SixPeople"][@"person0"])
        self.person0.placeholder = @"Person 1";
    else{
        self.person0.placeholder = self.user[@"person0"];
    }
    if (!self.user[@"SixPeople"][@"person1"])
        self.person2.placeholder = @"Person 2";
    else
        self.person0.text = self.user[@"person0"];
    if (!self.user[@"SixPeople"][@"person2"])
        self.person3.placeholder = @"Person 3";
    else
        self.person0.text = self.user[@"person0"];
    if (!self.user[@"SixPeople"][@"person3"])
        self.person4.placeholder = @"Person 4";
    else
        self.person0.text = self.user[@"person0"];
    if (!self.user[@"SixPeople"][@"person4"])
        self.person1.placeholder = @"Person 5";
    else
        self.person0.text = self.user[@"person0"];
    if (!self.user[@"SixPeople"][@"person5"])
        self.person5.placeholder = @"Person 6";
    else
        self.person0.text = self.user[@"person0"];
    
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
//    NSArray *stringsArray = [[NSArray alloc] initWithObjects:field0, field1, field2, field3, field4, field5, nil];
//    NSString *joinedString = [stringsArray componentsJoinedByString:@"   "];

    self.user[@"SixPeople"][@"person0"] = self.person0.text;
    self.user[@"SixPeople"][@"person1"] = self.person2.text;
    self.user[@"SixPeople"][@"person2"] = self.person3.text;
    self.user[@"SixPeople"][@"person3"] = self.person4.text;
    self.user[@"SixPeople"][@"person4"] = self.person1.text;
    self.user[@"SixPeople"][@"person5"] = self.person5.text;
    [self.user saveEventually:^(BOOL succeeded, NSError *error){
        if(!succeeded){
            [ProgressHUD showError:@"Network Error"];
        }
        else{
            [ProgressHUD showSuccess:@"Saved."];
        }
    }];

}

@end
