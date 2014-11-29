#import <UIKit/UIKit.h>

#import "GroupView.h"
#import "PrivateView.h"
#import "MessagesView.h"
#import "ProfileView.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarDelegate>
//-------------------------------------------------------------------------------------------------------------------------------------------------

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) GroupView *groupView;
@property (strong, nonatomic) PrivateView *privateView;
@property (strong, nonatomic) MessagesView *messagesView;
@property (strong, nonatomic) ProfileView *profileView;

@end