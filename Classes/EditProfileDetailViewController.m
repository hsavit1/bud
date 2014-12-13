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

@interface EditProfileDetailViewController ()<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>{
    NSMutableArray *profilePicsArray;
    NSArray *removeButtons;
    NSMutableArray *favoriteTools;
    BOOL isPageEdited;
    MBProgressHUD *HUD;
    MBProgressHUD *refreshHUD;
}

@property (strong, nonatomic) UIImagePickerController *imagePick;
@property (weak, nonatomic) NSNumber *pickedImage;
@property (weak, nonatomic) NSNumber *lastPickedImage;
@property (weak, nonatomic) IBOutlet UIView *photoCellContentView;
//
//@property (strong, nonatomic) PFImageView *addImage6;
//@property (strong, nonatomic) UIButton *removeImage6;
//@property (strong, nonatomic) UIButton *addImage6Buttom;

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
    
    for (int i = 100; i < 106; i++) {
        [self.photoCellContentView viewWithTag:i].layer.cornerRadius = 8;
        [self.photoCellContentView viewWithTag:i].layer.masksToBounds = YES;
        [self.photoCellContentView viewWithTag:i].layer.borderColor = [UIColor colorWithRed:0.086 green:0.627 blue:0.522 alpha:1].CGColor; /*#16a085*/
        [self.photoCellContentView viewWithTag:i].layer.borderWidth = 3;
    }
    
    for (int i = 1000; i < 1006; i++) {
        [self.photoCellContentView viewWithTag:i].layer.cornerRadius = [self.photoCellContentView viewWithTag:i].frame.size.width / 2;
        [self.photoCellContentView viewWithTag:i].layer.masksToBounds = YES;
    }
    
    PFUser *user = [PFUser currentUser];
        PFQuery *imageQuery = [PFQuery queryWithClassName:@"Photo"];
        [imageQuery whereKey:@"user" equalTo:user];
        imageQuery.limit = 6;
        [imageQuery orderByAscending:@"rank"];
        [imageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *err){
            if (objects.count != 0) {
                
                for (int i = 0; i < objects.count; i++) {
                    if(objects[i][@"photo"]){
                        ((PFImageView*)[self.photoCellContentView viewWithTag:(i+111)]).layer.cornerRadius = 9;
                        ((PFImageView*)[self.photoCellContentView viewWithTag:(i+111)]).layer.masksToBounds = YES;
                        ((UIImageView *)[self.photoCellContentView viewWithTag:(i+111)]).contentMode = UIViewContentModeScaleAspectFill;
                        ((PFImageView*)[self.photoCellContentView viewWithTag:(i+111)]).file = objects[i][@"photo"];
                        [((PFImageView*)[self.photoCellContentView viewWithTag:(i+111)]) loadInBackground];
                        [profilePicsArray addObject:((PFImageView*)[self.photoCellContentView viewWithTag:(i+111)])];
                    }
                    else{
                        [self.photoCellContentView viewWithTag:(i + 1000)].hidden = YES;
                    }
                }
            }
        }];
    
    //profilePicsArray = @[self.addImage0, self.addImage1, self.addImage2, self.addImage3, self.addImage4, self.addImage5];
    //removeButtons = @[self.removeImage0, self.removeImage1, self.removeImage2, self.removeImage3, self.removeImage4, self.removeImage5];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 189;
            break;
        case 1:{
            NSString *string = [PFUser currentUser][@"bioDescription"];
            self.personalBioLabel.text = string;
            
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
        case 4:{
//            NSString *field0 = [NSString stringWithFormat:@"1. %@", [PFUser currentUser][@"SixPeople"][@"person0"]];
//            NSString *field1 = [NSString stringWithFormat:@"2. %@", [PFUser currentUser][@"SixPeople"][@"person1"]];
//            NSString *field2 = [NSString stringWithFormat:@"3. %@", [PFUser currentUser][@"SixPeople"][@"person2"]];
//            NSString *field3 = [NSString stringWithFormat:@"4. %@", [PFUser currentUser][@"SixPeople"][@"person3"]];
//            NSString *field4 = [NSString stringWithFormat:@"5. %@", [PFUser currentUser][@"SixPeople"][@"person4"]];
//            NSString *field5 = [NSString stringWithFormat:@"6. %@", [PFUser currentUser][@"SixPeople"][@"person5"]];
//            
//            
//            NSArray *stringsArray = [[NSArray alloc] initWithObjects:field0, field1, field2, field3, field4, field5, nil];
//            NSString *joinedString = [stringsArray componentsJoinedByString:@" \r\n"];
//
//            self.sixStonersInHeaven.text = joinedString;
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
    
        case 2:{
            NSString *string = [PFUser currentUser][@"favoriteType"];
            self.favoriteTypeLabel.text = string;
            if (IS_IPHONE_5) {
                [self.favoriteTypeLabel setPreferredMaxLayoutWidth:230];
                CGSize expectedSize = [self.favoriteTypeLabel.text boundingRectWithSize:CGSizeMake(230, 10000)
                                                                             options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                          attributes:@{NSFontAttributeName:
                                                                                           self.favoriteTypeLabel.font}
                                                                             context:nil].size;
                return MAX(100, expectedSize.height + 20);
                
            }
            else if (IS_IPHONE_6){
                [self.favoriteTypeLabel setPreferredMaxLayoutWidth:230 + 55];
                CGSize expectedSize = [self.favoriteTypeLabel.text boundingRectWithSize:CGSizeMake(230 + 45, 10000)
                                                                             options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                          attributes:@{NSFontAttributeName:
                                                                                           self.favoriteTypeLabel.font}
                                                                             context:nil].size;
                return MAX(100, expectedSize.height + 20);
                
            }
            else if (IS_IPHONE_6_PLUS){
                [self.favoriteTypeLabel setPreferredMaxLayoutWidth:230 + 95];
                CGSize expectedSize = [self.favoriteTypeLabel.text boundingRectWithSize:CGSizeMake(230 + 94, 10000)
                                                                                options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                             attributes:@{NSFontAttributeName:
                                                                                              self.favoriteTypeLabel.font}
                                                                                context:nil].size;
                return MAX(80, expectedSize.height + 20);
            }
            return 80;
        }
        case 3:{
            NSString *string = [PFUser currentUser][@"education"];
            self.educationLabel.text = string;
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
//        case 2:{
//            NSString *string = [PFUser currentUser][@"location"];
//            self.userLocationLabel.text = string;
//            if (IS_IPHONE_5) {
//                [self.userLocationLabel setPreferredMaxLayoutWidth:230];
//                CGSize expectedSize = [self.userLocationLabel.text boundingRectWithSize:CGSizeMake(230, 10000)
//                                                                             options:(NSStringDrawingUsesLineFragmentOrigin)
//                                                                          attributes:@{NSFontAttributeName:
//                                                                                           self.userLocationLabel.font}
//                                                                             context:nil].size;
//                return MAX(60, expectedSize.height + 20);
//                
//            }
//            else if (IS_IPHONE_6){
//                [self.userLocationLabel setPreferredMaxLayoutWidth:230 + 55];
//                CGSize expectedSize = [self.userLocationLabel.text boundingRectWithSize:CGSizeMake(230 + 45, 10000)
//                                                                             options:(NSStringDrawingUsesLineFragmentOrigin)
//                                                                          attributes:@{NSFontAttributeName:
//                                                                                           self.userLocationLabel.font}
//                                                                             context:nil].size;
//                return MAX(60, expectedSize.height + 20);
//                
//            }
//            else if (IS_IPHONE_6_PLUS){
//                [self.userLocationLabel setPreferredMaxLayoutWidth:230 + 95];
//                CGSize expectedSize = [self.userLocationLabel.text boundingRectWithSize:CGSizeMake(230 + 94, 10000)
//                                                                             options:(NSStringDrawingUsesLineFragmentOrigin)
//                                                                          attributes:@{NSFontAttributeName:
//                                                                                           self.userLocationLabel.font}
//                                                                             context:nil].size;
//                return MAX(60, expectedSize.height + 20);
//                
//            }
//            return 60;
//        }
//        break;
//         
        case 5:{
            return 260;
        }
            
            
        default:
            return 60;
    }
    return 60;
}

//////////////////////////////////////////////////////////////////////////////////////////// STUFF WITH IMAGES ////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


-(IBAction)removeImage:(UIButton*)sender{
    isPageEdited = YES;
    
    long i = sender.tag - 1000;
    //now we want to left shift all of the images (if there are any after the one we jsut removed) by 1
    for(int k = 0; k < 6; k++){
        if (((PFImageView*)[self.photoCellContentView viewWithTag:(i + 1000)]).file != nil) {
            NSLog(@"empty image file");
            //((PFImageView*)[self.photoCellContentView viewWithTag:(i + 1000)]).file
            
            
        }
    }
    
    [profilePicsArray[i] setImage:[UIImage imageNamed:@"bfa_plus-square_simple-green_128x128.png"]];
    ((PFImageView*)profilePicsArray[i]).file = nil;
    ((UIButton*)removeButtons[i]).hidden = YES;

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
            PFFile* imageFile = [PFFile fileWithName:@"profilePic" data:UIImagePNGRepresentation(imageToSave)];
            [imageFile saveInBackground];
            
            //now cycle through all of your image tags and save the image to the first open tag
            for(int i = 111; i < 117; i++){
                if(((PFImageView*)[self.photoCellContentView viewWithTag:i]).file == nil){
                    ((PFImageView*)[self.photoCellContentView viewWithTag:i]).file = imageFile;
                    [((PFImageView*)[self.photoCellContentView viewWithTag:i]) loadInBackground];
                    [ProgressHUD showSuccess:@"Saved."];
                    [self.imagePick popToRootViewControllerAnimated:NO];
                    [self.imagePick dismissViewControllerAnimated:NO completion:nil];
                    break;
                }
            }
            
//            PFUser* usr = [PFUser currentUser];
//            for(int i = 0; i < profilePicsArray.count; i++){
//                
//                if( ((PFImageView*)profilePicsArray[i]).file == nil ){
//                    [profilePicsArray[i] setImage:imageToSave];//[self addImage:sender];
//                    [profilePicsArray[i] setFile:imageFile];
//                    NSString *save = [@"image" stringByAppendingString:[NSString stringWithFormat:@"%d", i]];
//                    usr[save] = imageFile;
//                    [usr saveInBackgroundWithBlock:^(BOOL succeeded, NSError* err){
//                        if(!succeeded){
//                            [ProgressHUD showError:@"Network Error"];
//                            [self.imagePick popToRootViewControllerAnimated:NO];
//                            [self.imagePick dismissViewControllerAnimated:NO completion:nil];
//                        }
//                        else{
//                            ((UIButton*)removeButtons[i]).hidden = NO;
//                            [ProgressHUD showSuccess:@"Saved."];
//                            [self.imagePick popToRootViewControllerAnimated:NO];
//                            [self.imagePick dismissViewControllerAnimated:NO completion:nil];
//                        }
//                    }];
//                    break;
//                }
//    
//            }
            
//            [profilePicsArray[[self.pickedImage integerValue]] setImage:imageToSave];//[self addImage:sender];
//            [profilePicsArray[[self.pickedImage integerValue]] setFile:imageFile];
//            NSString *save = [@"image" stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)[self.pickedImage integerValue]]];
//            usr[save] = imageFile;
//            [usr saveInBackgroundWithBlock:^(BOOL succeeded, NSError* err){
//                if(!succeeded){
//                    [ProgressHUD showError:@"Network Error"];
//                    [self.imagePick popToRootViewControllerAnimated:NO];
//                    [self.imagePick dismissViewControllerAnimated:NO completion:nil];
//                }
//                else{
//                    [ProgressHUD showSuccess:@"Saved."];
//                    ((UIButton*)removeButtons[[self.pickedImage integerValue]]).hidden = NO;
//                    [self.imagePick popToRootViewControllerAnimated:NO];
//                    [self.imagePick dismissViewControllerAnimated:NO completion:nil];
//                }
//            }];

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
                                                    otherButtonTitles:@"Take Photo", @"Photo Library", nil];
    
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
        default:
            break;
    }
}

- (IBAction)favoriteWaysToMedicateButtonToggled:(UIButton*)sender {
    isPageEdited = YES;

    if(sender.alpha == .5){
        sender.alpha = 1;
        for (int i = 1; i < 10; i++) {
            if(sender.tag == i){
                [self.view viewWithTag:(i*11)].alpha = 1;
                [favoriteTools replaceObjectAtIndex:0 withObject:@YES];
            }
        }
    }
    else{
        sender.alpha = .5;
        for (int i = 1; i < 10; i++) {
            if(sender.tag == i){
                [self.view viewWithTag:(i*11)].alpha = .5;
                [favoriteTools replaceObjectAtIndex:0 withObject:@NO];
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 2){
        NSLog(@"cell selected");
        
        DoActionSheet *vActionSheet = [[DoActionSheet alloc] init];
        vActionSheet.nAnimationType = 2;
        vActionSheet.dButtonRound = 0;
        vActionSheet.nContentMode = 2;
        vActionSheet.doBackColor = [UIColor clearColor];
        vActionSheet.doButtonColor = [UIColor colorWithRed:0.086 green:0.627 blue:0.522 alpha:1];
        
        [vActionSheet showC:nil//@"Select your favorite strain of weed"
                     cancel:@"Cancel"
                    buttons:@[@"Indica", @"Sativa", @"Hybrid", @"Don't Care"]
                     result:^(int nResult) {
                         
                         NSLog(@"---------------> result : %d", nResult);
                         
                         switch (nResult) {
                                 //save a number when done to the db (0 -> 3, indicating your choice)
                             case 0:
                                 self.favoriteStrainImage.image = [UIImage imageNamed:@"indica_burned.png"];
                                 self.favoriteTypeLabel.text = @"Indica";
                                 self.favoriteTypeLabel.text = @"Indica: You're someone who likes to chill. The full body effects of the indica are relaxing for you after a full day's worth of work.";
                                 [self saveFavoriteStrain:0];
                                 break;
                             case 1:
                                 self.favoriteStrainImage.image = [UIImage imageNamed:@"rsz_1rsz_1sativa.png"];
                                 self.favoriteTypeLabel.text = @"Sativa: You're someone who likes to be active and in the moment. You embrace the uplifing elements of the strain and you like to feel the creative juices flow.";
                                 [self saveFavoriteStrain:1];
                                 break;
                             case 2:
                                 self.favoriteStrainImage.image = [UIImage imageNamed:@"hybrid_burned.png"];
                                 self.favoriteTypeLabel.text = @"Hybrid";
                                 self.favoriteTypeLabel.text = @"Hybrid: You're a bit of a scientist. You experiement with different strains until you're satisfied with a perfect balance of indica and sativa.";
                                 [self saveFavoriteStrain:2];
                                 break;
                             case 3:
                                 self.favoriteTypeLabel.text = @"Whatever my friends have: You'll fill your bowl with anything you can find. Any weed is good weed for you";
                                 [self saveFavoriteStrain:3];
                                 break;
                             case 4:
                                 
                             default:
                                 break;
                         }
                         [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                     }];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:@"one"]) {
        ((ComposeContentViewController *)segue.destinationViewController).senderCellNumber = [NSNumber numberWithInt:1];
    }
    else if ([segue.identifier isEqualToString:@"education"]) {
        ((ComposeContentViewController *)segue.destinationViewController).senderCellNumber = [NSNumber numberWithInt:5];
    }
    else if ([segue.identifier isEqualToString:@"location"]) {
        ((ComposeContentViewController *)segue.destinationViewController).senderCellNumber = [NSNumber numberWithInt:6];
    }
    
}

///////////////////////////////////////////////////////////////////// STUFF WITH SAVING ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)saveFavoriteWaysToGetHigh{
    
//    PFQuery *userQuery = [PFQuery queryWithClassName:@"UserProfile"];
//    [userQuery whereKey:@"user" equalTo:[PFUser currentUser]];
//    userQuery.limit = 1;
//    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if(objects.count != 0){
//            [objects[0][@"favortieTools"] addUniqueObjectsFromArray:favoriteTools forKey:@"favoriteTools"];
//        }
//    }];
}

-(void)saveFavoriteStrain:(int)strainOfChoice{
 
    PFQuery *userQuery = [PFQuery queryWithClassName:@"UserProfile"];
    [userQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    userQuery.limit = 1;

    //this needs to be fixed. cant be getting an array
//    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if(objects.count != 0){
//            PFObject *strainChoiceNumber = strainOfChoice;
//            ((PFObject*)objects[0][@"favoriteProduct"]) = strainChoiceNumber;
//            
//        }
//    }];
    
    PFObject *gameScore = [PFObject objectWithClassName:@"UserProfile"];
    gameScore[@"score"] = @1337;
    [gameScore saveInBackground];
}

-(void)savePhotos{
    PFQuery *userQuery = [PFQuery queryWithClassName:@"Photo"];
    [userQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [userQuery orderByAscending:@"rank"];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(objects.count != 0){
            for (int i = 0; i < objects.count; i++) {
                if(((PFImageView*)[self.photoCellContentView viewWithTag:(i+111)]).file != nil){
                    //save image file to parse with the rank
                    PFFile *imageFile = ((PFImageView*)[self.photoCellContentView viewWithTag:(i+111)]).file;
                    // Save PFFile
                    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
                            // Hide old HUD, show completed HUD (see example for code)
                            
                            // Create a PFObject around a PFFile and associate it with the current user
                            PFObject *userPhoto = [PFObject objectWithClassName:@"Photo"];
                            [userPhoto setObject:imageFile forKey:@"photo"];
                            
                            PFUser *user = [PFUser currentUser];
                            [userPhoto setObject:user forKey:@"user"];
                            
                            [userPhoto setObject:i forKey:@"rank"];
                            
                            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (!error) {
                                    //[self refresh:nil];
                                }
                                else{
                                    // Log details of the failure
                                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                                }
                            }];
                        }
                        else{
                            [HUD hide:YES];
                            // Log details of the failure
                            NSLog(@"Error: %@ %@", error, [error userInfo]);
                        }
                    }
                    progressBlock:^(int percentDone) {
                        // Update your progress spinner here. percentDone will be between 0 and 100.
                        HUD.progress = (float)percentDone/100;
                    }];
                
                
                
                
                }
                else{
                    //delete the object from parse
                    //https://parse.com/questions/how-can-i-delete-a-file
//                    // After this, the photo field will be empty
//                    [query removeObjectForKey:@"photo"];
//                    // Saves the field deletion to the Parse Cloud
//                    [query saveInBackground];
                }
            }
        }
    }];
}

//done button pressed
- (IBAction)saveEverything:(id)sender {
    if(isPageEdited){
        //save favWaysToGetHigh
        [self saveFavoriteWaysToGetHigh];
        //save favoriteStrain
        //save photos
        [self savePhotos];
        //you dont have to worry about saving all of the descriptions. those will be saved when the user clicks on the "Save" button on each of those pages, respectively
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        //if page isnt edited, just pop
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
