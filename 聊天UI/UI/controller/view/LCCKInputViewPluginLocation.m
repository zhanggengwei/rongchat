//
//  LCCKInputViewPluginLocation.m
//  Pods
//
//  v0.8.5 Created by ElonChan (微信向我报BUG:chenyilong1010) on 16/8/11.
//
//

#import "LCCKInputViewPluginLocation.h"
#import "RCLocationController.h"
#import "RCLocationController.h"
#import "UIImage+RCIMExtension.h"


@interface LCCKInputViewPluginLocation()<RCLocationControllerDelegate>

@property (nonatomic, strong) RCLocationController *locationController;

@end

@implementation LCCKInputViewPluginLocation
@synthesize inputViewRef = _inputViewRef;
@synthesize sendCustomMessageHandler = _sendCustomMessageHandler;

#pragma mark -
#pragma mark - LCCKInputViewPluginSubclassing Method

+ (RCInputViewPluginType)classPluginType {
    return RCInputViewPluginTypeLocation;
}

#pragma mark -
#pragma mark - LCCKInputViewPluginDelegate Method

/*!
 * 插件图标
 */
- (UIImage *)pluginIconImage {
    return [self imageInBundlePathForImageName:@"chat_bar_icons_location"];
}

/*!
 * 插件名称
 */
- (NSString *)pluginTitle {
    return @"位置";
}

/*!
 * 插件对应的 view，会被加载到 inputView 上
 */
- (UIView *)pluginContentView {
    return nil;
}

/**
 *  lazy load locationController
 *
 *  @return LCCKLocationController
 */
- (RCLocationController *)locationController {
    if (_locationController == nil) {
        RCLocationController *locationController = [[RCLocationController alloc] init];
        locationController.delegate = self;
        _locationController = locationController;
    }
    return _locationController;
}

- (void)pluginDidClicked {
    [super pluginDidClicked];
    //显示地理位置
    UINavigationController *locationNav = [[UINavigationController alloc] initWithRootViewController:self.locationController];
    [self.inputViewRef.controllerRef presentViewController:locationNav animated:YES completion:nil];
}

- (RCIdResultBlock)sendCustomMessageHandler {
    if (_sendCustomMessageHandler) {
        return _sendCustomMessageHandler;
    }
    RCIdResultBlock sendCustomMessageHandler = ^(id object, NSError *error) {
        [self.inputViewRef.controllerRef dismissViewControllerAnimated:YES completion:nil];
  
        if (object) {
            CLPlacemark *placemark = (CLPlacemark *)object;
           // [self.conversationViewController sendLocationMessageWithLocationCoordinate:placemark.location.coordinate locatioTitle:placemark.name];
        }
        _sendCustomMessageHandler = nil;
    };
    _sendCustomMessageHandler = sendCustomMessageHandler;
    return sendCustomMessageHandler;
}

#pragma mark -
#pragma mark - Private Methods

- (UIImage *)imageInBundlePathForImageName:(NSString *)imageName {
    UIImage *image = [UIImage lcck_imageNamed:imageName bundleName:@"ChatKeyboard" bundleForClass:[self class]];
    return image;
    return nil;
    
}

#pragma mark - LCCKLocationControllerDelegate

- (void)sendLocation:(CLPlacemark *)placemark {
    !self.sendCustomMessageHandler ?: self.sendCustomMessageHandler(placemark, nil);
}

- (void)cancelLocation {
    NSInteger code = 0;
    NSString *errorReasonText = @"cancel location without result";
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
