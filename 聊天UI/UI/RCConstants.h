//
//  RCConstants.h
//  LeanCloudChatKit-iOS
//
//  v0.7.19 Created by ElonChan (微信向我报BUG:chenyilong1010) on 16/2/19.
//  Copyright © 2016年 LeanCloud. All rights reserved.
//  Common typdef and constants, and so on.

#import "RCUserDelegate.h"
//#import <AVOSCloudIM/AVOSCloudIM.h>
#import "RCIMMessageMediaType.h"

#pragma mark - Base ViewController Life Time Block
///=============================================================================
/// @name Base ViewController Life Time Block
///=============================================================================

//Callback with Custom type
typedef void (^RCUserResultsCallBack)(NSArray<id<RCUserDelegate>> *users, NSError *error);
typedef void (^RCUserResultCallBack)(id<RCUserDelegate> user, NSError *error);
//Callback with Foundation type
typedef void (^RCBooleanResultBlock)(BOOL succeeded, NSError *error);
typedef void (^RCViewControllerBooleanResultBlock)(__kindof UIViewController *viewController, BOOL succeeded, NSError *error);

typedef void (^RCIntegerResultBlock)(NSInteger number, NSError *error);
typedef void (^RCStringResultBlock)(NSString *string, NSError *error);
typedef void (^RCDictionaryResultBlock)(NSDictionary * dict, NSError *error);
typedef void (^RCArrayResultBlock)(NSArray *objects, NSError *error);
typedef void (^RCSetResultBlock)(NSSet *channels, NSError *error);
typedef void (^RCDataResultBlock)(NSData *data, NSError *error);
typedef void (^RCIdResultBlock)(id object, NSError *error);
typedef void (^RCIdBoolResultBlock)(BOOL succeeded, id object, NSError *error);
typedef void (^RCRequestAuthorizationBoolResultBlock)(BOOL granted, NSError *error);

//Callback with Function object
typedef void (^RCVoidBlock)(void);
typedef void (^RCErrorBlock)(NSError *error);
typedef void (^RCImageResultBlock)(UIImage * image, NSError *error);
typedef void (^RCProgressBlock)(NSInteger percentDone);

#pragma mark - Common Define
///=============================================================================
/// @name Common Define
///=============================================================================

static NSString *const RCBadgeTextForNumberGreaterThanLimit = @"···";

#define RC_DEPRECATED(explain) __attribute__((deprecated(explain)))

#ifndef RCLocalizedStrings
#define RCLocalizedStrings(key) \
NSLocalizedStringFromTableInBundle(key, @"LCChatKitString", [NSBundle bundleWithPath:[[[NSBundle bundleForClass:[LCChatKit class]] resourcePath] stringByAppendingPathComponent:@"Other.bundle"]], nil)
#endif


#ifdef DEBUG
#define RCLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);
#else
#   define RCLog(...)
#endif

#define XCODE_VERSION_GREATER_THAN_OR_EQUAL_TO_8    __has_include(<UserNotifications/UserNotifications.h>)
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#pragma mark - Notification Name
///=============================================================================
/// @name Notification Name
///=============================================================================

/**
 *  未读数改变了。通知去服务器同步 installation 的badge
 */
static NSString *const RCNotificationUnreadsUpdated = @"RCNotificationUnreadsUpdated";

/**
 *  消息到来了，通知聊天页面和最近对话页面刷新
 */
static NSString *const RCNotificationMessageReceived = @"RCNotificationMessageReceived";
/**
 *  消息到来了，通知聊天页面和最近对话页面刷新
 */
static NSString *const RCNotificationCustomMessageReceived = @"RCNotificationCustomMessageReceived";

static NSString *const RCNotificationCustomTransientMessageReceived = @"RCNotificationCustomTransientMessageReceived";

/**
 *  消息到达对方了，通知聊天页面更改消息状态
 */
static NSString *const RCNotificationMessageDelivered = @"RCNotificationMessageDelivered";

/**
 *  对话的元数据变化了，通知页面刷新
 */
static NSString *const RCNotificationConversationUpdated = @"RCNotificationConversationUpdated";

/**
 *  聊天服务器连接状态更改了，通知最近对话和聊天页面是否显示红色警告条
 */
static NSString *const RCNotificationConnectivityUpdated = @"RCNotificationConnectivityUpdated";

/**
 * 会话失效，如当群被解散或当前用户不再属于该会话时，对应会话会失效应当被删除并且关闭聊天窗口
 */
static NSString *const RCNotificationCurrentConversationInvalided = @"RCNotificationCurrentConversationInvalided";

/**
 * 对话聊天背景切换
 */
static NSString *const RCNotificationConversationViewControllerBackgroundImageDidChanged = @"RCNotificationConversationViewControllerBackgroundImageDidChanged";

static NSString *const RCNotificationConversationViewControllerBackgroundImageDidChangedUserInfoConversationIdKey = @"RCNotificationConversationViewControllerBackgroundImageDidChangedUserInfoConversationIdKey";


static NSString *const RCNotificationConversationInvalided = @"RCNotificationConversationInvalided";
static NSString *const RCNotificationConversationListDataSourceUpdated = @"RCNotificationConversationListDataSourceUpdated";
static NSString *const RCNotificationContactListDataSourceUpdated = @"RCNotificationContactListDataSourceUpdated";

static NSString *const RCNotificationContactListDataSourceUpdatedUserInfoDataSourceKey = @"RCNotificationContactListDataSourceUpdatedUserInfoDataSourceKey";

static NSString *const RCNotificationContactListDataSourceUserIdType = @"RCNotificationContactListDataSourceUserIdType";
static NSString *const RCNotificationContactListDataSourceContactObjType = @"RCNotificationContactListDataSourceContactObjType";
static NSString *const RCNotificationContactListDataSourceUpdatedUserInfoDataSourceTypeKey = @"RCNotificationContactListDataSourceUpdatedUserInfoDataSourceTypeKey";

#pragma mark - Conversation Enum : Message Type and operation
///=============================================================================
/// @name Conversation Enum : Message Type and operation
///=============================================================================


/**
 *  消息拥有者类型
 */
typedef NS_ENUM(NSUInteger, RCMessageOwnerType){
    RCMessageOwnerTypeUnknown = 0 /**< 未知的消息拥有者 */,
    RCMessageOwnerTypeSystem /**< 系统消息 */,
    RCMessageOwnerTypeSelf /**< 自己发送的消息 */,
    RCMessageOwnerTypeOther /**< 接收到的他人消息 */,
};

static RCIMMessageMediaType const kRCIMMessageMediaTypeSystem = -7;

/**
 *  消息发送状态,自己发送的消息时有
 */
typedef NS_ENUM(NSUInteger, RCMessageSendState){
    RCMessageSendStateNone = 0,
    RCMessageSendStateSending = 1, /**< 消息发送中 */
    RCMessageSendStateSent, /**< 消息发送成功 */
    RCMessageSendStateDelivered, /**< 消息对方已接收*/
    RCMessageSendStateFailed, /**< 消息发送失败 */
};

/**
 *  消息读取状态,接收的消息时有
 */
typedef NS_ENUM(NSUInteger, RCMessageReadState) {
    RCMessageUnRead = 0 /**< 消息未读 */,
    RCMessageReading /**< 正在接收 */,
    RCMessageReaded /**< 消息已读 */,
};

/**
 *  录音消息的状态
 */
typedef NS_ENUM(NSUInteger, RCVoiceMessageState){
    RCVoiceMessageStateNormal,/**< 未播放状态 */
    RCVoiceMessageStateDownloading,/**< 正在下载中 */
    RCVoiceMessageStatePlaying,/**< 正在播放 */
    RCVoiceMessageStateCancel,/**< 播放被取消 */
};

/**
 *  RCChatMessageCell menu对应action类型
 */
typedef NS_ENUM(NSUInteger, RCChatMessageCellMenuActionType) {
    RCChatMessageCellMenuActionTypeCopy, /**< 复制 */
    RCChatMessageCellMenuActionTypeRelay, /**< 转发 */
};

static NSInteger const kRCOnePageSize = 10;
static NSString *const RC_CONVERSATION_TYPE = @"type";
static NSString *const RCInstallationKeyChannels = @"channels";

static NSString *const RCDidReceiveMessagesUserInfoConversationKey = @"conversation";
static NSString *const RCDidReceiveMessagesUserInfoMessagesKey = @"receivedMessages";
static NSString *const RCDidReceiveCustomMessageUserInfoMessageKey = @"receivedCustomMessage";

#define RC_CURRENT_TIMESTAMP ([[NSDate date] timeIntervalSince1970] * 1000)
#define RC_FUTURE_TIMESTAMP ([[NSDate distantFuture] timeIntervalSince1970] * 1000)
//整数或小数
#define RC_TIMESTAMP_REGEX @"^[0-9]*(.)?[0-9]*$"

#pragma mark - Custom Message
///=============================================================================
/// @name Custom Message
///=============================================================================

/*!
 * 用来定义如何展示老版本未支持的自定义消息类型
 */
static NSString *const RCCustomMessageDegradeKey = @"degrade";

/*!
 * 最近对话列表中最近一条消息的title，比如：最近一条消息是图片，可设置该字段内容为：`@"图片"`，相应会展示：`[图片]`
 */
static NSString *const RCCustomMessageTypeTitleKey = @"typeTitle";

/*!
 * 用来显示在push提示中。
 */
static NSString *const RCCustomMessageSummaryKey = @"summary";

static NSString *const RCCustomMessageIsCustomKey = @"isCustom";
static NSString *const RCCustomMessageOnlyVisiableForPartClientIds = @"OnlyVisiableForPartClientIds";

/*!
 * 对话类型，用来展示在推送提示中，以达到这样的效果： [群消息]Tom：hello gays!
 * 以枚举 RCConversationType 定义为准，0为单聊，1为群聊
 */
static NSString *const RCCustomMessageConversationTypeKey = @"conversationType";

#define RCConversationGroupAvatarURLKey (RCLocalizedStrings(@"ConversationAvatarURLKey") ?: @"avatarURL")

#pragma mark - Custom Message Cell
///=============================================================================
/// @name Custom Message Cell
///=============================================================================

FOUNDATION_EXTERN NSMutableDictionary const * RCChatMessageCellMediaTypeDict;
FOUNDATION_EXTERN NSMutableDictionary const *_typeDict;

static NSString *const RCCellIdentifierDefault = @"RCCellIdentifierDefault";
static NSString *const RCCellIdentifierCustom = @"RCCellIdentifierCustom";
static NSString *const RCCellIdentifierGroup = @"RCCellIdentifierGroup";
static NSString *const RCCellIdentifierSingle = @"RCCellIdentifierSingle";
static NSString *const RCCellIdentifierOwnerSelf = @"RCCellIdentifierOwnerSelf";
static NSString *const RCCellIdentifierOwnerOther = @"RCCellIdentifierOwnerOther";
static NSString *const RCCellIdentifierOwnerSystem = @"RCCellIdentifierOwnerSystem";

#pragma mark - 聊天输入框默认插件类型定义
///=============================================================================
/// @name 聊天输入框默认插件类型定义
///=============================================================================

FOUNDATION_EXTERN NSMutableDictionary const * RCInputViewPluginDict;
FOUNDATION_EXTERN NSMutableArray const * RCInputViewPluginArray;
static NSString *const RCInputViewPluginTypeKey = @"RCInputViewPluginTypeKey";
static NSString *const RCInputViewPluginClassKey = @"RCInputViewPluginClassKey";

/**
 *  默认插件的类型定义
 */
typedef NS_ENUM(NSUInteger, RCInputViewPluginType) {
    RCInputViewPluginTypeDefault = 0,       /**< 默认未知类型 */
    RCInputViewPluginTypeTakePhoto = -1,         /**< 拍照 */
    RCInputViewPluginTypePickImage = -2,         /**< 选择照片 */
    RCInputViewPluginTypeLocation = -3,          /**< 地理位置 */
    RCInputViewPluginTypeShortVideo = -4,        /**< 短视频 */
    //    RCInputViewPluginTypeMorePanel= -7,         /**< 显示更多面板 */
    //    RCInputViewPluginTypeText = -1,              /**< 文本输入 */
    //    RCInputViewPluginTypeVoice = -2,             /**< 语音输入 */
};

#define RC_CURRENT_CONVERSATIONVIEWCONTROLLER_OBJECT              \
({                                                                  \
RCConversationViewController *conversationViewController;     \
conversationViewController = self.conversationViewController;   \
conversationViewController;                                     \
})

#pragma mark - 自定义UI行为
///=============================================================================
/// @name 自定义UI行为
///=============================================================================
static NSString *const RCCustomConversationViewControllerBackgroundImageNamePrefix = @"CONVERSATION_BACKGROUND_";
static NSString *const RCDefaultConversationViewControllerBackgroundImageName = @"CONVERSATION_BACKGROUND_ALL";

static CGFloat const RCAnimateDuration = .25f;

#define RCMessageCellLimit ([UIApplication sharedApplication].keyWindow.frame.size.width/5*3)

// image STRETCH
#define RC_STRETCH_IMAGE(image, edgeInsets) [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch]
#define RC_CONVERSATIONVIEWCONTROLLER_BACKGROUNDCOLOR [UIColor colorWithRed:234.0f/255.0f green:234/255.0f blue:234/255.f alpha:1.0f]
/*!
 *  提示信息的类型定义
 */
typedef enum : NSUInteger {
    /// 普通消息
    RCMessageNotificationTypeMessage = 0,
    /// 警告
    RCMessageNotificationTypeWarning,
    /// 错误
    RCMessageNotificationTypeError,
    /// 成功
    RCMessageNotificationTypeSuccess
} RCMessageNotificationType;

/*!
 * HUD的行为
 */
typedef enum : NSUInteger {
    /// 展示
    RCMessageHUDActionTypeShow,
    /// 隐藏
    RCMessageHUDActionTypeHide,
    /// 错误
    RCMessageHUDActionTypeError,
    /// 成功
    RCMessageHUDActionTypeSuccess
} RCMessageHUDActionType;

typedef enum : NSUInteger {
    RCScrollDirectionNone,
    RCScrollDirectionRight,
    RCScrollDirectionLeft,
    RCScrollDirectionUp,
    RCScrollDirectionDown,
    RCScrollDirectionCrazy,
} RCScrollDirection;

//TODO: to Delete
typedef NS_ENUM(NSInteger, RCBubbleMessageMenuSelectedType) {
    RCBubbleMessageMenuSelectedTypeTextCopy = 0,
    RCBubbleMessageMenuSelectedTypeTextTranspond = 1,
    RCBubbleMessageMenuSelectedTypeTextFavorites = 2,
    RCBubbleMessageMenuSelectedTypeTextMore = 3,
    
    RCBubbleMessageMenuSelectedTypePhotoCopy = 4,
    RCBubbleMessageMenuSelectedTypePhotoTranspond = 5,
    RCBubbleMessageMenuSelectedTypePhotoFavorites = 6,
    RCBubbleMessageMenuSelectedTypePhotoMore = 7,
    
    RCBubbleMessageMenuSelectedTypeVideoTranspond = 8,
    RCBubbleMessageMenuSelectedTypeVideoFavorites = 9,
    RCBubbleMessageMenuSelectedTypeVideoMore = 10,
    
    RCBubbleMessageMenuSelectedTypeVoicePlay = 11,
    RCBubbleMessageMenuSelectedTypeVoiceFavorites = 12,
    RCBubbleMessageMenuSelectedTypeVoiceTurnToText = 13,
    RCBubbleMessageMenuSelectedTypeVoiceMore = 14,
};


#pragma mark - Succeed Message Store
///=============================================================================
/// @name Succeed Message Store
///=============================================================================

#define RCConversationTableName           @"conversations"
#define RCConversationTableKeyId          @"id"
#define RCConversationTableKeyData        @"data"
#define RCConversationTableKeyUnreadCount @"unreadCount"
#define RCConversationTableKeyMentioned   @"mentioned"
#define RCConversationTableKeyDraft       @"draft"

#define RCConversatoinTableCreateSQL                                       \
@"CREATE TABLE IF NOT EXISTS " RCConversationTableName @" ("           \
RCConversationTableKeyId           @" VARCHAR(63) PRIMARY KEY, "   \
RCConversationTableKeyData         @" BLOB NOT NULL, "             \
RCConversationTableKeyUnreadCount  @" INTEGER DEFAULT 0, "         \
RCConversationTableKeyMentioned    @" BOOL DEFAULT FALSE, "        \
RCConversationTableKeyDraft        @" VARCHAR(63)"                 \
@")"

#define RCConversationTableInsertSQL                           \
@"INSERT OR IGNORE INTO " RCConversationTableName @" ("    \
RCConversationTableKeyId               @", "           \
RCConversationTableKeyData             @", "           \
RCConversationTableKeyUnreadCount      @", "           \
RCConversationTableKeyMentioned        @", "           \
RCConversationTableKeyDraft                            \
@") VALUES(?, ?, ?, ?, ?)"

#define RCConversationTableWhereClause                         \
@" WHERE " RCConversationTableKeyId         @" = ?"

#define RCConversationTableDeleteSQL                           \
@"DELETE FROM " RCConversationTableName                    \
RCConversationTableWhereClause

#define RCDeleteConversationTable                              \
@"DELETE FROM " RCConversationTableName                     \

#define RCConversationTableIncreaseUnreadCountSQL              \
@"UPDATE " RCConversationTableName         @" "            \
@"SET " RCConversationTableKeyUnreadCount  @" = "          \
RCConversationTableKeyUnreadCount  @" + ?"        \
RCConversationTableWhereClause

#define RCConversationTableIncreaseOneUnreadCountSQL              \
@"UPDATE " RCConversationTableName         @" "            \
@"SET " RCConversationTableKeyUnreadCount  @" = "          \
RCConversationTableKeyUnreadCount  @" + 1 "        \
RCConversationTableWhereClause


#define RCConversationTableUpdateUnreadCountSQL                \
@"UPDATE " RCConversationTableName         @" "            \
@"SET " RCConversationTableKeyUnreadCount  @" = ? "        \
RCConversationTableWhereClause

#define RCConversationTableUpdateMentionedSQL                  \
@"UPDATE " RCConversationTableName         @" "            \
@"SET " RCConversationTableKeyMentioned    @" = ? "        \
RCConversationTableWhereClause

#define RCConversationTableUpdateDraftSQL                      \
@"UPDATE " RCConversationTableName         @" "            \
@"SET " RCConversationTableKeyDraft        @" = ? "        \
RCConversationTableWhereClause


#define RCConversationTableSelectSQL                           \
@"SELECT * FROM " RCConversationTableName                  \

#define RCConversationTableSelectDraftSQL                           \
@"SELECT draft FROM " RCConversationTableName                  \
RCConversationTableWhereClause

#define RCConversationTableSelectOneSQL                        \
@"SELECT * FROM " RCConversationTableName                  \
RCConversationTableWhereClause

#define RCConversationTableUpdateDataSQL                       \
@"UPDATE " RCConversationTableName @" "                    \
@"SET " RCConversationTableKeyData @" = ? "                \
RCConversationTableWhereClause                             \

#pragma mark - Failed Message Store
///=============================================================================
/// @name Failed Message Store
///=============================================================================

#define RCFaildMessageTable   @"failed_messages"
#define RCKeyId               @"id"
#define RCKeyConversationId   @"conversationId"
#define RCKeyMessage          @"message"

#define RCCreateTableSQL                                       \
@"CREATE TABLE IF NOT EXISTS " RCFaildMessageTable @"("    \
RCKeyId @" VARCHAR(63) PRIMARY KEY, "                  \
RCKeyConversationId @" VARCHAR(63) NOT NULL,"          \
RCKeyMessage @" BLOB NOT NULL"                         \
@")"

#define RCWhereConversationId \
@" WHERE " RCKeyConversationId @" = ? "

#define RCSelectMessagesSQL                        \
@"SELECT * FROM " RCFaildMessageTable          \
RCWhereConversationId

#define RCWhereKeyId \
@" WHERE " RCKeyId @" IN ('%@') "

//SELECT * FROM failed_messages WHERE id IN ('%@')
#define RCSelectMessagesByIDSQL                        \
@"SELECT * FROM " RCFaildMessageTable          \
RCWhereKeyId

#define RCInsertMessageSQL                             \
@"INSERT OR IGNORE INTO " RCFaildMessageTable @"(" \
RCKeyId @","                                   \
RCKeyConversationId @","                       \
RCKeyMessage                                   \
@") values (?, ?, ?) "                              \

#define RCDeleteMessageSQL                             \
@"DELETE FROM " RCFaildMessageTable @" "           \
@"WHERE " RCKeyId " = ? "                          \

