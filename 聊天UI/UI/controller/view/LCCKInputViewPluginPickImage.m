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

@interface LCCKInputViewPluginPickImage()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, copy) RCIdResultBlock sendCustomMessageHandler;
@property (nonatomic, strong) UIImagePickerController *pickerController;

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
    [self.conversationViewController presentViewController:self.pickerController animated:YES completion:nil];
}

- (RCIdResultBlock)sendCustomMessageHandler {
    if (_sendCustomMessageHandler) {
        return _sendCustomMessageHandler;
    }
    RCIdResultBlock sendCustomMessageHandler = ^(id object, NSError *error) {
        [self.conversationViewController dismissViewControllerAnimated:YES completion:nil];
        if (object) {
            UIImage *image = (UIImage *)object;
            [self.conversationViewController sendImagesMessage:@[image]];
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
- (UIImagePickerController *)pickerController {
    if (_pickerController) {
        return _pickerController;
    }
    _pickerController = [[UIImagePickerController alloc] init];
    _pickerController.delegate = self;
    return _pickerController;
}

- (UIImage *)imageInBundlePathForImageName:(NSString *)imageName {
    UIImage *image = [UIImage lcck_imageNamed:imageName bundleName:@"ChatKeyboard" bundleForClass:[self class]];
    return image;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    !self.sendCustomMessageHandler ?: self.sendCustomMessageHandler(image, nil);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
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
