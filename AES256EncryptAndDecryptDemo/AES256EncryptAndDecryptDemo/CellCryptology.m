/*
 ------------------------------------------------------------------------------
 This source file is part of Cell Cloud.
 
 Copyright (c) 2009-2014 Cell Cloud Team - www.cellcloud.net
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ------------------------------------------------------------------------------
 */

#import "CellCryptology.h"

@implementation CCCryptology

/// 实例
static CCCryptology *sharedInstance = nil;

//------------------------------------------------------------------------------
+ (CCCryptology *)sharedSingleton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CCCryptology alloc] init];
    });
    return sharedInstance;
}
//------------------------------------------------------------------------------
- (int)simpleEncrypt:(char *)out text:(const char *)text length:(int)length key:(const char *)key
{
    // 运算密钥
    int keyCode = 11 + key[0];
    keyCode -= key[1];
    keyCode += key[2];
    keyCode -= key[3];
    keyCode += key[4];
    keyCode -= key[5];
    keyCode += key[6];
    keyCode -= key[7];

    // 评价
    char cc = keyCode % 8;
    char parity = (char) ((keyCode % 2) == 0 ? 2 : 1);

    for (int i = 0; i < length; ++i)
    {
        char c = text[i] ^ parity;
        out[i] = c ^ cc;
    }

    return length;
}
//------------------------------------------------------------------------------
- (int)simpleDecrypt:(char *)out text:(const char *)text length:(int)length key:(const char *)key
{
    // 运算密钥
    int keyCode = 11 + key[0];
    keyCode -= key[1];
    keyCode += key[2];
    keyCode -= key[3];
    keyCode += key[4];
    keyCode -= key[5];
    keyCode += key[6];
    keyCode -= key[7];
    
    // 评价
    char cc = keyCode % 8;
    char parity = (char) ((keyCode % 2) == 0 ? 2 : 1);

    for (int i = 0; i < length; ++i)
    {
        char c = text[i] ^ cc;
        out[i] = c ^ parity;
    }

    return length;
}

@end
