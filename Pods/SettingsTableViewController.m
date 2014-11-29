//
//  SettingsTableViewController.m
//  app
//
//  Created by Henry Savit on 10/17/14.
//  Copyright (c) 2014 KZ. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "ProgressHUD.h"
#import "AppConstant.h"
#import "utilities.h"
#import <Parse/Parse.h> 
#import <MessageUI/MessageUI.h>

@interface SettingsTableViewController ()<UITextFieldDelegate, MFMessageComposeViewControllerDelegate>

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"Settings";
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"SnellRoundhand-Black" size:36],
      NSFontAttributeName, nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.086 green:0.627 blue:0.522 alpha:1] /*#16a085*/];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    self.ageSlider.minimumValue = 17;
    self.ageSlider.maximumValue = 68;
    float minValue = [[PFUser currentUser][@"minAge"] floatValue];
    self.ageSlider.value = minValue;
    if ((minValue) && (minValue != 0)){
        int myMin = [[NSNumber numberWithFloat:self.ageSlider.value] intValue];
        self.ageLabel.text = [@"Minimum Age: " stringByAppendingString:[NSString stringWithFormat:@"%i", myMin]];
    }
    else
        self.ageLabel.text = [@"Minimum Age: " stringByAppendingString:[NSString stringWithFormat:@"%i", 17]];
    
    self.maxAgeSlider.minimumValue = 17;
    self.maxAgeSlider.maximumValue = 70;
    float maxValue = [[PFUser currentUser][@"maxAge"] floatValue];
    self.maxAgeSlider.value = maxValue;
    if ((maxValue) && (maxValue != 0)){
        int myMax = [[NSNumber numberWithFloat:self.maxAgeSlider.value] intValue];
        self.maxAgeLabel.text = [@"Maximum Age: " stringByAppendingString:[NSString stringWithFormat:@"%i", myMax]];
    }
    else
        self.maxAgeLabel.text = [@"Maximum Age: " stringByAppendingString:[NSString stringWithFormat:@"%i", 65]];

    self.distanceSlider.minimumValue = 1;
    self.distanceSlider.maximumValue = 300;
    self.distanceSlider.value = [[PFUser currentUser][@"maxRadius"] floatValue];
    int myInt = [[NSNumber numberWithFloat:self.distanceSlider.value] intValue];
    self.distanceLabel.text = [@"Maximum Search Radius: " stringByAppendingString:[NSString stringWithFormat:@"%i", (int)myInt]];
    
    
    self.usernameLabel.text = [@"Current Username: " stringByAppendingString:[PFUser currentUser][@"firstName"] ];
    self.changeUsernameTextField.delegate = self;
    UIColor *textColor = [UIColor whiteColor];
    if ([ self.changeUsernameTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        NSString * placeholderText =  @"Choose Username";
        self.changeUsernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: textColor}];
    }
    
    self.shoMenSwitch.on = [[PFUser currentUser][@"showMen"] boolValue];
    self.showWomenSwitch.on = [[PFUser currentUser][@"showWomen"] boolValue];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField becomeFirstResponder];
    
    if(textField == self.changeUsernameTextField){
        textField.placeholder = @"Choose Username";
    }
    
    else{
        textField.placeholder = nil;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.changeUsernameTextField.placeholder = @"Choose Username";
    UIColor *textColor = [UIColor whiteColor];
    if ([ self.changeUsernameTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        NSString * placeholderText =  @"Choose Username";
        self.changeUsernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: textColor}];
    }
}

- (IBAction)maxAgeSliderMoved:(id)sender {
    int myInt = [[NSNumber numberWithFloat:self.maxAgeSlider.value] intValue];
    self.maxAgeLabel.text = [@"Maximum Age: " stringByAppendingString:[NSString stringWithFormat:@"%i", myInt]];
}
- (IBAction)ageSliderMoved:(id)sender {
    int myInt = [[NSNumber numberWithFloat:self.ageSlider.value] intValue];
    self.ageLabel.text = [@"Minimum Age: " stringByAppendingString:[NSString stringWithFormat:@"%i", myInt]];
}
- (IBAction)distanceSliderMoved:(id)sender {
    int myInt = [[NSNumber numberWithFloat:self.distanceSlider.value] intValue];
    self.distanceLabel.text = [@"Maximum Search Radius: " stringByAppendingString:[NSString stringWithFormat:@"%i", myInt]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 7;
}

- (IBAction)saveButtonPressed:(id)sender {
    [self resignFirstResponder];
    
    if(self.ageSlider.value < self.maxAgeSlider.value){

            [ProgressHUD show:@"Please wait..."];
            
            PFUser *user = [PFUser currentUser];
            if (![self.changeUsernameTextField.text isEqualToString:@""]){
                user[@"firstName"] = self.changeUsernameTextField.text;
                //user[PF_USER_FULLNAME_LOWER] = [self.changeUsernameTextField.text lowercaseString];
            }
        NSLog(@"%f", self.maxAgeSlider.value);

            user[@"minAge"] = [NSNumber numberWithFloat: self.ageSlider.value];
            user[@"maxAge"] = [NSNumber numberWithFloat: self.ageSlider.value];
            user[@"maxRadius"] = [NSNumber numberWithFloat: self.distanceSlider.value];
            user[@"showMen"] = [NSNumber numberWithBool:self.shoMenSwitch.on ];
            user[@"showWomen"] = [NSNumber numberWithBool:self.showWomenSwitch.on];

            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
             {
                 if (error == nil)
                 {
                     [ProgressHUD showSuccess:@"Saved."];
                 }
                 else [ProgressHUD showError:@"Network error."];
             }];
    }
    else{
        [ProgressHUD showError:@"Min Age > Max Age"];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            //do some messaging
            if(![MFMessageComposeViewController canSendText]) {
                UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [warningAlert show];
                return;
            }
            
            NSString *textString = [NSString stringWithFormat:@"Love Buds? Download LoveBuds!"];
            
            MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
            messageController.messageComposeDelegate = self;
            [messageController setBody:textString];
            UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
            messageController.navigationItem.leftBarButtonItem = cancel;
            
            [self presentViewController:messageController animated:YES completion:nil];
            
            break;
        }
        case 5:
            //
            
            break;
        case 6:
            //logout
            if(indexPath.row == 1){
                [PFUser logOut];
                PostNotification(NOTIFICATION_USER_LOGGED_OUT);
                
                [self.tabBarController setSelectedIndex:0];
                LoginUser(self);
            }
            else{
                
            }
                
            break;

        default:
            break;
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancelButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
