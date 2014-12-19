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
@interface SixStonersYouMeetInHeaven(){
    //NSMutableArray *sixPeople;
}

@end

@implementation SixStonersYouMeetInHeaven

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:242/255. green:242/255. blue:246/255. alpha:1.0]];

    self.user = [PFUser currentUser];
    [self fillInStuff];
}

-(void)fillInStuff{
    PFQuery *userQuery = [PFQuery queryWithClassName:@"UserProfile"];
    [userQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    userQuery.limit = 1;
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *err){
        if (objects.count != 0) {
            NSArray *ppl = objects[0][@"sixPeopleArray"];
            self.person0.text = ppl[0];
            self.person1.text = ppl[1];
            self.person2.text = ppl[2];
            self.person3.text = ppl[3];
            self.person4.text = ppl[4];
            self.person5.text = ppl[5];
        }
    }];
}

- (IBAction)saveButton:(id)sender {

    [ProgressHUD show:@"Please wait..."];

    PFQuery *userQuery = [PFQuery queryWithClassName:@"UserProfile"];
    [userQuery whereKey:@"user" equalTo:self.user];
    userQuery.limit = 1;
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(objects.count != 0){
            NSArray *stringsArray = [[NSArray alloc] initWithObjects:self.person0.text, self.person1.text, self.person2.text, self.person3.text, self.person4.text, self.person5.text, nil];
            //NSString *joinedString = [stringsArray componentsJoinedByString:@" "];
            PFObject *userObj = objects[0];
            userObj[@"sixPeopleArray"] = stringsArray;
            [userObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [ProgressHUD showSuccess:@"Saved."];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                    [ProgressHUD showError:@"Network Error"];
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
