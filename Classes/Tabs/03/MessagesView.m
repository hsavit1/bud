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
#import "ProgressHUD.h"

#import "AppConstant.h"
#import "messages.h"
#import "utilities.h"

#import "MessagesView.h"
#import "MessagesCell.h"
#import "ChatView.h"

#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define IS_IPHONE_6PLUS (IS_IPHONE && [[UIScreen mainScreen] nativeScale] == 3.0f)
#define IS_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)

@interface MessagesView()
{
    NSMutableArray *messages;
    UIRefreshControl *refreshControl;
}

@property (strong, nonatomic) IBOutlet UITableView *tableMessages;
//@property (strong, nonatomic) IBOutlet UIView *viewEmpty;

@end
//////
@implementation MessagesView

@synthesize tableMessages;//, viewEmpty;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionCleanup) name:NOTIFICATION_USER_LOGGED_OUT object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"Matches";
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"SnellRoundhand-Black" size:36],
      NSFontAttributeName, nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.086 green:0.627 blue:0.522 alpha:1] /*#16a085*/];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [tableMessages registerNib:[UINib nibWithNibName:@"MessagesCell" bundle:nil] forCellReuseIdentifier:@"MessagesCell"];
    tableMessages.tableFooterView = [[UIView alloc] init];
    tableMessages.dataSource = self;
    tableMessages.delegate = self;
    
//    if(IS_IPHONE_6){
//        tableMessages.frame = CGRectMake(0, 0, 375, 667);
//    }
//    else if (IS_IPHONE_6_PLUS){
//        tableMessages.frame = CGRectMake(0, 0, 414, 736);
//    }
    //tableMessages.frame = self.view.frame;
    //NSLog(@"frame is: %f, %f, %f, %f", self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadMessages) forControlEvents:UIControlEventValueChanged];
    [tableMessages addSubview:refreshControl];
    messages = [[NSMutableArray alloc] init];
    //viewEmpty.hidden = YES;
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([PFUser currentUser] != nil)
    {
        [self loadMessages];
    }
    else LoginUser(self);
}

#pragma mark - Backend methods

- (void)loadMessages
{
    if ([PFUser currentUser] != nil)
    {
        
        /**********************
        
         //make a much more accurate function call here
         
        
        ***********************/

        
        PFQuery *query = [PFQuery queryWithClassName:PF_MESSAGES_CLASS_NAME]; //@"Messages"
        [query whereKey:PF_MESSAGES_USER equalTo:[PFUser currentUser]]; //@"user"
        [query includeKey:PF_MESSAGES_LASTUSER]; //@"lastUser"	Pointer to User Class
        [query orderByDescending:PF_MESSAGES_UPDATEDACTION]; //@"updatedAction"	Date
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             if (error == nil)
             {
                 [messages removeAllObjects];
                 [messages addObjectsFromArray:objects];
                 [tableMessages reloadData];
                 [self updateEmptyView];
                 [self updateTabCounter];
             }
             else [ProgressHUD showError:@"Network error."];
             [refreshControl endRefreshing];
         }];
    }
}

#pragma mark - Helper methods

- (void)updateEmptyView
{
    //viewEmpty.hidden = ([messages count] != 0);
}

- (void)updateTabCounter
{
    int total = 0;
    for (PFObject *message in messages)
    {
        total += [message[PF_MESSAGES_COUNTER] intValue]; //@"counter"	
    }
    UITabBarItem *item = self.tabBarController.tabBar.items[2];
    item.badgeValue = (total == 0) ? nil : [NSString stringWithFormat:@"%d", total];
}

#pragma mark - User actions

- (void)actionCleanup
{
    [messages removeAllObjects];
    [tableMessages reloadData];
    UITabBarItem *item = self.tabBarController.tabBar.items[2];
    item.badgeValue = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    MessagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessagesCell" forIndexPath:indexPath];
    if(cell == nil){
        cell = [[MessagesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessagesCell"];
    }
    [cell bindData:messages[indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeleteMessageItem(messages[indexPath.row]);
    [messages removeObjectAtIndex:indexPath.row];
    [tableMessages deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self updateEmptyView];
    [self updateTabCounter];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PFObject *message = messages[indexPath.row];
    ChatView *chatView = [[ChatView alloc] initWith:message[PF_MESSAGES_ROOMID]]; //@"roomId"				
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
}

@end
