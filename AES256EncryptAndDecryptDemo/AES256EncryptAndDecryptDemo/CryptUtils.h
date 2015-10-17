//
//  CryptUtils.h
//  AES256EncryptAndDecryptDemo
//
//  Created by guoqiangzhu on 15/10/15.
//  Copyright (c) 2015年 Apple002. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CryptUtils : NSObject
+ (NSString *)encryptWithText:(NSString *)sText;//加密

+ (NSString *)decryptWithText:(NSString *)sText;//解密

+ (NSString *)encrptWithContentOf:(NSString *)path withKey:(NSString *)key;//加密

+ (NSString *)decrptWithContentOf:(NSString *)path withKey:(NSString *)key;

/*字符串加密
 *参数
 *plainText : 加密明文
 *key        : 密钥 64位
 */
+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;

//解密
+ (NSString *) decryptUseDES:(NSString*)cipherText key:(NSString*)key;

@end
