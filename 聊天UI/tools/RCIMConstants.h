//
//  RCIMConstants.h
//  LeanCloudChatKit-iOS
//
//  v0.8.5 Created by ElonChan (微信向我报BUG:chenyilong1010) on 16/2/19.
//  Copyright © 2016年 LeanCloud. All rights reserved.
//  Common typdef and constants, and so on.


#pragma mark - Base ViewController Life Time Block
///=============================================================================
/// @name Base ViewController Life Time Block
///=============================================================================

//Callback with Custom type
/*
typedef void (^RCIMUserResultsCallBack)(NSArray<id<RCIMUserDelegate>> *users, NSError *error);
typedef void (^RCIMUserResultCallBack)(id<RCIMUserDelegate> user, NSError *error);
//Callback with Foundation type
typedef void (^RCIMBooleanResultBlock)(BOOL succeeded, NSError *error);
typedef void (^RCIMViewControllerBooleanResultBlock)(__kindof UIViewController *viewController, BOOL succeeded, NSError *error);

typedef void (^RCIMIntegerResultBlock)(NSInteger number, NSError *error);
typedef void (^RCIMStringResultBlock)(NSString *string, NSError *error);
typedef void (^RCIMDictionaryResultBlock)(NSDictionary * dict, NSError *error);
typedef void (^RCIMArrayResultBlock)(NSArray *objects, NSError *error);
typedef void (^RCIMSetResultBlock)(NSSet *channels, NSError *error);
typedef void (^RCIMDataResultBlock)(NSData *data, NSError *error);
typedef void (^RCIMIdResultBlock)(id object, NSError *error);
typedef void (^RCIMIdBoolResultBlock)(BOOL succeeded, id object, NSError *error);
typedef void (^RCIMRequestAuthorizationBoolResultBlock)(BOOL granted, NSError *error);

//Callback with Function object
typedef void (^RCIMVoidBlock)(void);
typedef void (^RCIMErrorBlock)(NSError *error);
typedef void (^RCIMImageResultBlock)(UIImage * image, NSError *error);
typedef void (^RCIMProgressBlock)(NSInteger percentDone);
*/
#pragma mark - Common Define
///=============================================================================
/// @name Common Define
///=============================================================================

static NSString *const RCIMBadgeTextForNumberGreaterThanLimit = @"···";

#define RCIM_DEPRECATED(explain) __attribute__((deprecated(explain)))

#ifndef RCIMLocalizedStrings
#define RCIMLocalizedStrings(key) \
    NSLocalizedStringFromTableInBundle(key, @"LCChatKitString", [NSBundle lcck_bundleForName:@"Other" class:[self class]], nil)
#endif


#ifdef DEBUG
#define RCIMLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);
#else
#   define RCIMLog(...)
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
static NSString *const RCIMNotificationUnreadsUpdated = @"RCIMNotificationUnreadsUpdated";

/**
 *  消息到来了，通知聊天页面和最近对话页面刷新
 */
static NSString *const RCIMNotificationMessageReceived = @"RCIMNotificationMessageReceived";
/**
 *  消息到来了，通知聊天页面和最近对话页面刷新
 */
static NSString *const RCIMNotificationCustomMessageReceived = @"RCIMNotificationCustomMessageReceived";

static NSString *const RCIMNotificationCustomTransientMessageReceived = @"RCIMNotificationCustomTransientMessageReceived";

/**
 *  消息到达对方了，通知聊天页面更改消息状态
 */
static NSString *const RCIMNotificationMessageDelivered = @"RCIMNotificationMessageDelivered";

/**
 *  对话的元数据变化了，通知页面刷新
 */
static NSString *const RCIMNotificationConversationUpdated = @"RCIMNotificationConversationUpdated";

/**
 *  聊天服务器连接状态更改了，通知最近对话和聊天页面是否显示红色警告条
 */
static NSString *const RCIMNotificationConnectivityUpdated = @"RCIMNotificationConnectivityUpdated";

/**
 * 会话失效，如当群被解散或当前用户不再属于该会话时，对应会话会失效应当被删除并且关闭聊天窗口
 */
static NSString *const RCIMNotificationCurrentConversationInvalided = @"RCIMNotificationCurrentConversationInvalided";

/**
 * 对话聊天背景切换
 */
static NSString *const RCIMNotificationConversationViewControllerBackgroundImageDidChanged = @"RCIMNotificationConversationViewControllerBackgroundImageDidChanged";

static NSString *const RCIMNotificationConversationViewControllerBackgroundImageDidChangedUserInfoConversationIdKey = @"RCIMNotificationConversationViewControllerBackgroundImageDidChangedUserInfoConversationIdKey";


static NSString *const RCIMNotificationConversationInvalided = @"RCIMNotificationConversationInvalided";
static NSString *const RCIMNotificationConversationListDataSourceUpdated = @"RCIMNotificationConversationListDataSourceUpdated";
static NSString *const RCIMNotificationContactListDataSourceUpdated = @"RCIMNotificationContactListDataSourceUpdated";

static NSString *const RCIMNotificationContactListDataSourceUpdatedUserInfoDataSourceKey = @"RCIMNotificationContactListDataSourceUpdatedUserInfoDataSourceKey";

static NSString *const RCIMNotificationContactListDataSourceUserIdType = @"RCIMNotificationContactListDataSourceUserIdType";
static NSString *const RCIMNotificationContactListDataSourceContactObjType = @"RCIMNotificationContactListDataSourceContactObjType";
static NSString *const RCIMNotificationContactListDataSourceUpdatedUserInfoDataSourceTypeKey = @"RCIMNotificationContactListDataSourceUpdatedUserInfoDataSourceTypeKey";

#pragma mark - Conversation Enum : Message Type and operation
///=============================================================================
/// @name Conversation Enum : Message Type and operation
///=============================================================================

/**
 *  消息聊天类型
 */
typedef NS_ENUM(NSUInteger, RCIMConversationType){
    RCIMConversationTypeSingle = 0 /**< 单人聊天,不显示nickname */,
    RCIMConversationTypeGroup /**< 群组聊天,显示nickname */,
};

/**
 *  消息拥有者类型
 */
typedef NS_ENUM(NSUInteger, RCIMMessageOwnerType){
    RCIMMessageOwnerTypeUnknown = 0 /**< 未知的消息拥有者 */,
    RCIMMessageOwnerTypeSystem /**< 系统消息 */,
    RCIMMessageOwnerTypeSelf /**< 自己发送的消息 */,
    RCIMMessageOwnerTypeOther /**< 接收到的他人消息 */,
};

//static AVIMMessageMediaType const kAVIMMessageMediaTypeSystem = -7;

/**
 *  消息发送状态,自己发送的消息时有
 */
typedef NS_ENUM(NSUInteger, RCIMMessageSendState){
    RCIMMessageSendStateNone = 0,
    RCIMMessageSendStateSending = 1, /**< 消息发送中 */
    RCIMMessageSendStateSent, /**< 消息发送成功 */
    RCIMMessageSendStateDelivered, /**< 消息对方已接收*/
    RCIMMessageSendStateFailed, /**< 消息发送失败 */
};

/**
 *  消息读取状态,接收的消息时有
 */
typedef NS_ENUM(NSUInteger, RCIMMessageReadState) {
    RCIMMessageUnRead = 0 /**< 消息未读 */,
    RCIMMessageReading /**< 正在接收 */,
    RCIMMessageReaded /**< 消息已读 */,
};

/**
 *  录音消息的状态
 */
typedef NS_ENUM(NSUInteger, RCIMVoiceMessageState){
    RCIMVoiceMessageStateNormal,/**< 未播放状态 */
    RCIMVoiceMessageStateDownloading,/**< 正在下载中 */
    RCIMVoiceMessageStatePlaying,/**< 正在播放 */
    RCIMVoiceMessageStateCancel,/**< 播放被取消 */
};

/**
 *  RCIMChatMessageCell menu对应action类型
 */
typedef NS_ENUM(NSUInteger, RCIMChatMessageCellMenuActionType) {
    RCIMChatMessageCellMenuActionTypeCopy, /**< 复制 */
    RCIMChatMessageCellMenuActionTypeRelay, /**< 转发 */
};

static NSInteger const kRCIMOnePageSize = 10;
static NSString *const RCIM_CONVERSATION_TYPE = @"type";
static NSString *const RCIMInstallationKeyChannels = @"channels";

static NSString *const RCIMDidReceiveMessagesUserInfoConversationKey = @"conversation";
static NSString *const RCIMDidReceiveMessagesUserInfoMessagesKey = @"receivedMessages";
static NSString *const RCIMDidReceiveCustomMessageUserInfoMessageKey = @"receivedCustomMessage";

#define RCIM_CURRENT_TIMESTAMP ([[NSDate date] timeIntervalSince1970] * 1000)
#define RCIM_FUTURE_TIMESTAMP ([[NSDate distantFuture] timeIntervalSince1970] * 1000)
//整数或小数
#define RCIM_TIMESTAMP_REGEX @"^[0-9]*(.)?[0-9]*$"

#pragma mark - Custom Message
///=============================================================================
/// @name Custom Message
///=============================================================================

/*!
 * 用来定义如何展示老版本未支持的自定义消息类型
 */
static NSString *const RCIMCustomMessageDegradeKey = @"degrade";

/*!
 * 最近对话列表中最近一条消息的title，比如：最近一条消息是图片，可设置该字段内容为：`@"图片"`，相应会展示：`[图片]`
 */
static NSString *const RCIMCustomMessageTypeTitleKey = @"typeTitle";

/*!
 * 用来显示在push提示中。
 */
static NSString *const RCIMCustomMessageSummaryKey = @"summary";

static NSString *const RCIMCustomMessageIsCustomKey = @"isCustom";

static NSString *const RCIMCustomMessageOnlyVisiableForPartClientIds = @"OnlyVisiableForPartClientIds";

/*!
 * 对话类型，用来展示在推送提示中，以达到这样的效果： [群消息]Tom：hello gays!
 * 以枚举 RCIMConversationType 定义为准，0为单聊，1为群聊
 */
static NSString *const RCIMCustomMessageConversationTypeKey = @"conversationType";

#define RCIMConversationGroupAvatarURLKey (RCIMLocalizedStrings(@"ConversationAvatarURLKey") ?: @"avatarURL")

#pragma mark - Custom Message Cell
///=============================================================================
/// @name Custom Message Cell
///=============================================================================

FOUNDATION_EXTERN NSMutableDictionary const * RCIMChatMessageCellMediaTypeDict;
FOUNDATION_EXTERN NSMutableDictionary const *_typeDict;

static NSString *const RCIMCellIdentifierDefault = @"RCIMCellIdentifierDefault";
static NSString *const RCIMCellIdentifierCustom = @"RCIMCellIdentifierCustom";
static NSString *const RCIMCellIdentifierGroup = @"RCIMCellIdentifierGroup";
static NSString *const RCIMCellIdentifierSingle = @"RCIMCellIdentifierSingle";
static NSString *const RCIMCellIdentifierOwnerSelf = @"RCIMCellIdentifierOwnerSelf";
static NSString *const RCIMCellIdentifierOwnerOther = @"RCIMCellIdentifierOwnerOther";
static NSString *const RCIMCellIdentifierOwnerSystem = @"RCIMCellIdentifierOwnerSystem";

#pragma mark - 聊天输入框默认插件类型定义
///=============================================================================
/// @name 聊天输入框默认插件类型定义
///=============================================================================

FOUNDATION_EXTERN NSMutableDictionary const * RCIMInputViewPluginDict;
FOUNDATION_EXTERN NSMutableArray const * RCIMInputViewPluginArray;
static NSString *const RCIMInputViewPluginTypeKey = @"RCIMInputViewPluginTypeKey";
static NSString *const RCIMInputViewPluginClassKey = @"RCIMInputViewPluginClassKey";

/**
 *  默认插件的类型定义
 */
typedef NS_ENUM(NSUInteger, RCIMInputViewPluginType) {
    RCIMInputViewPluginTypeDefault = 0,       /**< 默认未知类型 */
    RCIMInputViewPluginTypeTakePhoto = -1,         /**< 拍照 */
    RCIMInputViewPluginTypePickImage = -2,         /**< 选择照片 */
    RCIMInputViewPluginTypeLocation = -3,          /**< 地理位置 */
    RCIMInputViewPluginTypeShortVideo = -4,        /**< 短视频 */
//    RCIMInputViewPluginTypeMorePanel= -7,         /**< 显示更多面板 */
//    RCIMInputViewPluginTypeText = -1,              /**< 文本输入 */
//    RCIMInputViewPluginTypeVoice = -2,             /**< 语音输入 */
};

#define RCIM_CURRENT_CONVERSATIONVIEWCONTROLLER_OBJECT              \
({                                                                  \
    RCIMConversationViewController *conversationViewController;     \
    conversationViewController = self.conversationViewController;   \
    conversationViewController;                                     \
}) 

#pragma mark - 自定义UI行为
///=============================================================================
/// @name 自定义UI行为
///=============================================================================
static NSString *const RCIMCustomConversationViewControllerBackgroundImageNamePrefix = @"CONVERSATION_BACKGROUND_";
static NSString *const RCIMDefaultConversationViewControllerBackgroundImageName = @"CONVERSATION_BACKGROUND_ALL";
    
static CGFloat const RCIMAnimateDuration = .25f;

#define RCIMMessageCellLimit ([UIApplication sharedApplication].keyWindow.frame.size.width/5*3)

// image STRETCH
#define RCIM_STRETCH_IMAGE(image, edgeInsets) [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch]
#define RCIM_CONVERSATIONVIEWCONTROLLER_BACKGROUNDCOLOR [UIColor colorWithRed:234.0f/255.0f green:234/255.0f blue:234/255.f alpha:1.0f]
/*!
 *  提示信息的类型定义
 */
typedef enum : NSUInteger {
    /// 普通消息
    RCIMMessageNotificationTypeMessage = 0,
    /// 警告
    RCIMMessageNotificationTypeWarning,
    /// 错误
    RCIMMessageNotificationTypeError,
    /// 成功
    RCIMMessageNotificationTypeSuccess
} RCIMMessageNotificationType;

/*!
 * HUD的行为
 */
typedef enum : NSUInteger {
    /// 展示
    RCIMMessageHUDActionTypeShow,
    /// 隐藏
    RCIMMessageHUDActionTypeHide,
    /// 错误
    RCIMMessageHUDActionTypeError,
    /// 成功
    RCIMMessageHUDActionTypeSuccess
} RCIMMessageHUDActionType;

typedef enum : NSUInteger {
    RCIMScrollDirectionNone,
    RCIMScrollDirectionRight,
    RCIMScrollDirectionLeft,
    RCIMScrollDirectionUp,
    RCIMScrollDirectionDown,
    RCIMScrollDirectionCrazy,
} RCIMScrollDirection;

//TODO: to Delete
typedef NS_ENUM(NSInteger, RCIMBubbleMessageMenuSelectedType) {
    RCIMBubbleMessageMenuSelectedTypeTextCopy = 0,
    RCIMBubbleMessageMenuSelectedTypeTextTranspond = 1,
    RCIMBubbleMessageMenuSelectedTypeTextFavorites = 2,
    RCIMBubbleMessageMenuSelectedTypeTextMore = 3,
    
    RCIMBubbleMessageMenuSelectedTypePhotoCopy = 4,
    RCIMBubbleMessageMenuSelectedTypePhotoTranspond = 5,
    RCIMBubbleMessageMenuSelectedTypePhotoFavorites = 6,
    RCIMBubbleMessageMenuSelectedTypePhotoMore = 7,
    
    RCIMBubbleMessageMenuSelectedTypeVideoTranspond = 8,
    RCIMBubbleMessageMenuSelectedTypeVideoFavorites = 9,
    RCIMBubbleMessageMenuSelectedTypeVideoMore = 10,
    
    RCIMBubbleMessageMenuSelectedTypeVoicePlay = 11,
    RCIMBubbleMessageMenuSelectedTypeVoiceFavorites = 12,
    RCIMBubbleMessageMenuSelectedTypeVoiceTurnToText = 13,
    RCIMBubbleMessageMenuSelectedTypeVoiceMore = 14,
};


#pragma mark - Succeed Message Store
///=============================================================================
/// @name Succeed Message Store
///=============================================================================

#define RCIMConversationTableName           @"conversations"
#define RCIMConversationTableKeyId          @"id"
#define RCIMConversationTableKeyData        @"data"
#define RCIMConversationTableKeyUnreadCount @"unreadCount"
#define RCIMConversationTableKeyMentioned   @"mentioned"
#define RCIMConversationTableKeyDraft       @"draft"

#define RCIMConversatoinTableCreateSQL                                       \
    @"CREATE TABLE IF NOT EXISTS " RCIMConversationTableName @" ("           \
        RCIMConversationTableKeyId           @" VARCHAR(63) PRIMARY KEY, "   \
        RCIMConversationTableKeyData         @" BLOB NOT NULL, "             \
        RCIMConversationTableKeyUnreadCount  @" INTEGER DEFAULT 0, "         \
        RCIMConversationTableKeyMentioned    @" BOOL DEFAULT FALSE, "        \
        RCIMConversationTableKeyDraft        @" VARCHAR(63)"                 \
    @")"

#define RCIMConversationTableInsertSQL                           \
    @"INSERT OR IGNORE INTO " RCIMConversationTableName @" ("    \
        RCIMConversationTableKeyId               @", "           \
        RCIMConversationTableKeyData             @", "           \
        RCIMConversationTableKeyUnreadCount      @", "           \
        RCIMConversationTableKeyMentioned        @", "           \
        RCIMConversationTableKeyDraft                            \
    @") VALUES(?, ?, ?, ?, ?)"

#define RCIMConversationTableWhereClause                         \
    @" WHERE " RCIMConversationTableKeyId         @" = ?"

#define RCIMConversationTableDeleteSQL                           \
    @"DELETE FROM " RCIMConversationTableName                    \
    RCIMConversationTableWhereClause

#define RCIMDeleteConversationTable                              \
    @"DELETE FROM " RCIMConversationTableName                     \

#define RCIMConversationTableIncreaseUnreadCountSQL              \
    @"UPDATE " RCIMConversationTableName         @" "            \
    @"SET " RCIMConversationTableKeyUnreadCount  @" = "          \
            RCIMConversationTableKeyUnreadCount  @" + ?"        \
    RCIMConversationTableWhereClause

#define RCIMConversationTableIncreaseOneUnreadCountSQL              \
    @"UPDATE " RCIMConversationTableName         @" "            \
    @"SET " RCIMConversationTableKeyUnreadCount  @" = "          \
            RCIMConversationTableKeyUnreadCount  @" + 1 "        \
    RCIMConversationTableWhereClause


#define RCIMConversationTableUpdateUnreadCountSQL                \
    @"UPDATE " RCIMConversationTableName         @" "            \
    @"SET " RCIMConversationTableKeyUnreadCount  @" = ? "        \
    RCIMConversationTableWhereClause

#define RCIMConversationTableUpdateMentionedSQL                  \
    @"UPDATE " RCIMConversationTableName         @" "            \
    @"SET " RCIMConversationTableKeyMentioned    @" = ? "        \
    RCIMConversationTableWhereClause

#define RCIMConversationTableUpdateDraftSQL                      \
    @"UPDATE " RCIMConversationTableName         @" "            \
    @"SET " RCIMConversationTableKeyDraft        @" = ? "        \
    RCIMConversationTableWhereClause


#define RCIMConversationTableSelectSQL                           \
    @"SELECT * FROM " RCIMConversationTableName                  \

#define RCIMConversationTableSelectDraftSQL                           \
    @"SELECT draft FROM " RCIMConversationTableName                  \
    RCIMConversationTableWhereClause

#define RCIMConversationTableSelectOneSQL                        \
    @"SELECT * FROM " RCIMConversationTableName                  \
    RCIMConversationTableWhereClause

#define RCIMConversationTableUpdateDataSQL                       \
    @"UPDATE " RCIMConversationTableName @" "                    \
    @"SET " RCIMConversationTableKeyData @" = ? "                \
    RCIMConversationTableWhereClause                             \

#pragma mark - Failed Message Store
///=============================================================================
/// @name Failed Message Store
///=============================================================================

#define RCIMFaildMessageTable   @"failed_messages"
#define RCIMKeyId               @"id"
#define RCIMKeyConversationId   @"conversationId"
#define RCIMKeyMessage          @"message"

#define RCIMCreateTableSQL                                       \
    @"CREATE TABLE IF NOT EXISTS " RCIMFaildMessageTable @"("    \
        RCIMKeyId @" VARCHAR(63) PRIMARY KEY, "                  \
        RCIMKeyConversationId @" VARCHAR(63) NOT NULL,"          \
        RCIMKeyMessage @" BLOB NOT NULL"                         \
    @")"

#define RCIMWhereConversationId \
    @" WHERE " RCIMKeyConversationId @" = ? "

#define RCIMSelectMessagesSQL                        \
    @"SELECT * FROM " RCIMFaildMessageTable          \
    RCIMWhereConversationId

#define RCIMWhereKeyId \
    @" WHERE " RCIMKeyId @" IN ('%@') "

//SELECT * FROM failed_messages WHERE id IN ('%@')
#define RCIMSelectMessagesByIDSQL                        \
    @"SELECT * FROM " RCIMFaildMessageTable          \
    RCIMWhereKeyId

#define RCIMInsertMessageSQL                             \
    @"INSERT OR IGNORE INTO " RCIMFaildMessageTable @"(" \
        RCIMKeyId @","                                   \
        RCIMKeyConversationId @","                       \
        RCIMKeyMessage                                   \
    @") values (?, ?, ?) "                              \

#define RCIMDeleteMessageSQL                             \
    @"DELETE FROM " RCIMFaildMessageTable @" "           \
    @"WHERE " RCIMKeyId " = ? "                          \
    
