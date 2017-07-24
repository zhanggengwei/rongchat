//
//  LCCKInputViewPluginTakePhoto.h
//  Pods
//
//  v0.8.5 Created by ElonChan (微信向我报BUG:chenyilong1010) on 16/8/11.
//
//

#import "LCCKInputViewPluginTakePhoto.h"
#import "RCChatBar.h"
#import "LCCKInputViewPlugin.h"


@interface LCCKInputViewPluginTakePhoto : LCCKInputViewPlugin<LCCKInputViewPluginSubclassing>

@property (nonatomic, weak) RCChatBar *inputViewRef;

@end
