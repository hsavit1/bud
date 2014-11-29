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
#import "pushnotification.h"

#import "RegisterView.h"

#import "IQActionSheetPickerView.h"
//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface RegisterView()<IQActionSheetPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UITableViewCell *cellName;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellPassword;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellEmail;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellButton;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellRegister;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellBirthday;
@property (strong, nonatomic) IBOutlet UIButton *buttonSingle;

@property (strong, nonatomic) IBOutlet UITextField *fieldName;
@property (strong, nonatomic) IBOutlet UITextField *fieldPassword;
@property (strong, nonatomic) IBOutlet UITextField *fieldEmail;

@property (weak, nonatomic) IBOutlet UITextField *stateField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayField;
@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation RegisterView

@synthesize cellName, cellPassword, cellEmail, cellButton, cellRegister, cellBirthday;
@synthesize fieldName, fieldPassword, fieldEmail;

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    self.navigationItem.title = @"Register";
    
    self.birthdayField.enabled = NO;
    self.stateField.enabled = NO;
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.698 green:0.847 blue:0.698 alpha:1] /*#b2d8b2*/];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidAppear:animated];
    [fieldName becomeFirstResponder];
}

-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles
{
    switch (pickerView.tag)
    {
        case 1: {
            //[self.buttonSingle setTitle:titles[0] forState:UIControlStateNormal];
            [self.stateField setText:titles[0]];
            break;
        }
        case 6: {
            [self.birthdayField setText:[titles componentsJoinedByString:@" - "]];
            break;
        }
            
        default:
            break;
    }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)dismissKeyboard
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [self.view endEditing:YES];
}

#pragma mark - User actions
- (IBAction)birthdayPickerPressed:(id)sender {
    [[self view] endEditing:YES];

    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Date Picker" delegate:self];
    [picker setTag:6];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker show];
}

- (IBAction)pickerPressed:(id)sender {
    [[self view] endEditing:YES];
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Single Picker" delegate:self];
    [picker setTag:1];
    [picker setTitlesForComponenets:@[@[@"Would Rather Not Say", @"International", @"Alaska", @"Arizon", @"California", @"Colorado", @"Connecticut", @"Delaware", @"D.C.", @"Hawaii", @"Illinois", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Montana", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"Pennsylvania", @"Oregon", @"Rhode Island", @"Vermont", @"Washington"]]];
    [picker show];
}
//-------------------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)actionRegister:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    NSString *name		= fieldName.text;
    NSString *password	= fieldPassword.text;
    NSString *email		= fieldEmail.text;
    
    if (![self.birthdayField.text isEqualToString:@""]) {
        
        if(![self.stateField.text isEqualToString:@""]){
            
            if ((name.length > 0) && (name.length <= 15) && (password.length != 0) && (email.length != 0))
            {
                [ProgressHUD show:@"Please wait..." Interaction:NO];
                
                PFUser *user = [PFUser user];
                user.username = email;
                user.password = password;
                user.email = email;
                user[PF_USER_EMAILCOPY] = email;
                user[PF_USER_FULLNAME] = name;
                user[PF_USER_FULLNAME_LOWER] = [name lowercaseString];
                
                [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                 {
                     if (error == nil)
                     {
                         ParsePushUserAssign();
                         [ProgressHUD showSuccess:@"Succeed."];
                         [self dismissViewControllerAnimated:YES completion:nil];
                     }
                     else [ProgressHUD showError:error.userInfo[@"error"]];
                 }];
            }
            else [ProgressHUD showError:@"Please fill all values!"];
                
        }
        else [ProgressHUD showError:@"Please select a state before registering"];
    }
    else [ProgressHUD showError:@"Please enter your birthday"];

}

#pragma mark - Table view data source

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    return 1;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    return 6;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.row == 0) return cellName;
    if (indexPath.row == 1) return cellPassword;
    if (indexPath.row == 2) return cellEmail;
    if (indexPath.row == 3) return cellRegister;
    if (indexPath.row == 4) return cellBirthday;
    if (indexPath.row == 5) return cellButton;
    return nil;
}

#pragma mark - UITextField delegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
//-------------------------------------------------------------------------------------------------------------------------------------------------
{

    //[textField resignFirstResponder];

    
    if (textField == fieldName)
    {
        [fieldPassword becomeFirstResponder];
    }
    if (textField == fieldPassword)
    {
        [fieldEmail becomeFirstResponder];
    }
    if (textField == fieldEmail)
    {
        [self actionRegister:nil];
    }
    return YES;
}

@end
