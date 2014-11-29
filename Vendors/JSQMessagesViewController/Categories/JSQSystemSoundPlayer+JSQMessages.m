#import "JSQSystemSoundPlayer+JSQMessages.h"

static NSString * const kJSQMessageReceivedSoundName = @"message_received";
static NSString * const kJSQMessageSentSoundName = @"message_sent";


@implementation JSQSystemSoundPlayer (JSQMessages)

+ (void)jsq_playMessageReceivedSound
{
    [[JSQSystemSoundPlayer sharedPlayer] playSoundWithFilename:kJSQMessageReceivedSoundName
                                                 fileExtension:kJSQSystemSoundTypeAIFF];
}

+ (void)jsq_playMessageReceivedAlert
{
    [[JSQSystemSoundPlayer sharedPlayer] playAlertSoundWithFilename:kJSQMessageReceivedSoundName
                                                      fileExtension:kJSQSystemSoundTypeAIFF];
}

+ (void)jsq_playMessageSentSound
{
    [[JSQSystemSoundPlayer sharedPlayer] playSoundWithFilename:kJSQMessageSentSoundName
                                                 fileExtension:kJSQSystemSoundTypeAIFF];
}

+ (void)jsq_playMessageSentAlert
{
    [[JSQSystemSoundPlayer sharedPlayer] playAlertSoundWithFilename:kJSQMessageSentSoundName
                                                      fileExtension:kJSQSystemSoundTypeAIFF];
}

@end