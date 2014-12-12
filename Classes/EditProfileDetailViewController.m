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

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define IS_IPHONE_6PLUS (IS_IPHONE && [[UIScreen mainScreen] nativeScale] == 3.0f)
#define IS_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0)

@interface EditProfileDetailViewController ()<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    NSArray *profilePicsArray;
    NSArray *removeButtons;
    NSMutableArray *favoriteTools;

}

@property (strong, nonatomic) UIImagePickerController *imagePick;
@property (weak, nonatomic) NSNumber *pickedImage;
@property (weak, nonatomic) NSNumber *lastPickedImage;
@property (weak, nonatomic) IBOutlet UIView *photoCellContentView;

@property (strong, nonatomic) PFImageView *addImage6;
@property (strong, nonatomic) UIButton *removeImage6;
@property (strong, nonatomic) UIButton *addImage6Buttom;

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
    
    
    
    //I want the spacing to be better done in the bigger iPhones. The problem is that this might screw with the autolayout that is already set up. might have to just leave it alone for now
    if(! IS_IPHONE_5){
        
//        self.addImage4.frame = CGRectMake(self.headerView.bounds.size.width/2 - 70, self.addImage4.frame.origin.y, self.addImage4.frame.size.width, self.addImage4.frame.size.height);
//        self.removeImage4.frame = CGRectMake(self.headerView.bounds.size.width/2 - 60, self.addImage4.frame.origin.y, self.addImage4.frame.size.width, self.addImage4.frame.size.height);
//
//        self.addImage6 = [[PFImageView alloc] initWithFrame:CGRectMake((self.addImage5.frame.origin.x - 15), self.addImage5.frame.origin.y, 60, 60)];
//        self.addImage6.layer.cornerRadius = 8;
//        self.addImage6.layer.masksToBounds = YES;
//        self.addImage6.layer.borderColor = [UIColor colorWithRed:0.086 green:0.627 blue:0.522 alpha:1].CGColor; /*#16a085*/
//        self.addImage6.layer.borderWidth = 3;
//        
//        self.addImage6Buttom = [[UIButton alloc]initWithFrame:self.addImage6.frame];
//        [self.addImage6Buttom addTarget:self action:@selector(image7Pressed:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [self.headerView addSubview:self.addImage6];
//        [self.headerView addSubview:self.addImage6Buttom];
        
    }
    
    PFUser *user = [PFUser currentUser];
        PFQuery *imageQuery = [PFQuery queryWithClassName:@"Photo"];
        [imageQuery whereKey:@"user" equalTo:user];
        imageQuery.limit = 6;
        [imageQuery orderByAscending:@"rank"];
        [imageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *err){
            if (objects.count != 0) {
                if(objects[0][@"photo"]){
                    self.addImage0.file = objects[0][@"photo"];
                    [self.addImage0 loadInBackground];
                    self.lastPickedImage = [NSNumber numberWithInt:1];
                }
                else
                    self.removeImage0.hidden = YES;
                
                if(objects.count >= 2){
                    self.addImage1.file = objects[1][@"photo"];
                    [self.addImage1 loadInBackground];
                    self.lastPickedImage = [NSNumber numberWithInt:2];
                }
                else
                    self.removeImage1.hidden = YES;
                
                if(objects.count >= 3){
                    self.addImage2.file = objects[2][@"photo"];
                    [self.addImage2 loadInBackground];
                    self.lastPickedImage = [NSNumber numberWithInt:3];
                }
                else
                    self.removeImage2.hidden = YES;
                
                if(objects.count >= 4){
                    self.addImage3.file = objects[3][@"photo"];
                    [self.addImage3 loadInBackground];
                    self.lastPickedImage = [NSNumber numberWithInt:4];
                }
                else
                    self.removeImage3.hidden = YES;
                
                if(objects.count >= 5){
                    self.addImage4.file = objects[4][@"photo"];
                    [self.addImage4 loadInBackground];
                    self.lastPickedImage = [NSNumber numberWithInt:5];
                }
                else
                    self.removeImage4.hidden = YES;
                
                if(objects.count >= 6){
                    self.addImage5.file = objects[5][@"photo"];
                    [self.addImage5 loadInBackground];
                    self.lastPickedImage = [NSNumber numberWithInt:6];
                }
                else
                    self.removeImage5.hidden = YES;

            }
        }];
    
    profilePicsArray = @[self.addImage0, self.addImage1, self.addImage2, self.addImage3, self.addImage4, self.addImage5];
    removeButtons = @[self.removeImage0, self.removeImage1, self.removeImage2, self.removeImage3, self.removeImage4, self.removeImage5];
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
        case 5:{
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
    
        case 3:{
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
        case 4:{
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
        case 2:{
            NSString *string = [PFUser currentUser][@"location"];
            self.userLocationLabel.text = string;
            if (IS_IPHONE_5) {
                [self.userLocationLabel setPreferredMaxLayoutWidth:230];
                CGSize expectedSize = [self.userLocationLabel.text boundingRectWithSize:CGSizeMake(230, 10000)
                                                                             options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                          attributes:@{NSFontAttributeName:
                                                                                           self.userLocationLabel.font}
                                                                             context:nil].size;
                return MAX(60, expectedSize.height + 20);
                
            }
            else if (IS_IPHONE_6){
                [self.userLocationLabel setPreferredMaxLayoutWidth:230 + 55];
                CGSize expectedSize = [self.userLocationLabel.text boundingRectWithSize:CGSizeMake(230 + 45, 10000)
                                                                             options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                          attributes:@{NSFontAttributeName:
                                                                                           self.userLocationLabel.font}
                                                                             context:nil].size;
                return MAX(60, expectedSize.height + 20);
                
            }
            else if (IS_IPHONE_6_PLUS){
                [self.userLocationLabel setPreferredMaxLayoutWidth:230 + 95];
                CGSize expectedSize = [self.userLocationLabel.text boundingRectWithSize:CGSizeMake(230 + 94, 10000)
                                                                             options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                          attributes:@{NSFontAttributeName:
                                                                                           self.userLocationLabel.font}
                                                                             context:nil].size;
                return MAX(60, expectedSize.height + 20);
                
            }
            return 60;
        }
        break;
         
        case 6:{
            return 260;
        }
            
            
        default:
            return 60;
    }
    return 60;
}


-(IBAction)removeImages:(id)sender{
    for (int i = 100; i < 106; i++) {
        
    }
}



- (IBAction)removeImage0:(id)sender {
    [PFUser currentUser][@"image0"] = [NSNull null];
    [profilePicsArray[0] setImage:[UIImage imageNamed:@"bfa_plus-square_simple-green_128x128.png"]];
    ((PFImageView*)profilePicsArray[0]).file = nil;
    ((UIButton*)removeButtons[0]).hidden = YES;
}
- (IBAction)removeImage1:(id)sender {
    [PFUser currentUser][@"image1"] = [NSNull null];
    [profilePicsArray[1] setImage:[UIImage imageNamed:@"bfa_plus-square_simple-green_128x128.png"]];
    ((PFImageView*)profilePicsArray[1]).file = nil;
    ((UIButton*)removeButtons[1]).hidden = YES;
}
- (IBAction)removeImage2:(id)sender {
    [PFUser currentUser][@"image2"] = [NSNull null];
    [profilePicsArray[2] setImage:[UIImage imageNamed:@"bfa_plus-square_simple-green_128x128.png"]];
    ((PFImageView*)profilePicsArray[2]).file = nil;
    ((UIButton*)removeButtons[2]).hidden = YES;
}
- (IBAction)removeImage3:(id)sender {
    [PFUser currentUser][@"image3"] = [NSNull null];
    [profilePicsArray[3] setImage:[UIImage imageNamed:@"bfa_plus-square_simple-green_128x128.png"]];
    ((PFImageView*)profilePicsArray[3]).file = nil;
    ((UIButton*)removeButtons[3]).hidden = YES;
}
- (IBAction)removeImage4:(id)sender {
    [PFUser currentUser][@"image4"] = [NSNull null];
    [profilePicsArray[4] setImage:[UIImage imageNamed:@"bfa_plus-square_simple-green_128x128.png"]];
    ((PFImageView*)profilePicsArray[4]).file = nil;
    ((UIButton*)removeButtons[4]).hidden = YES;
}
- (IBAction)removeImage5:(id)sender {
    [PFUser currentUser][@"image5"] = [NSNull null];
    [profilePicsArray[5] setImage:[UIImage imageNamed:@"bfa_plus-square_simple-green_128x128.png"]];
    ((PFImageView*)profilePicsArray[5]).file = nil;
    ((UIButton*)removeButtons[5]).hidden = YES;
}





- (IBAction)image1Pressed:(UIButton*)sender {
    [self addImage:sender];
    self.pickedImage = [NSNumber numberWithInt:0];
}
- (IBAction)image2Pressed:(UIButton*)sender {
    [self addImage:sender];
    self.pickedImage = [NSNumber numberWithInt:1];
}
- (IBAction)image3Pressed:(UIButton*)sender {
    [self addImage:sender];
    self.pickedImage = [NSNumber numberWithInt:2];
}
- (IBAction)image4Pressed:(UIButton*)sender {
    [self addImage:sender];
    self.pickedImage = [NSNumber numberWithInt:3];
}
- (IBAction)image5Pressed:(UIButton*)sender {
    [self addImage:sender];
    self.pickedImage = [NSNumber numberWithInt:4];
}
- (IBAction)image6Pressed:(UIButton*)sender {
    [self addImage:sender];
    self.pickedImage = [NSNumber numberWithInt:5];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [ProgressHUD show:@"Please wait..."];
    
    UIImage *editedImage, *imageToSave;
 
        editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
    
        if (editedImage) {
            imageToSave = editedImage;
            PFFile* imageFile = [PFFile fileWithName:@"profilePic" data:UIImagePNGRepresentation(imageToSave)];
            [imageFile saveInBackground];
            
            PFUser* usr = [PFUser currentUser];
            for(int i = 0; i < profilePicsArray.count; i++){
                
                if( ((PFImageView*)profilePicsArray[i]).file == nil ){
                    [profilePicsArray[i] setImage:imageToSave];//[self addImage:sender];
                    [profilePicsArray[i] setFile:imageFile];
                    NSString *save = [@"image" stringByAppendingString:[NSString stringWithFormat:@"%d", i]];
                    usr[save] = imageFile;
                    [usr saveInBackgroundWithBlock:^(BOOL succeeded, NSError* err){
                        if(!succeeded){
                            [ProgressHUD showError:@"Network Error"];
                            [self.imagePick popToRootViewControllerAnimated:NO];
                            [self.imagePick dismissViewControllerAnimated:NO completion:nil];
                        }
                        else{
                            ((UIButton*)removeButtons[i]).hidden = NO;
                            [ProgressHUD showSuccess:@"Saved."];
                            [self.imagePick popToRootViewControllerAnimated:NO];
                            [self.imagePick dismissViewControllerAnimated:NO completion:nil];
                        }
                    }];
                    break;
                }
    
            }
            [profilePicsArray[[self.pickedImage integerValue]] setImage:imageToSave];//[self addImage:sender];
            [profilePicsArray[[self.pickedImage integerValue]] setFile:imageFile];
            NSString *save = [@"image" stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)[self.pickedImage integerValue]]];
            usr[save] = imageFile;
            [usr saveInBackgroundWithBlock:^(BOOL succeeded, NSError* err){
                if(!succeeded){
                    [ProgressHUD showError:@"Network Error"];
                    [self.imagePick popToRootViewControllerAnimated:NO];
                    [self.imagePick dismissViewControllerAnimated:NO completion:nil];
                }
                else{
                    [ProgressHUD showSuccess:@"Saved."];
                    ((UIButton*)removeButtons[[self.pickedImage integerValue]]).hidden = NO;
                    [self.imagePick popToRootViewControllerAnimated:NO];
                    [self.imagePick dismissViewControllerAnimated:NO completion:nil];
                }
            }];

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
    
    DoActionSheet *vActionSheet = [[DoActionSheet alloc] init];
    vActionSheet.nAnimationType = 2;
    vActionSheet.doBackColor = [UIColor whiteColor];
    vActionSheet.doButtonColor = [UIColor colorWithRed:0.086 green:0.627 blue:0.522 alpha:1];
    
    [vActionSheet showC:@"Choose Your Photo Source to use the Photo Editor"
                 cancel:@"Cancel"
                buttons:@[@"Take Photo", @"Photo Library"]
                 result:^(int nResult) {
                     
                     NSLog(@"---------------> result : %d", nResult);
                     
                     switch (nResult) {
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
                             self.imagePick.sourceType =  UIImagePickerControllerSourceTypeCamera;
                             self.imagePick = [[UIImagePickerController alloc]init];
                             self.imagePick.allowsEditing = YES;
                             self.imagePick.delegate = self;
                             [self presentViewController:self.imagePick animated:YES completion:nil];
                             break;
                         }
                        default:
                             break;
                     }
                 }];
}


- (IBAction)buttonTapped:(UIButton*)sender {
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
                [self.view viewWithTag:(i*11)].alpha = 1;
                [favoriteTools replaceObjectAtIndex:0 withObject:@NO];
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 3){
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
                                 self.favoriteTypeLabel.text = @"Hybrid: You're someone in between.";
                                 [self saveFavoriteStrain:2];
                                 break;
                             case 3:
                                 self.favoriteTypeLabel.text = @"Whatever my friends have: You'll fill your bowl with anything you can find. Any weed is good weed for you";
                                 [self saveFavoriteStrain:3];
                                 break;
                             default:
                                 break;
                         }
                         [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                     }];
    }
}

-(void)saveFavoriteWaysToGetHigh:(NSArray*)waysToGetHigh{
    
    PFQuery *userQuery = [PFQuery queryWithClassName:@"UserProfile"];
    [userQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    userQuery.limit = 1;
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(objects.count != 0){
            //            objects[0][@"favortieTools"] = @(waysToGetHigh);
        }
    }];
}


-(void)saveFavoriteStrain:(int)strainOfChoice{
 
    PFQuery *userQuery = [PFQuery queryWithClassName:@"UserProfile"];
    [userQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    userQuery.limit = 1;
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(objects.count != 0){
            objects[0][@"favoriteProduct"] = @(strainOfChoice); //[NSNumber numberWithInt:strainOfChoice];
        }
    }];
}

- (IBAction)saveEverything:(id)sender {
    
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
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
@end
