//
//  FivePeopleYouMeetInHeaven.h
//  app
//
//  Created by Henry Savit on 10/28/14.
//  Copyright (c) 2014 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoTextField.h"
#import <Parse/Parse.h>

@interface SixStonersYouMeetInHeaven : UIViewController


@property (weak, nonatomic) IBOutlet DemoTextField *person0;
@property (weak, nonatomic) IBOutlet DemoTextField *person1;
@property (weak, nonatomic) IBOutlet DemoTextField *person2;
@property (weak, nonatomic) IBOutlet DemoTextField *person3;
@property (weak, nonatomic) IBOutlet DemoTextField *person4;
@property (weak, nonatomic) IBOutlet DemoTextField *person5;

@property (weak, nonatomic) PFUser *user;

@end
