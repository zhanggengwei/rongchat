//
//  LCCKInputViewPluginPickImage.m
//  Pods
//
//  v0.8.5 Created by ElonChan (微信向我报BUG:chenyilong1010) on 16/8/11.
//
//

#import "LCCKInputViewPluginPickImage.h"
#import "UIImage+RCIMExtension.h"
#import "RCIMConversationViewController.h"
#import <TZImagePickerController.h>
@interface LCCKInputViewPluginPickImage()<TZImagePickerControllerDelegate>

@property (nonatomic, copy) RCArrayResultBlock sendCustomMessageHandler;

@property (nonatomic, strong) TZImagePickerController * imagePickController;

@end

@implementation LCCKInputViewPluginPickImage
@synthesize inputViewRef = _inputViewRef;
@synthesize sendCustomMessageHandler = _sendCustomMessageHandler;

#pragma mark -
#pragma mark - LCCKInputViewPluginSubclassing Method

+ (RCInputViewPluginType)classPluginType {
    return RCInputViewPluginTypePickImage;
}

#pragma mark -
#pragma mark - LCCKInputViewPluginDelegate Method

/*!
 * 插件图标
 */
- (UIImage *)pluginIconImage {
    return [self imageInBundlePathForImageName:@"chat_bar_icons_pic"];
}

/*!
 * 插件名称
 */
- (NSString *)pluginTitle {
    return @"照片";
}

/*!
 * 插件对应的 view，会被加载到 inputView 上
 */
- (UIView *)pluginContentView {
    return nil;
}

- (void)pluginDidClicked {
    [super pluginDidClicked];
    //显示相册
    [self.conversationViewController presentViewController:self.imagePickController animated:YES completion:nil];
}

- (RCArrayResultBlock)sendCustomMessageHandler {
    if (_sendCustomMessageHandler) {
        return _sendCustomMessageHandler;
    }
    RCArrayResultBlock sendCustomMessageHandler = ^(NSArray *objects, NSError *error) {
        [self.conversationViewController dismissViewControllerAnimated:YES completion:nil];
        if (objects) {
            [self.conversationViewController sendImagesMessage:objects];
        } else {
            NSLog(@"%@", error.description);
        }
        _sendCustomMessageHandler = nil;
    };
    _sendCustomMessageHandler = sendCustomMessageHandler;
    return sendCustomMessageHandler;
}

#pragma mark -
#pragma mark - Private Methods
- (TZImagePickerController *)imagePickController {
    if (_imagePickController) {
        return _imagePickController;
    }
    _imagePickController = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    return _imagePickController;
}

- (UIImage *)imageInBundlePathForImageName:(NSString *)imageName {
    UIImage *image = [UIImage lcck_imageNamed:imageName bundleName:@"ChatKeyboard" bundleForClass:[self class]];
    return image;
}

#pragma mark - TZImagePickerControllerDelegate



- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{

    !self.sendCustomMessageHandler ?: self.sendCustomMessageHandler(photos, nil);
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
    
}
//- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker __attribute__((deprecated("Use -tz_imagePickerControllerDidCancel:.")));
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker
{
    NSInteger code = 0;
    NSString *errorReasonText = @"cancel image picker without result";
    NSDictionary *errorInfo = @{
                                @"code":@(code),
                                NSLocalizedDescriptionKey : errorReasonText,
                                };
    NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:code
                                     userInfo:errorInfo];
    !self.sendCustomMessageHandler ?: self.sendCustomMessageHandler(nil, error);
}

@end
