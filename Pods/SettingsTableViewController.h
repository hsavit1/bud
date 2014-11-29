//
//  SettingsTableViewController.h
//  app
//
//  Created by Henry Savit on 10/17/14.
//  Copyright (c) 2014 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISlider *ageSlider;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UISlider *maxAgeSlider;
@property (weak, nonatomic) IBOutlet UILabel *maxAgeLabel;

@property (weak, nonatomic) IBOutlet UISlider *distanceSlider;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UISwitch *shoMenSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *showWomenSwitch;

@property (weak, nonatomic) IBOutlet UIButton *contactUsButton;

@property (weak, nonatomic) IBOutlet UITextField *changeUsernameTextField;


@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;


@end
