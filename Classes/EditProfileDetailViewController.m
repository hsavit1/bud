//
//  ProfileViewController.m
//  LikedOrNope
//
//  Created by Henry Savit on 10/15/14.
//  Copyright (c) 2014 modocache. All rights reserved.
//

#import "EditProfileDetailViewController.h"
#import "AppConstant.h"
#import "ProgressHUD.h"
#import "ComposeContentViewController.h"
#import "DoActionSheet.h"
#import "MBProgressHUD.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define IS_IPHONE_6PLUS (IS_IPHONE && [[UIScreen mainScreen] nativeScale] == 3.0f)
#define IS_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0)

/*
  tags: 0 - 6
        1000 - 1005 (x buttons)
        100 - 105 (add buttons)
        111 - 117 (PFImageView)
        1 - 9 (radio buttons)
*/

@interface EditProfileDetailViewController ()<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>{
    NSMutableArray *profilePicsArray;
    NSArray *removeButtons;
    NSMutableArray *favoriteTools;
    NSMutableArray *sixPeople;
    BOOL isPageEdited;
    MBProgressHUD *HUD;
    MBProgressHUD *refreshHUD;
}

@property (strong, nonatomic) UIImagePickerController *imagePick;
@property (weak, nonatomic) NSNumber *pickedImage;
@property (weak, nonatomic) NSNumber *lastPickedImage;
@property (weak, nonatomic) IBOutlet UIView *photoCellContentView;
@property (weak, nonatomic) IBOutlet UIView *toolsContentView;

@end

@implementation EditProfileDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Edit Profile";
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"SnellRoundhand-Black" size:36],
      NSFontAttributeName, nil]];
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    favoriteTools = [[NSMutableArray alloc]initWithObjects:@NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, nil];
    sixPeople = [[NSMutableArray alloc]initWithObjects:@"", @"", @"", @"", @"", @"", nil];
    
    //these are the add image buttons
    for (int i = 100; i < 106; i++) {
        [self.photoCellContentView viewWithTag:i].layer.cornerRadius = 8;
        [self.photoCellContentView viewWithTag:i].layer.masksToBounds = YES;
        [self.photoCellContentView viewWithTag:i].layer.borderColor = [UIColor colorWithRed:0.086 green:0.627 blue:0.522 alpha:1].CGColor; /*#16a085*/
        [self.photoCellContentView viewWithTag:i].layer.borderWidth = 3;
    }
    
    //these are the remove image buttons
    for (int i = 1000; i < 1006; i++) {
        [self.photoCellContentView viewWithTag:i].layer.cornerRadius = [self.photoCellContentView viewWithTag:i].frame.size.width / 2;
        [self.photoCellContentView viewWithTag:i].layer.masksToBounds = YES;
        [self.photoCellContentView viewWithTag:i].hidden = YES;
    }
    
    PFUser *user = [PFUser currentUser];
    PFQuery *imageQuery = [PFQuery queryWithClassName:@"Photo"];
    [imageQuery whereKey:@"user" equalTo:user];
    imageQuery.limit = 6;
    [imageQuery orderByAscending:@"rank"];
    [imageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *err){
        if (objects.count != 0) {
            
            for (int i = 0; i < objects.count; i++) {
                if(!objects[i][@"photo"]){
                }
                else{
                    ((PFImageView*)[self.photoCellContentView viewWithTag:(i+111)]).layer.cornerRadius = 9;
                    ((PFImageView*)[self.photoCellContentView viewWithTag:(i+111)]).layer.masksToBounds = YES;
                    ((UIImageView *)[self.photoCellContentView viewWithTag:(i+111)]).contentMode = UIViewContentModeScaleAspectFill;
                    
//                    ((PFImageView*)[self.photoCellContentView viewWithTag:(i+111)]).file = objects[i][@"photo"];
//                    [((PFImageView*)[self.photoCellContentView viewWithTag:(i+111)]) loadInBackground];
                    
                        switch (i) {
                            case 0:
                                self.addImage0.file = objects[i][@"photo"];
                                [self.addImage0 loadInBackground];
                                break;
                            case 1:
                                self.addImage1.file = objects[i][@"photo"];
                                [self.addImage1 loadInBackground];
                                break;
                            case 2:
                                self.addImage2.file = objects[i][@"photo"];
                                [self.addImage2 loadInBackground];
                                break;
                            case 3:
                                self.addImage3.file = objects[i][@"photo"];
                                [self.addImage3 loadInBackground];
                                break;
                            case 4:
                                self.addImage4.file = objects[i][@"photo"];
                                [self.addImage4 loadInBackground];
                                break;
                            case 5:
                                self.addImage5.file = objects[i][@"photo"];
                                [self.addImage5 loadInBackground];
                                break;
                            default:
                                break;
                        }
                    
                    [self.photoCellContentView viewWithTag:(i + 1000)].hidden = NO;
                    //[profilePicsArray addObject:((PFImageView*)[self.photoCellContentView viewWithTag:(i+111)])];

                }
            }
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.tableView reloadData];
            });
        }
    }];
    
//    int strain = [[PFUser currentUser][@"favoriteStrain"] intValue];
//    switch (strain) {
//            //save a number when done to the db (0 -> 3, indicating your choice)
//        case 0:
//            self.favoriteStrainImage.image = [UIImage imageNamed:@"indica_burned.png"];
//            self.favoriteTypeLabel.text = @"Indica";
//            self.favoriteTypeLabel.text = @"Indica: You're someone who likes to chill. The full body effects of the indica are relaxing for you after a full day's worth of work.";
//            [self saveFavoriteStrain:0];
//            break;
//        case 1:
//            self.favoriteStrainImage.image = [UIImage imageNamed:@"rsz_1rsz_1sativa.png"];
//            self.favoriteTypeLabel.text = @"Sativa: You're someone who likes to be active and in the moment. You embrace the uplifing elements of the strain and you like to feel the creative juices flow.";
//            [self saveFavoriteStrain:1];
//            break;
//        case 2:
//            self.favoriteStrainImage.image = [UIImage imageNamed:@"hybrid_burned.png"];
//            self.favoriteTypeLabel.text = @"Hybrid";
//            self.favoriteTypeLabel.text = @"Hybrid: You're a bit of a scientist. You experiement with different strains until you're satisfied with a perfect balance of indica and sativa.";
//            [self saveFavoriteStrain:2];
//            break;
//        case 3:
//            self.favoriteTypeLabel.text = @"Whatever my friends have: You'll fill your bowl with anything you can find. Any weed is good weed for you";
//            [self saveFavoriteStrain:3];
//            break;
//        case 4:
//            
//        default:
//            break;
//    }

}

//get stuff
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    PFQuery *userQuery = [PFQuery queryWithClassName:@"UserProfile"];
    [userQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    userQuery.limit = 1;
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *err){
        if (objects.count != 0) {
            self.personalBioLabel.text = objects[0][@"bio"];
            self.educationLabel.text = objects[0][@"education"];
//            favoriteTools = objects[0][@"favoriteTools"];
            NSArray *ppl = objects[0][@"sixPeopleArray"];
            //NSArray *myWords = [ppl componentsSeparatedByString:@" "];
            sixPeople = ppl;
//            [self fillInFavoriteTools];
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.tableView reloadData];
            });
        }
    }];
}

////fill in favoriteTools table
//-(void)fillInFavoriteTools{
//    for (int i = 1; i < 9; i++) {
//        if([favoriteTools[i-1] intValue] == 1){
//            [self.toolsContentView viewWithTag:i].alpha = 1;
//            [self.toolsContentView viewWithTag:(i*11)].alpha = 1;
//        }
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 189;
            break;
        case 1:{
            if (IS_IPHONE_5) {
                [self.personalBioLabel setPreferredMaxLayoutWidth:230];
                CGSize expectedSize = [self.personalBioLabel.text boundingRectWithSize:CGSizeMake(230, 10000)
                                                                            options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                         attributes:@{NSFontAttributeName:
                                                                                          self.personalBioLabel.font}
                                                                            context:nil].size;
            return MAX(60, expectedSize.height + 20);
            
            }
            else if (IS_IPHONE_6){
                [self.personalBioLabel setPreferredMaxLayoutWidth:230 + 55];
                CGSize expectedSize = [self.personalBioLabel.text boundingRectWithSize:CGSizeMake(230 + 45, 10000)
                                                                                options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                             attributes:@{NSFontAttributeName:
                                                                                              self.personalBioLabel.font}
                                                                                context:nil].size;
                return MAX(60, expectedSize.height + 20);
                
            }
            else if (IS_IPHONE_6_PLUS){
                [self.personalBioLabel setPreferredMaxLayoutWidth:230 + 95];
                CGSize expectedSize = [self.personalBioLabel.text boundingRectWithSize:CGSizeMake(230 + 94, 10000)
                                                                                options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                             attributes:@{NSFontAttributeName:
                                                                                              self.personalBioLabel.font}
                                                                                context:nil].size;
                return MAX(60, expectedSize.height + 20);
                
            }
            return 60;
        }
            break;
            
            //fav strain
        case 3:{
            NSString *field0 = [NSString stringWithFormat:@"1. %@", sixPeople[0]];
            NSString *field1 = [NSString stringWithFormat:@"2. %@", sixPeople[1]];
            NSString *field2 = [NSString stringWithFormat:@"3. %@", sixPeople[2]];
            NSString *field3 = [NSString stringWithFormat:@"4. %@", sixPeople[3]];
            NSString *field4 = [NSString stringWithFormat:@"5. %@", sixPeople[4]];
            NSString *field5 = [NSString stringWithFormat:@"6. %@", sixPeople[5]];

            
            NSArray *stringsArray = [[NSArray alloc] initWithObjects:field0, field1, field2, field3, field4, field5, nil];
            NSString *joinedString = [stringsArray componentsJoinedByString:@" \r\n"];

            self.sixStonersInHeaven.text = joinedString;
            [self.sixStonersInHeaven setPreferredMaxLayoutWidth:230];
        if(IS_IPHONE_5){
            CGSize expectedSize = [self.sixStonersInHeaven.text boundingRectWithSize:CGSizeMake(230, 10000)
                                                                         options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                      attributes:@{NSFontAttributeName:
                                                                                       self.sixStonersInHeaven.font}
                                                                         context:nil].size;
            return MAX(60, expectedSize.height + 20);
            
        }
            else if (IS_IPHONE_6){
                [self.sixStonersInHeaven setPreferredMaxLayoutWidth:230 + 55];
                CGSize expectedSize = [self.sixStonersInHeaven.text boundingRectWithSize:CGSizeMake(230 + 45, 10000)
                                                                             options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                          attributes:@{NSFontAttributeName:
                                                                                           self.sixStonersInHeaven.font}
                                                                             context:nil].size;
                return MAX(60, expectedSize.height + 20);
                
            }
            else if (IS_IPHONE_6_PLUS){
                [self.sixStonersInHeaven setPreferredMaxLayoutWidth:230 + 95];
                CGSize expectedSize = [self.sixStonersInHeaven.text boundingRectWithSize:CGSizeMake(230 + 94, 10000)
                                                                                options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                             attributes:@{NSFontAttributeName:
                                                                                              self.sixStonersInHeaven.font}
                                                                                context:nil].size;
                return MAX(60, expectedSize.height + 20);
                
            }
            return 60;
            
        }
            break;
    
//        case 2:{
//
//        }
        case 2:{
            if (IS_IPHONE_5) {
                [self.educationLabel setPreferredMaxLayoutWidth:230];
                CGSize expectedSize = [self.educationLabel.text boundingRectWithSize:CGSizeMake(230, 10000)
                                                                                 options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                              attributes:@{NSFontAttributeName:
                                                                                               self.educationLabel.font}
                                                                                 context:nil].size;
                return MAX(60, expectedSize.height + 20);
                
            }
            else if (IS_IPHONE_6){
                [self.educationLabel setPreferredMaxLayoutWidth:230 + 55];
                CGSize expectedSize = [self.educationLabel.text boundingRectWithSize:CGSizeMake(230 + 45, 10000)
                                                                                 options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                              attributes:@{NSFontAttributeName:
                                                                                               self.educationLabel.font}
                                                                                 context:nil].size;
                return MAX(60, expectedSize.height + 20);
                
            }
            else if (IS_IPHONE_6_PLUS){
                [self.educationLabel setPreferredMaxLayoutWidth:230 + 95];
                CGSize expectedSize = [self.userLocationLabel.text boundingRectWithSize:CGSizeMake(230 + 94, 10000)
                                                                                 options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                              attributes:@{NSFontAttributeName:
                                                                                               self.educationLabel.font}
                                                                                 context:nil].size;
                return MAX(60, expectedSize.height + 20);
                
            }
            return 60;
        }
//        case 4:{
//            return 260;
//        }
            
        default:
            return 60;
    }
    return 60;
}

//////////////////////////////////////////////////////////////////////////////////////////// STUFF WITH IMAGES ////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//
-(IBAction)removeImage:(UIButton*)sender{
    isPageEdited = YES;
    [self.photoCellContentView viewWithTag:sender.tag].hidden = YES;
    long i = sender.tag - 1000;
    //if (((PFImageView*)[self.photoCellContentView viewWithTag:(i + 111)]).file != nil) {
    
    switch (i) {
        case 0:
            self.addImage0.file = nil;
            self.addImage0.image = [UIImage imageNamed:@"bfa_plus-square_simple-green_128x128.png"];
            break;
        case 1:
            self.addImage1.file = nil;
            self.addImage1.image = [UIImage imageNamed:@"bfa_plus-square_simple-green_128x128.png"];
            break;
        case 2:
            self.addImage2.file = nil;
            self.addImage2.image = [UIImage imageNamed:@"bfa_plus-square_simple-green_128x128.png"];
            break;
        case 3:
            self.addImage3.file = nil;
            self.addImage3.image = [UIImage imageNamed:@"bfa_plus-square_simple-green_128x128.png"];
            break;
        case 4:
            self.addImage4.file = nil;
            self.addImage4.image = [UIImage imageNamed:@"bfa_plus-square_simple-green_128x128.png"];
            break;
        case 5:
            self.addImage5.file = nil;
            self.addImage5.image = [UIImage imageNamed:@"bfa_plus-square_simple-green_128x128.png"];
            break;
        default:
            break;
    }
    
    BOOL breakOut = NO;
    PFFile* imageFile;
    for (int x = 0; x < 6; x++) {
        switch (x) {
            case 0:{
                if (breakOut == NO) {
                    imageFile = self.addImage0.file;
                    breakOut = YES;
                    break;
                }
            }
            case 1:{
                if (breakOut == NO) {
                    imageFile = self.addImage1.file;
                    breakOut = YES;
                    break;
                }
            }
            case 2:{
                if (breakOut == NO) {
                    imageFile = self.addImage2.file;
                    breakOut = YES;
                    break;
                }
            }
            case 3:{
                if (breakOut == NO) {
                    imageFile = self.addImage3.file;
                    breakOut = YES;
                    break;
                }
            }
            case 4:{
                if (breakOut == NO) {
                    imageFile = self.addImage4.file;
                    breakOut = YES;
                    break;
                }
                break;
            }
            case 5:{
                if (breakOut == NO) {
                    imageFile = self.addImage5.file;
                    breakOut = YES;
                    break;
                }
                break;
            }
            default:
                break;
        }
    }
    
    PFUser *user = [PFUser currentUser];
    PFQuery *imageQuery = [PFQuery queryWithClassName:@"Photo"];
    [imageQuery whereKey:@"user" equalTo:user];
    [imageQuery whereKey:@"photo" equalTo:[imageFile name]];
    [imageQuery orderByAscending:@"rank"];
    [imageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *err){
        if (objects.count != 0) {
            
            for (PFObject *images in objects) {
                [images deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(succeeded){
                        NSLog(@"anything");
                    }
                }];
            }
        }
    }];
        //((PFImageView*)[self.photoCellContentView viewWithTag:(i + 111)]).file = nil;
        //now we want to left shift all of the images (if there are any after the one we jsut removed) by 1
//        for(int j = (int)i + 111 ; j < 117; j++){
//            if(((PFImageView*)[self.photoCellContentView viewWithTag:(j)]).file != nil){
//                
//                ((PFImageView*)[self.photoCellContentView viewWithTag:(j)]).file = ((PFImageView*)[self.photoCellContentView viewWithTag:(j+1)]).file;
//                [((PFImageView*)[self.photoCellContentView viewWithTag:(j)]) loadInBackground];
//                ((PFImageView*)[self.photoCellContentView viewWithTag:(j+1)]).file = nil;
//                ((PFImageView*)[self.photoCellContentView viewWithTag:(j+1)]).image = [UIImage imageNamed:@"bfa_plus-square_simple-green_128x128.png"];
//                [self.photoCellContentView viewWithTag:(j - 111 + 1000)].hidden = NO;
//                
//            }
//            else{
//                ((PFImageView*)[self.photoCellContentView viewWithTag:(i + 111)]).image = [UIImage imageNamed:@"bfa_plus-square_simple-green_128x128.png"];
//                sender.hidden = YES;
//            }
//        }

    //}
}

-(IBAction)addImagePressed:(UIButton*)sender{
    isPageEdited = YES;

    [self addImage:sender];
    //self.pickedImage = sender.tag - 100; //getting the wrong int value?
}


//we can delay the saving stuff until the DoneButtonPress
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [ProgressHUD show:@"Please wait..."];
    
    UIImage *editedImage, *imageToSave;
 
        editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
    
        if (editedImage) {
            imageToSave = editedImage;
            PFFile* imageFile = [PFFile fileWithName:[self randomStringWithLength:10] data:UIImagePNGRepresentation(imageToSave)];
            PFObject *userPhoto = [PFObject objectWithClassName:@"Photo"];
            [userPhoto setObject:imageFile forKey:@"photo"];
            PFUser *user = [PFUser currentUser];
            [userPhoto setObject:user forKey:@"user"];
            
            for (int button = 1000; button < 1006; button++) {
                if ([self.photoCellContentView viewWithTag:button].hidden == YES) {
                    [userPhoto setObject:@((button-999)) forKey:@"rank"];
                    break;
                }
            }
        
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    
                BOOL breakOut = NO;
                for (int i = 0; i < 6; i++) {
                    switch (i) {
                        case 0:
                            if(self.addImage0.file == nil && breakOut == NO){
                                self.addImage0.file = imageFile;
                                self.addImage0.layer.cornerRadius = 8;
                                self.addImage0.layer.masksToBounds = YES;
                                [self.addImage0 loadInBackground];
                                [ProgressHUD showSuccess:@"Saved."];
                                [self.imagePick popToRootViewControllerAnimated:NO];
                                [self.imagePick dismissViewControllerAnimated:NO completion:nil];
                                [self.photoCellContentView viewWithTag:1000].hidden = NO;
                                breakOut = YES;
                            }
                            break;
                        case 1:
                            if(self.addImage1.file == nil && breakOut == NO){
                                self.addImage1.file = imageFile;
                                self.addImage1.layer.cornerRadius = 8;
                                self.addImage1.layer.masksToBounds = YES;
                                [self.addImage1 loadInBackground];
                                [ProgressHUD showSuccess:@"Saved."];
                                [self.imagePick popToRootViewControllerAnimated:NO];
                                [self.imagePick dismissViewControllerAnimated:NO completion:nil];
                                [self.photoCellContentView viewWithTag:1001].hidden = NO;
                                breakOut = YES;
                            }
                            break;
                        case 2:
                            if(self.addImage2.file == nil && breakOut == NO){
                                self.addImage2.file = imageFile;
                                self.addImage2.layer.cornerRadius = 8;
                                self.addImage2.layer.masksToBounds = YES;
                                [self.addImage2 loadInBackground];
                                [ProgressHUD showSuccess:@"Saved."];
                                [self.imagePick popToRootViewControllerAnimated:NO];
                                [self.imagePick dismissViewControllerAnimated:NO completion:nil];
                                [self.photoCellContentView viewWithTag:1002].hidden = NO;
                                breakOut = YES;
                            }
                            break;
                        case 3:
                            if(self.addImage3.file == nil && breakOut == NO){
                                self.addImage3.file = imageFile;
                                self.addImage3.layer.cornerRadius = 8;
                                self.addImage3.layer.masksToBounds = YES;
                                [self.addImage3 loadInBackground];
                                [ProgressHUD showSuccess:@"Saved."];
                                [self.imagePick popToRootViewControllerAnimated:NO];
                                [self.imagePick dismissViewControllerAnimated:NO completion:nil];
                                [self.photoCellContentView viewWithTag:1003].hidden = NO;
                                breakOut = YES;
                            }
                            break;
                        case 4:
                            if(self.addImage4.file == nil && breakOut == NO){
                                self.addImage4.file = imageFile;
                                self.addImage4.layer.cornerRadius = 8;
                                self.addImage4.layer.masksToBounds = YES;
                                [self.addImage4 loadInBackground];
                                [ProgressHUD showSuccess:@"Saved."];
                                [self.imagePick popToRootViewControllerAnimated:NO];
                                [self.imagePick dismissViewControllerAnimated:NO completion:nil];
                                [self.photoCellContentView viewWithTag:1004].hidden = NO;
                                breakOut = YES;
                            }
                            break;
                        case 5:
                            if(self.addImage5.file == nil && breakOut == NO){
                                self.addImage5.file = imageFile;
                                self.addImage5.layer.cornerRadius = 8;
                                self.addImage5.layer.masksToBounds = YES;
                                [self.addImage5 loadInBackground];
                                [ProgressHUD showSuccess:@"Saved."];
                                [self.imagePick popToRootViewControllerAnimated:NO];
                                [self.imagePick dismissViewControllerAnimated:NO completion:nil];
                                [self.photoCellContentView viewWithTag:1005].hidden = NO;
                                breakOut = YES;
                                break;
                            }
                        default:
                            break;
                    }
                }
             
                }
                else{
                    [ProgressHUD showError:@"Could not save"];
                }
            }];
             //progressBlock:<#^(int percentDone)progressBlock#>
            
            
//            NSArray *photosArray = [[NSArray alloc]initWithObjects:self.addImage0, self.addImage1, self.addImage2, self.addImage3, self.addImage4, self.addImage5, nil];
//            for (PFImageView* imageView in photosArray) {
//                if (imageView.file == nil) {
//                    imageView.image = nil;
//                    imageView.file = imageFile;
//                    [imageView loadInBackground];
//                    [ProgressHUD showSuccess:@"Saved."];
//                    [self.imagePick popToRootViewControllerAnimated:NO];
//                    [self.imagePick dismissViewControllerAnimated:NO completion:nil];
//                    break;
//                }
//            }
            
            
        }
        else{
            [ProgressHUD showError:@"Could not save"];
            [self.imagePick popToRootViewControllerAnimated:NO];
            [self.imagePick dismissViewControllerAnimated:NO completion:nil];
        }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)addImage:(UIButton*)tappedView{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Your Photo Source to use the Photo Editor"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Photo Library", @"Add from Facebook", nil];
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            self.imagePick = [[UIImagePickerController alloc]init];
            self.imagePick.sourceType =  UIImagePickerControllerSourceTypeCamera;
            self.imagePick.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            self.imagePick.allowsEditing = YES;
            self.imagePick.delegate = self;
            [self presentViewController:self.imagePick animated:YES completion:nil];
            break;
        }
        case 1:{
            self.imagePick = [[UIImagePickerController alloc]init];
            self.imagePick.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
            self.imagePick.allowsEditing = YES;
            self.imagePick.delegate = self;
            [self presentViewController:self.imagePick animated:YES completion:nil];
            break;
        }
        case 2:{
            
        }
        default:
            break;
    }
}

//- (IBAction)favoriteWaysToMedicateButtonToggled:(UIButton*)sender {
//    isPageEdited = YES;
//
//    if(sender.alpha == .5){
//        sender.alpha = 1;
//        for (int i = 1; i < 9; i++) {
//            if(sender.tag == i){
//                [self.toolsContentView viewWithTag:(i*11)].alpha = 1;
//                [favoriteTools replaceObjectAtIndex:i withObject:@YES];
//            }
//        }
//    }
//    else{
//        sender.alpha = .5;
//        for (int i = 1; i < 9; i++) {
//            if(sender.tag == i){
//                [self.toolsContentView viewWithTag:(i*11)].alpha = .5;
//                [favoriteTools replaceObjectAtIndex:i withObject:@NO];
//            }
//        }
//    }
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.section == 2){
//        NSLog(@"cell selected");
//        
//        DoActionSheet *vActionSheet = [[DoActionSheet alloc] init];
//        vActionSheet.nAnimationType = 2;
//        vActionSheet.dButtonRound = 0;
//        vActionSheet.nContentMode = 2;
//        vActionSheet.doBackColor = [UIColor clearColor];
//        vActionSheet.doButtonColor = [UIColor colorWithRed:0.086 green:0.627 blue:0.522 alpha:1];
//        
//        [vActionSheet showC:nil//@"Select your favorite strain of weed"
//                     cancel:@"Cancel"
//                    buttons:@[@"Indica", @"Sativa", @"Hybrid", @"Don't Care"]
//                     result:^(int nResult) {
//                         
//                         NSLog(@"---------------> result : %d", nResult);
//                         
//                         switch (nResult) {
//                                 //save a number when done to the db (0 -> 3, indicating your choice)
//                             case 0:
//                                 self.favoriteStrainImage.image = [UIImage imageNamed:@"indica_burned.png"];
//                                 self.favoriteTypeLabel.text = @"Indica";
//                                 self.favoriteTypeLabel.text = @"Indica: You're someone who likes to chill. The full body effects of the indica are relaxing for you after a full day's worth of work.";
//                                 [self saveFavoriteStrain:0];
//                                 break;
//                             case 1:
//                                 self.favoriteStrainImage.image = [UIImage imageNamed:@"rsz_1rsz_1sativa.png"];
//                                 self.favoriteTypeLabel.text = @"Sativa: You're someone who likes to be active and in the moment. You embrace the uplifing elements of the strain and you like to feel the creative juices flow.";
//                                 [self saveFavoriteStrain:1];
//                                 break;
//                             case 2:
//                                 self.favoriteStrainImage.image = [UIImage imageNamed:@"hybrid_burned.png"];
//                                 self.favoriteTypeLabel.text = @"Hybrid";
//                                 self.favoriteTypeLabel.text = @"Hybrid: You're a bit of a scientist. You experiement with different strains until you're satisfied with a perfect balance of indica and sativa.";
//                                 [self saveFavoriteStrain:2];
//                                 break;
//                             case 3:
//                                 self.favoriteTypeLabel.text = @"Whatever my friends have: You'll fill your bowl with anything you can find. Any weed is good weed for you";
//                                 [self saveFavoriteStrain:3];
//                                 break;
//                             case 4:
//                                 
//                             default:
//                                 break;
//                         }
//                         [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//                     }];
//    }
//    
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:@"one"]) {
        ((ComposeContentViewController *)segue.destinationViewController).senderCellNumber = [NSNumber numberWithInt:1];
        ((ComposeContentViewController *)segue.destinationViewController).placeholderString = self.personalBioLabel.text;
    }
    else if ([segue.identifier isEqualToString:@"education"]) {
        ((ComposeContentViewController *)segue.destinationViewController).senderCellNumber = [NSNumber numberWithInt:5];
        ((ComposeContentViewController *)segue.destinationViewController).placeholderString = self.educationLabel.text;
    }
//    else if ([segue.identifier isEqualToString:@"location"]) {
//        ((ComposeContentViewController *)segue.destinationViewController).senderCellNumber = [NSNumber numberWithInt:6];
//    }
    
}

///////////////////////////////////////////////////////////////////// STUFF WITH SAVING ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//-(void)saveFavoriteWaysToGetHigh{
//    
//    PFQuery *userQuery = [PFQuery queryWithClassName:@"UserProfile"];
//    [userQuery whereKey:@"user" equalTo:[PFUser currentUser]];
//    userQuery.limit = 1;
//    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *err){
//        if (objects.count != 0) {
//                PFObject *userObj = objects[0];
//                userObj[@"favoriteTools"] = favoriteTools;
//                [userObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                    if (!error) {
//                        [ProgressHUD showSuccess:@"Saved."];
//                    }
//                    else{
//                        // Log details of the failure
//                        NSLog(@"Error: %@ %@", error, [error userInfo]);
//                    }
//                }];
//            }
//        }];
//}

//-(void)saveFavoriteStrain:(int)strainOfChoice{
//
//    [PFUser currentUser][@"favoriteStrain"] = @(strainOfChoice);
//    [[PFUser currentUser] saveInBackground];
//}


-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}

//done button pressed
- (IBAction)saveEverything:(id)sender {
    
//    if(isPageEdited){
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You have some unsaved changed"
//                                                            message:@"Do you want to save them?"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"No"
//                                                  otherButtonTitles:@"Yes", nil];
//        [alertView show];
//    }
//    else{
//        //if page isnt edited, just pop
        [self.navigationController popViewControllerAnimated:YES];
//    }
}
                                  
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
//        //save favWaysToGetHigh
//        [self saveFavoriteWaysToGetHigh];
//        
//        //save favoriteStrain
//
//        //save photos
//        [self savePhotos];
//        
//        //you dont have to worry about saving all of the descriptions. those will be saved when the user clicks on the "Save" button on each of those pages, respectively
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
                                  
@end
