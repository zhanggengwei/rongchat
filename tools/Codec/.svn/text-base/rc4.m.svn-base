//
//  rc4.m
//  PRIS
//
//  Created by Zhu Reed on 12-5-17.
//  Copyright (c) 2012年 Netease Corp. All rights reserved.
//

#import "rc4.h"
#import "CommonCrypto/CommonCryptor.h"

@implementation rc4

+ (NSData *) encrypt:(Byte *)inByte length:(int)len key:(NSString *)key
{
    const char *textBytes = (const char *)inByte;
    NSUInteger dataLength = len;
    unsigned char *buffer = (unsigned char *)malloc(dataLength);
    memset(buffer, 0, dataLength);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmRC4,
                                          0,
                                          [key UTF8String], [key length],
                                          NULL,
                                          textBytes, dataLength,
                                          buffer, dataLength,
                                          &numBytesEncrypted);
    
    NSData *outData = nil;
    if (cryptStatus == kCCSuccess) {
        outData = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
    }
    free(buffer);
    return outData;
}

+ (Byte *) encryptOutBytes:(Byte *)inByte length:(int)len key:(NSString *)key outBuffer:(unsigned char *)buffer
{
    const char *textBytes = (const char *)inByte;
    NSUInteger dataLength = len;
//    unsigned char *buffer = (unsigned char *)malloc(dataLength);
//    memset(buffer, 0, dataLength);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmRC4,
                                          0,
                                          [key UTF8String], [key length],
                                          NULL,
                                          textBytes, dataLength,
                                          buffer, dataLength,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        return buffer;
    }
//    free(buffer);
    return NULL;
}

+ (NSData *) decrypt:(Byte *)inByte length:(int)len key:(NSString *)key
{
    const char *textBytes = (const char *)inByte;
    NSUInteger dataLength = len;
    unsigned char *buffer = (unsigned char *)malloc(dataLength);
    memset(buffer, 0, dataLength);
    size_t numBytesDecrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmRC4,
                                          0,
                                          [key UTF8String], [key length],
                                          NULL,
                                          textBytes, dataLength,
                                          buffer, dataLength,
                                          &numBytesDecrypted);
    NSData *outData = nil;
    if (cryptStatus == kCCSuccess) {
        outData = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
    }
    free(buffer);
    return outData;
}

- (void)dealloc
{
    [super dealloc];
}

@end
