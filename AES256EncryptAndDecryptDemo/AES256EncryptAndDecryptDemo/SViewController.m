//
//  SViewController.m
//  AES256EncryptAndDecryptDemo
//
//  Created by on 14-8-6.
//  Copyright (c) 2014年 Apple002. All rights reserved.
//

#import "SViewController.h"
#import "NSData+EncryptAndDecrypt.h"

@interface SViewController ()

@property (strong, nonatomic) IBOutlet UITextField *plainTextField;

@end

@implementation SViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)encryptBtnAction:(id)sender
{
    //明文
    NSString *plainText = self.plainTextField.text;
    
    NSLog(@"明文是：%@", plainText);
    
    NSData *plainTextData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    Byte *plainTextByte = (Byte *)[plainTextData bytes];
    printf("加密前：");
    for (int i = 0; i < plainTextData.length; i++) {
        printf("%x",plainTextByte[i]);
    }
    printf("\n");

    
    //密钥
    Byte keyByte[] = {0x08, 0x08, 0x04, 0x0b, 0x02, 0x0f, 0x0b, 0x0c,
        0x01, 0x03, 0x09, 0x07, 0x0c, 0x03, 0x07, 0x0a, 0x04, 0x0f,
        0x06, 0x0f, 0x0e, 0x09, 0x05, 0x01, 0x0a, 0x0a, 0x01, 0x09,
        0x06, 0x07, 0x09, 0x0d
    };
    
    //byte 转换为NSData类型，以便下边加密方法调用
    NSData *keyData = [[NSData alloc] initWithBytes:keyByte length:32];
    
    printf("密钥是：");
    for (int i = 0; i < keyData.length; i++) {
        printf("%x",keyByte[i]);
    }
    printf("\n");
    
    //加密
    NSData *cipherTextData = [plainTextData AES256EncryptWithKey:keyData];
    
    Byte *cipherTextByte = (Byte *)[cipherTextData bytes];
    
    printf("加密后 ：");
    for (int i = 0; i < cipherTextData.length; i++) {
        printf("%x",cipherTextByte[i]);
    }
    printf("\n");
    
    //加密后的数据转base64
    NSString *base64Str = [cipherTextData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSLog(@"加密后的数据nsdata转base64 = %@",base64Str);
    
    //base64转nsdata
    
    NSData *base64DecodeData = [[NSData alloc] initWithBase64EncodedString:base64Str options:0];
    
    Byte *base64DecodeByte = (Byte *)[base64DecodeData bytes];
    
    printf("加密后的数据base64转byte[] ：");
    for (int i = 0; i < base64DecodeData.length; i++) {
        printf("%x",base64DecodeByte[i]);
    }
    printf("\n");

    //解密
    NSData *decryptedData = [base64DecodeData AES256DecryptWithKey:keyData];
    
    Byte *decryptedDataByte = (Byte *)[decryptedData bytes];
    
    printf("解密后byte[] ：");
    for (int i = 0; i < decryptedData.length; i++) {
        printf("%x",decryptedDataByte[i]);
    }
    printf("\n");
    
    NSString *decryptStr = [[NSString alloc]initWithData:decryptedData encoding:NSUTF8StringEncoding];
    
   NSLog(@"解密后：%@", decryptStr);
}

- (IBAction)didEndOnExit:(id)sender {
    [sender resignFirstResponder];
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

@end
