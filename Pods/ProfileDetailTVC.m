//
//  ProfileDetailTVC.m
//  app
//
//  Created by Henry Savit on 10/16/14.
//  Copyright (c) 2014 KZ. All rights reserved.
//

#import "ProfileDetailTVC.h"
#import "GMCPagingScrollView.h"
#import "ChoosePersonViewController.h"
#import "MainInfoCell.h"
#import "TextDescriptionCell.h"
#import "ASFSharedViewTransition.h"
#import "EditProfileDetailViewController.h"
#import "MDCSwipeToChooseViewOptions.h"
#import "UIView+MDCBorderedLabel.h"
#import "UIColor+MDCRGB8Bit.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define IS_IPHONE_6PLUS (IS_IPHONE && [[UIScreen mainScreen] nativeScale] == 3.0f)
#define IS_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0)

static CGFloat const MDCSwipeToChooseViewHorizontalPadding = 10.f + 15;
static CGFloat const MDCSwipeToChooseViewTopPadding = 20.f + 50;
static CGFloat const MDCSwipeToChooseViewLabelWidth = 95.f;

@interface ProfileDetailTVC ()<GMCPagingScrollViewDataSource, ASFSharedViewTransitionDataSource, UIActionSheetDelegate>{
    NSMutableArray *favoriteTools;
}

@property (nonatomic, strong) GMCPagingScrollView *pagingScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *profilePics;
@property (nonatomic, strong) NSMutableArray *sixPeople;
@property (nonatomic, strong) UIScrollView *myScroll;

@property (nonatomic, strong) MDCSwipeToChooseViewOptions *options;
@property (weak, nonatomic) IBOutlet PFImageView *strainOfChoice;
@property int strainValue;

@end

@implementation ProfileDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profilePics = [[NSMutableArray alloc]init];
    self.sixPeople = [[NSMutableArray alloc]initWithObjects:@"", @"", @"", @"", @"", @"", @"", nil];
    self.myScroll = [[UIScrollView alloc] init];
    
    if([self.navigationController.viewControllers[0] class] == [self class]){
        UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPressed:)];
        self.navigationItem.rightBarButtonItem = edit;
        self.user = [PFUser currentUser];
    }
    else{
        UIImage * imageNormal = [UIImage imageNamed:@"noSmoking"];
        UIImage * imageNormal2 = [UIImage imageNamed:@"yesSmoking"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(menuButtonPressed2:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:imageNormal forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, imageNormal.size.width , imageNormal.size.height );
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button2 addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button2 setBackgroundImage:imageNormal2 forState:UIControlStateNormal];
        button2.frame = CGRectMake(65.0, 65, imageNormal2.size.width , imageNormal2.size.height );
        UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        UIBarButtonItem * barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:button2];
        [self.navigationItem setRightBarButtonItems:@[barButtonItem2, barButtonItem]];
        
        _likeColor = [UIColor colorWith8BitRed:29.f green:245.f blue:106.f alpha:1.f];
        _nopeColor = [UIColor colorWith8BitRed:247.f green:91.f blue:37.f alpha:1.f];
        _likedRotationAngle = -10.f;
        _nopeRotationAngle = 10.f;
        [self constructLikedView];
        [self constructNopeImageView];
    }
    
    
        self.view.backgroundColor = [UIColor colorWithRed:0.698 green:0.847 blue:0.698 alpha:1] /*#b2d8b2*/;
//        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"Back"
//                                                                style:UIBarButtonItemStyleBordered
//                                                               target:nil
//                                                               action:nil];
//        [[self navigationItem] setBackBarButtonItem:btn];
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.698 green:0.847 blue:0.698 alpha:1] /*#b2d8b2*/;
        self.navigationController.navigationItem.hidesBackButton = YES;
    
        float width = self.view.bounds.size.width;
        self.headerView.frame = CGRectMake(0, 0, width, width);
        CGRect backgroundRect = CGRectMake(0, 0, width, width);
        self.pagingScrollView = [[GMCPagingScrollView alloc] initWithFrame:backgroundRect];
        self.pagingScrollView.dataSource = self;
    //self.pagingScrollView.delegate = self;
        self.pagingScrollView.infiniteScroll = YES;
        self.pagingScrollView.interpageSpacing = 0;
        [self.pagingScrollView registerClass:[UIView class] forReuseIdentifier:@"blah"];
        [self.pagingScrollView reloadData];
        self.pagingScrollView.userInteractionEnabled = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.tableView addSubview:self.pagingScrollView];

        CGSize navBarSize = self.navigationController.navigationBar.bounds.size;
        CGPoint origin = CGPointMake( navBarSize.width/2, navBarSize.height/2 );
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(origin.x, origin.y, 0, 0)];
        [self.pageControl setCurrentPage:0];
        self.pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.086 green:0.627 blue:0.522 alpha:1] /*#16a085*/;
        [self.navigationController.navigationBar addSubview:self.pageControl];
        self.pageControl.alpha = 1;
        [self.headerView bringSubviewToFront:self.strainOfChoice];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.pageControl.alpha = 1;
    [self findPhotos];
    [self fillInUserInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.pageControl.alpha = 0;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)findPhotos{
    PFQuery *imageQuery = [PFQuery queryWithClassName:@"Photo"];
    [imageQuery whereKey:@"user" equalTo:self.user];
    imageQuery.limit = 6;
    [imageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *err){
        if (objects.count != 0) {
            for (int i = 0; i < objects.count; i++) {
                PFFile *file = objects[i][@"photo"];
                [self.profilePics addObject:file];
            }
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.tableView reloadData];
            });
        }
    }];
    [self.pagingScrollView bringSubviewToFront:self.strainOfChoice];
    [self.pagingScrollView bringSubviewToFront:self.likedView];
    [self.pagingScrollView bringSubviewToFront:self.nopeView];
}

-(void)fillInUserInfo{
    self.distanceLabel.text = @"20 miles"; //cloud function
    self.numMutualFriendsLabel.text = @"50"; //this should come from a cloud function
    
    NSDate *update = self.user.updatedAt; //really should query for the user's last activity in the "Match" class
    NSDate *currentDate = [NSDate date];
    NSTimeInterval distanceBetweenDates = [currentDate timeIntervalSinceDate:update];
    
    NSInteger minutes = distanceBetweenDates / 60;
    NSInteger hours = distanceBetweenDates / 3600;
    NSInteger days = distanceBetweenDates / (3600*24);
    NSInteger weeks = distanceBetweenDates / (3600*24*7);
    
    
    NSString *dateString;
    if (distanceBetweenDates < 60) {
        dateString = [NSString stringWithFormat:@" %f seconds ago", distanceBetweenDates];
    }
    else if (hours < 24) {
        dateString = [NSString stringWithFormat:@" %i hours ago", hours];
    }
    else if (days < 7) {
        dateString = [NSString stringWithFormat:@" %i days ago", days];
    }
    else{
        dateString = [NSString stringWithFormat:@" %i weeks ago", weeks];
    }
    self.lastActiveLabel.text = dateString;
    
    self.firstNameLabel.text = self.user[@"fullname"];
    self.strainValue = [self.user[@"strainOfChoice"] intValue];

    PFQuery *userQuery = [PFQuery queryWithClassName:@"UserProfile"];
    [userQuery whereKey:@"user" equalTo:self.user];
    userQuery.limit = 1;
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *err){
        if (objects.count != 0) {
            //for (int i = 0; i < objects.count; i++) {
            self.personalBioLabel.text = objects[0][@"bio"];
//            favoriteTools = objects[0][@"favoriteTools"];
            self.educationLabel.text = objects[0][@"education"];
            NSMutableArray *ppl = objects[0][@"sixPeopleArray"];
            self.sixPeople = ppl;
            
//            [self makeScrollView];
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.tableView reloadData];
            });
        }
    }];
}

//-(void)makeScrollView{
//    
//    //_myScroll = [[UIScrollView alloc] init];
//    int trueVal = 0;
//    for(int i = 0; i < favoriteTools.count; i++){
//        if ([favoriteTools[i] integerValue] == 1) {
//            trueVal++;
//        }
//    }
//    _myScroll.backgroundColor = [UIColor clearColor];
//    _myScroll.frame = CGRectMake(0, 0, self.favoriteToolsContentView.frame.size.width, 80);
//    _myScroll.contentSize = CGSizeMake(trueVal * 80, 80);
//    //now all you have to do is add the items to the scrollView
//    
//    int position = 0;
//    for(int i = 0; i < favoriteTools.count; i++){
//        if ([favoriteTools[i] integerValue] == 1) {
//            
//            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(8 + position*70, 12, 35, 35)];
//            [_myScroll addSubview:imageView];
//            //test_tube-48.png
//            switch (i) {
//                case 0:
//                    imageView.image = [UIImage imageNamed:@"test_tube-48.png"];
//                    break;
//                case 1:
//                    imageView.image = [UIImage imageNamed:@"filled_flag-32.png"];
//                    break;
//                case 2:
//                    imageView.image = [UIImage imageNamed:@"filled_flag-32.png"];
//                    break;
//                case 3:
//                    imageView.image = [UIImage imageNamed:@"filled_flag-32.png"];
//                    break;
//                case 4:
//                    imageView.image = [UIImage imageNamed:@"filled_flag-32.png"];
//                    break;
//                case 5:
//                    imageView.image = [UIImage imageNamed:@"filled_flag-32.png"];
//                    break;
//                case 6:
//                    imageView.image = [UIImage imageNamed:@"filled_flag-32.png"];
//                    break;
//                case 7:
//                    imageView.image = [UIImage imageNamed:@"filled_flag-32.png"];
//                    break;
//                case 8:
//                    imageView.image = [UIImage imageNamed:@"filled_flag-32.png"];
//                    break;
//                default:
//                    break;
//            }
//            
//            position++;
//        }
//    }
//    
//    [_myScroll setContentOffset:CGPointMake(0, 0)];
//    _myScroll.showsHorizontalScrollIndicator = YES;
//    _myScroll.scrollEnabled = YES;
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    
//    [self.favoriteToolsContentView addSubview:_myScroll];
//}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *v = (UITableViewHeaderFooterView *)view;
    v.backgroundView.backgroundColor = [UIColor whiteColor];
}

- (NSUInteger)numberOfPagesInPagingScrollView:(GMCPagingScrollView *)pagingScrollView {
    NSInteger numPages = [self.user[@"numProfilePics"] integerValue];
    //self.pageControl.numberOfPages = profilePics.count;
    self.pageControl.numberOfPages = numPages;
    return numPages;
//    return 4;
}

- (UIView *)pagingScrollView:(GMCPagingScrollView *)pagingScrollView pageForIndex:(NSUInteger)index {
    PFImageView *page = [pagingScrollView dequeueReusablePageWithIdentifier:@"blah"];
    float width = self.view.bounds.size.width;
    CGRect backgroundRect = CGRectMake(0, 0, width, width);

    if(index == 0){
        PFImageView *backgroundImageView = [[PFImageView alloc] initWithFrame:backgroundRect];
        ((UIImageView *)backgroundImageView).contentMode = UIViewContentModeScaleAspectFill;
        backgroundImageView.file = self.user[@"picture"];
        [backgroundImageView loadInBackground];
        page = backgroundImageView;
        
        [self.pageControl setCurrentPage:0];
    }
    else{
        for(int i = 0; i < self.profilePics.count; i++){
            if(i == index){
                PFImageView *backgroundImageView = [[PFImageView alloc] initWithFrame:backgroundRect];
                ((UIImageView *)backgroundImageView).contentMode = UIViewContentModeScaleAspectFill;
                backgroundImageView.file = self.profilePics[i];
                [backgroundImageView loadInBackground];
                page = backgroundImageView;
                
                [self.pageControl setCurrentPage:i];
            }
        }
    }
    [self.pagingScrollView bringSubviewToFront:self.strainOfChoice];
    [self.pagingScrollView bringSubviewToFront:self.likedView];
    [self.pagingScrollView bringSubviewToFront:self.nopeView];
    return page;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[self findUserInfo];
    ////////
    switch (indexPath.section) {
        case 0:{
            return 320;
        }
        case 1:{
            return 70;
            break;
        }
        case 2:{
            self.personalBioLabel.textAlignment = NSTextAlignmentLeft;
            self.personalBioLabel.lineBreakMode = NSLineBreakByWordWrapping;
            if (IS_IPHONE_5) {
                [self.personalBioLabel setPreferredMaxLayoutWidth:248];
                CGSize expectedSize = [self.personalBioLabel.text boundingRectWithSize:CGSizeMake(248, 10000)
                                                                               options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                            attributes:@{NSFontAttributeName:
                                                                                             self.personalBioLabel.font}
                                                                               context:nil].size;
                return MAX(60, expectedSize.height + 20);
                
            }
            else if (IS_IPHONE_6){
                [self.personalBioLabel setPreferredMaxLayoutWidth:248 + 55];
                CGSize expectedSize = [self.personalBioLabel.text boundingRectWithSize:CGSizeMake(248 + 45, 10000)
                                                                               options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                            attributes:@{NSFontAttributeName:
                                                                                             self.personalBioLabel.font}
                                                                               context:nil].size;
                return MAX(60, expectedSize.height + 20);
                
            }
            else if (IS_IPHONE_6_PLUS){
                [self.personalBioLabel setPreferredMaxLayoutWidth:248 + 95];
                CGSize expectedSize = [self.personalBioLabel.text boundingRectWithSize:CGSizeMake(248 + 94, 10000)
                                                                               options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                            attributes:@{NSFontAttributeName:
                                                                                             self.personalBioLabel.font}
                                                                               context:nil].size;
                return MAX(60, expectedSize.height + 20);
            }
        }
        case 4:{
            NSString *field0 = [NSString stringWithFormat:@"1. %@", self.sixPeople[0]];
            NSString *field1 = [NSString stringWithFormat:@"2. %@", self.sixPeople[1]];
            NSString *field2 = [NSString stringWithFormat:@"3. %@", self.sixPeople[2]];
            NSString *field3 = [NSString stringWithFormat:@"4. %@", self.sixPeople[3]];
            NSString *field4 = [NSString stringWithFormat:@"5. %@", self.sixPeople[4]];
            NSString *field5 = [NSString stringWithFormat:@"6. %@", self.sixPeople[5]];
            NSArray *stringsArray = [[NSArray alloc] initWithObjects:field0, field1, field2, field3, field4, field5, nil];
            NSString *joinedString = [stringsArray componentsJoinedByString:@" \r\n"];
            
            self.sixStonersInHeaven.text = joinedString;
            [self.sixStonersInHeaven setPreferredMaxLayoutWidth:248];
            
            if(![field0 isEqualToString:@"1. "] && ![field0 isEqualToString:@"1. (null)"]){
            
                self.sixPeopleImageView.image = [UIImage imageNamed:@"partly_cloudy_day-48.png"];
                
                if(IS_IPHONE_5){
                    CGSize expectedSize = [self.sixStonersInHeaven.text boundingRectWithSize:CGSizeMake(248, 10000)
                                                                                     options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                                  attributes:@{NSFontAttributeName:
                                                                                                   self.sixStonersInHeaven.font}
                                                                                     context:nil].size;
                    return MAX(60, expectedSize.height + 20);
                    
                }
                else if (IS_IPHONE_6){
                    [self.sixStonersInHeaven setPreferredMaxLayoutWidth:248 + 55];
                    CGSize expectedSize = [self.sixStonersInHeaven.text boundingRectWithSize:CGSizeMake(248 + 45, 10000)
                                                                                     options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                                  attributes:@{NSFontAttributeName:
                                                                                                   self.sixStonersInHeaven.font}
                                                                                     context:nil].size;
                    return MAX(60, expectedSize.height + 20);
                    
                }
                else if (IS_IPHONE_6_PLUS){
                    [self.sixStonersInHeaven setPreferredMaxLayoutWidth:248 + 95];
                    CGSize expectedSize = [self.sixStonersInHeaven.text boundingRectWithSize:CGSizeMake(248 + 94, 10000)
                                                                                     options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                                  attributes:@{NSFontAttributeName:
                                                                                                   self.sixStonersInHeaven.font}
                                                                                     context:nil].size;
                    return MAX(60, expectedSize.height + 20);
                    
                }
            }
            else{
                self.sixPeopleImageView.image = nil;
                return 0;
            }
            return 60;
        }
        break;
            
        case 3:{
            if (self.educationLabel.text.length != 0){
                self.educationImageVIew.image = [UIImage imageNamed:@"university-48.png"];
                
                if (IS_IPHONE_5) {
                    [self.educationLabel setPreferredMaxLayoutWidth:248];
                    CGSize expectedSize = [self.educationLabel.text boundingRectWithSize:CGSizeMake(248, 10000)
                                                                                 options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                              attributes:@{NSFontAttributeName:
                                                                                               self.educationLabel.font}
                                                                                 context:nil].size;
                    return MAX(60, expectedSize.height + 20);
                    
                }
                else if (IS_IPHONE_6){
                    [self.educationLabel setPreferredMaxLayoutWidth:248 + 55];
                    CGSize expectedSize = [self.educationLabel.text boundingRectWithSize:CGSizeMake(248 + 45, 10000)
                                                                                 options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                              attributes:@{NSFontAttributeName:
                                                                                               self.educationLabel.font}
                                                                                 context:nil].size;
                    return MAX(60, expectedSize.height + 20);
                    
                }
                else if (IS_IPHONE_6_PLUS){
                    [self.educationLabel setPreferredMaxLayoutWidth:248 + 95];
                    CGSize expectedSize = [self.educationLabel.text boundingRectWithSize:CGSizeMake(248 + 94, 10000)
                                                                                    options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                                 attributes:@{NSFontAttributeName:
                                                                                                  self.educationLabel.font}
                                                                                    context:nil].size;
                    return MAX(60, expectedSize.height + 20);
                    
                }
            }
            else{
                self.educationImageVIew.image = nil;
                return 0;
            }
        }
//        case 5:{
//            if(favoriteTools.count == 0){
//                return 0;
//            }
//            else
//                return 60;
//        }
        default:
            break;
    }
    return 30;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)flagButtonPressed:(id)sender {
    
    //now what do you want to flag this person for?
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What is inappropriate about this person's profile?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Inappropriate Language", @"Inappropriate Photos", @"Spam", nil];
     [actionSheet showInView:self.view];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)constructLikedView {
    CGRect frame = CGRectMake(MDCSwipeToChooseViewHorizontalPadding ,
                              MDCSwipeToChooseViewTopPadding ,
                              CGRectGetMidX(self.headerView.bounds),
                              MDCSwipeToChooseViewLabelWidth);
    self.likedView = [[UIView alloc] initWithFrame:frame];
    
    //should really randomize this text
    NSArray *yesSayingsArray = [[NSArray alloc]initWithObjects:@"DANK", @"DOPE", @"FEELN' IT", @"YES", @"MHMMM", @"HMU", @"I WOULD", nil];
    [self.likedView constructBorderedLabelWithText:yesSayingsArray[(arc4random() % [yesSayingsArray count])]//self.options.nopeText
                                             color:self.likeColor
                                             angle:self.likedRotationAngle];
    self.likedView.alpha = 0.f;
    [self.pagingScrollView addSubview:self.likedView];
}

- (void)constructNopeImageView {
    CGFloat width = CGRectGetMidX(self.headerView.bounds);
    CGFloat xOrigin = CGRectGetMaxX(self.headerView.bounds) - width - MDCSwipeToChooseViewHorizontalPadding;
    self.nopeView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, MDCSwipeToChooseViewTopPadding, width, MDCSwipeToChooseViewLabelWidth)];
    
    NSArray *noSayingsArray = [[NSArray alloc]initWithObjects:@"DRY", @"CHILL", @"WEAK", @"PEACE", @"NAH", @"NOPE", @"NO WAY", @"BYE", nil];
    [self.nopeView constructBorderedLabelWithText:noSayingsArray[(arc4random() % [noSayingsArray count])] //"self.options.likedText
                                            color:self.nopeColor
                                            angle:self.nopeRotationAngle];
    self.nopeView.alpha = 0.f;
    [self.pagingScrollView addSubview:self.nopeView];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//if like
-(void)menuButtonPressed:(id)sender{
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.likedView.alpha = 1.f;
                     } completion:^(BOOL animated){
                         [self.navigationController popViewControllerAnimated:YES];
                         [((ChoosePersonViewController*)self.navigationController.viewControllers[0]) likeFrontCardView];
                     }];
    
}

//if dislike
-(void)menuButtonPressed2:(id)sender{
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.nopeView.alpha = 1.f;
                     } completion:^(BOOL animated){
                         [self.navigationController popViewControllerAnimated:YES];
                         [((ChoosePersonViewController*)self.navigationController.viewControllers[0]) nopeFrontCardView];
                     }];
}

//if edit
-(void)editButtonPressed:(id)sender{
    UIStoryboard *edit = [UIStoryboard storyboardWithName:@"ProfileDetail" bundle:nil];
    EditProfileDetailViewController *e = [edit instantiateViewControllerWithIdentifier:@"e"];
    [self.navigationController pushViewController:e animated:YES];
}

//if back
-(void)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)sharedView
{
    return self.pagingScrollView;
}

@end
