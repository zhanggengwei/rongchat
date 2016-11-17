//
//  des.m
//
//  Created by qq zhang on 12-4-12.
//  Copyright (c) 2012年 netease. All rights reserved.
//

#import "des.h"
#import "Base64.h"
#import "CommonCrypto/CommonCryptor.h"

@implementation Des

static Byte iv[] = {1, 2, 3, 4, 5, 6, 7, 8};
#define MAX_DES_LEN 320

+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    const char *textBytes = [plainText UTF8String];
    NSUInteger dataLength = [plainText length];
    unsigned char buffer[MAX_DES_LEN];
    memset(buffer, 0, sizeof(buffer));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          textBytes, dataLength,
                                          buffer, sizeof(buffer),
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [Base64 encode:data];
    }
    return ciphertext;
}

+ (NSString *) decryptUseDES:(NSString *)cipher key:(NSString *)key
{
    NSData *data = [Base64 decode:cipher];
    NSString *plainttext = nil;
    char *textBytes[MAX_DES_LEN];
    [data getBytes:textBytes length:sizeof(textBytes)];
    NSUInteger dataLength = [data length];
    unsigned char buffer[MAX_DES_LEN];
    memset(buffer, 0, sizeof(buffer));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          textBytes, dataLength,
                                          buffer, sizeof(buffer),
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        buffer[numBytesEncrypted] = 0;
        plainttext = [NSString stringWithCString:(const char *)buffer encoding:NSUTF8StringEncoding];
    }
    return plainttext;
}

+ (void)test
{
    NSString *key = @"ohvsDW_4";
    NSString* plainStr = @"qwertyuiopasddfffff";
    NSString *str = nil;
    
    str = [Des encryptUseDES:plainStr key:key];
    str = [Des decryptUseDES:str key:key];
}

- (void)dealloc
{
    [super dealloc];
}

@end

