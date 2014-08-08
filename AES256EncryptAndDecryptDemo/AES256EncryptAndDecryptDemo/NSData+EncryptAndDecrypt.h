//
//  NSData+EncryptAndDecrypt.h
//  AES256EncryptAndDecryptDemo
//
//  Created by  on 14-8-6.
//  Copyright (c) 2014年 Apple002. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (EncryptAndDecrypt)

- (NSData *)AES256EncryptWithKey:(NSData *)key;   //加密

- (NSData *)AES256DecryptWithKey:(NSData *)key;   //解密

- (NSString *)newStringInBase64FromData;            //追加64编码

+ (NSString*)base64encode:(NSString*)str;           //同上64编码
@end
