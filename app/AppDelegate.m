//
// Copyright (c) 2014 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "AppConstant.h"
#import "AppDelegate.h"
#import "GroupView.h"
#import "PrivateView.h"
#import "MessagesView.h"
#import "ProfileView.h"
#import "NavigationController.h"
#import "ChoosePersonViewController.h"
#import "ProfileDetailTableViewController.h"
#import "ProfileDetailTVC.h"
#import "SettingsTableViewController.h"
#import "ICGNavigationController.h"
#import "ICGLayerAnimation.h"
#import "ASFSharedViewTransition.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];//Doesn't help

    [Parse setApplicationId:@"rQV8F8aGGgGUZSnBxPCmZtxrFGIQRSqaRqJqeCX1" clientKey:@"sGG6Xj0ouVWxvi50w8eGvIk2U7iFEsCXJpJocktD"];
	[PFFacebookUtils initializeFacebook];
	[PFImageView class];
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    //UIStoryboard *msb = [UIStoryboard storyboardWithName:@"MessagesView" bundle:nil];
    //ProfileDetailTVC *m = [msb instantiateViewControllerWithIdentifier:@"m"];
    MessagesView *m = [[MessagesView alloc] init];
    //GroupView *m = [GroupView new];
    NavigationController *navController3 = [[NavigationController alloc] initWithRootViewController:m];
    [navController3.navigationBar setBarTintColor:[UIColor colorWithRed:0.698 green:0.847 blue:0.698 alpha:1] /*#b2d8b2*/];
    UIImage *deselectedM = [[UIImage imageNamed:@"matches-outline_black_32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedM = [[UIImage imageNamed:@"matches-filled-32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    m.tabBarItem =  [[UITabBarItem alloc] initWithTitle:@"Matches" image:deselectedM selectedImage:selectedM];
    
    
//    ProfileView *pv = [[ProfileView alloc] init];
    UIStoryboard *ssb = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
    SettingsTableViewController *s = [ssb instantiateViewControllerWithIdentifier:@"s"];
	NavigationController *navController4 = [[NavigationController alloc] initWithRootViewController:s];
    [navController4.navigationBar setTranslucent:YES];
    UIImage *deselectedS = [[UIImage imageNamed:@"settings-outline_black_32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedS = [[UIImage imageNamed:@"settings_filled-32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    s.tabBarItem =  [[UITabBarItem alloc] initWithTitle:@"Settings" image:deselectedS selectedImage:selectedS];
    [navController4.navigationBar setBarTintColor:[UIColor colorWithRed:0.698 green:0.847 blue:0.698 alpha:1] /*#b2d8b2*/];

    
    UIStoryboard *psb = [UIStoryboard storyboardWithName:@"ProfileDetail" bundle:nil];
    ProfileDetailTVC *e = [psb instantiateViewControllerWithIdentifier:@"p"];
    UIImage *deselectedE = [[UIImage imageNamed:@"edit_user_filled-32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedE = [[UIImage imageNamed:@"edit_user-32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    e.tabBarItem =  [[UITabBarItem alloc] initWithTitle:@"Profile" image:deselectedE selectedImage:selectedE];
    NavigationController *n = [[NavigationController alloc]initWithRootViewController:e];
    [n.navigationBar setBarTintColor:[UIColor colorWithRed:0.698 green:0.847 blue:0.698 alpha:1] /*#b2d8b2*/];
    
    
    ChoosePersonViewController *cp = [ChoosePersonViewController new];
    UIImage *deselectedCP = [[UIImage imageNamed:@"search-outline_black_32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedCP = [[UIImage imageNamed:@"search-filled_black_32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    cp.tabBarItem =  [[UITabBarItem alloc] initWithTitle:@"Find Buds" image:deselectedCP  selectedImage:selectedCP];
    UINavigationController *navigationController = [[ICGNavigationController alloc] initWithRootViewController:cp];
    [navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.698 green:0.847 blue:0.698 alpha:1] /*#b2d8b2*/];
    [ASFSharedViewTransition addTransitionWithFromViewControllerClass:[ChoosePersonViewController class]
                                                ToViewControllerClass:[ProfileDetailTVC class]
                                             WithNavigationController:navigationController
                                                         WithDuration:0.3f];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] } forState:UIControlStateSelected];
    
    self.tabBarController = [[UITabBarController alloc] init];
	self.tabBarController.viewControllers = [NSArray arrayWithObjects: navigationController, navController3, n, navController4, nil];
	self.tabBarController.tabBar.translucent = NO;
    self.tabBarController.tabBar.tintColor = [UIColor blackColor];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    CGRect rect = CGRectMake(0, 0, 320, 50);
    CGImageRef imageRef = CGImageCreateWithImageInRect([[UIImage imageNamed:@"blunt_texture.jpg"] CGImage], rect);
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    self.tabBarController.tabBar.backgroundImage = img;
    self.window.rootViewController = self.tabBarController;
	[self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	[FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	
}

#pragma mark - Facebook responses

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
	return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}

#pragma mark - Push notification methods

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self performSelector:@selector(refreshMessagesView) withObject:nil afterDelay:4.0];
    [PFPush handlePush:userInfo];
}

- (void)refreshMessagesView
{
    [self.messagesView loadMessages];
}

@end
