//
//  ProfileDetailTVC.h
//  app
//
//  Created by Henry Savit on 10/16/14.
//  Copyright (c) 2014 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ProfileDetailTVC : UITableViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) PFUser *user;



@property (weak, nonatomic) IBOutlet UIImageView *sixPeopleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *educationImageVIew;


//in the "about me" cell
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numMutualFriendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastActiveLabel;

@property (weak, nonatomic) NSNumber *favoriteStrainsNumber;
@property (weak, nonatomic) NSString *educationLabelString;

@property (weak, nonatomic) IBOutlet UILabel *personalBioLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteStrains;
@property (weak, nonatomic) IBOutlet UILabel *sixStonersInHeaven;
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;

@property (weak, nonatomic) IBOutlet UIView *favoriteToolsContentView;

/*!
 * The "liked" view, which fades in when the like button is pressed
 */
@property (nonatomic, strong) UIView *likedView;

/*!
 * The "nope" view, which fades in when the nope button is pressed
 */
@property (nonatomic, strong) UIView *nopeView;

@property (nonatomic, strong) UIColor *likeColor;
@property (nonatomic, strong) UIColor *nopeColor;
@property (nonatomic, assign) CGFloat nopeRotationAngle;
@property (nonatomic, assign) CGFloat likedRotationAngle;


@end
