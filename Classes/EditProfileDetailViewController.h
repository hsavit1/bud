//
//  ProfileViewController.h
//  LikedOrNope
//
//  Created by Henry Savit on 10/15/14.
//  Copyright (c) 2014 modocache. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangeTextViewFrame.h"
#import <Parse/Parse.h>

@interface EditProfileDetailViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;

//big main image button
@property (weak, nonatomic) IBOutlet PFImageView *addImage0;
@property (weak, nonatomic) IBOutlet UIButton *removeImage0;

//second big image button
@property (weak, nonatomic) IBOutlet PFImageView *addImage1;
@property (weak, nonatomic) IBOutlet UIButton *removeImage1;

//1st on 2nd row
@property (weak, nonatomic) IBOutlet PFImageView *addImage2;
@property (weak, nonatomic) IBOutlet UIButton *removeImage2;

//2nd on 2nd row
@property (weak, nonatomic) IBOutlet PFImageView *addImage3;
@property (weak, nonatomic) IBOutlet UIButton *removeImage3;
@property (weak, nonatomic) IBOutlet UIButton *addImage3Button;

//3rd on 2nd row
@property (weak, nonatomic) IBOutlet PFImageView *addImage4;
@property (weak, nonatomic) IBOutlet UIButton *removeImage4;
@property (weak, nonatomic) IBOutlet UIButton *addImage4Button;

//4th on 2nd row
@property (weak, nonatomic) IBOutlet PFImageView *addImage5;
@property (weak, nonatomic) IBOutlet UIButton *removeImage5;

@property (weak, nonatomic) IBOutlet UILabel *personalBioLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteTypeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *tokeTimesLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteToolsLabel;


//education cell
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;

//location cell
@property (weak, nonatomic) IBOutlet UILabel *userLocationLabel;

//6 stoners
@property (weak, nonatomic) IBOutlet UILabel *sixStonersInHeaven;

//@property (weak, nonatomic) IBOutlet UIButton *medi1;
//@property (weak, nonatomic) IBOutlet UIButton *medi2;
//@property (weak, nonatomic) IBOutlet UIButton *medi3;
//@property (weak, nonatomic) IBOutlet UIButton *medi4;
//@property (weak, nonatomic) IBOutlet UIButton *medi5;
//@property (weak, nonatomic) IBOutlet UIButton *medi6;
//@property (weak, nonatomic) IBOutlet UIButton *medi7;
//@property (weak, nonatomic) IBOutlet UIButton *medi8;
//@property (weak, nonatomic) IBOutlet UIButton *medi9;
//@property (weak, nonatomic) IBOutlet UIButton *allMediButtons;

@property (weak, nonatomic) IBOutlet UIImageView *favoriteStrainImage;
@end
