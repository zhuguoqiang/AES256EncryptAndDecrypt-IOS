//
//  SViewController.m
//  AES256EncryptAndDecryptDemo
//
//  Created by on 14-8-6.
//  Copyright (c) 2014年 Apple002. All rights reserved.
//

#import "SViewController.h"
#import "NSData+EncryptAndDecrypt.h"
#import "CryptUtils.h"
#import "CellCryptology.h"
#import "XMLDictionary.h"

#define KEY  @"cubeteam"
#define DOCUMENT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface SViewController ()
{
    NSMutableDictionary *_dataDic;
    NSMutableArray *_servers;
    NSMutableDictionary *_serverDic;
    NSMutableArray *_sipServers;
    NSMutableDictionary *_sipServerDic;
    NSMutableArray *_iceServers;
    NSMutableDictionary *_iceServerDic;
    NSMutableArray *_permissions;
    NSMutableDictionary *_companyDic;
    NSString *_element;
}

@property (strong, nonatomic) IBOutlet UITextField *plainTextField;

@end

@implementation SViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
#pragma mark - DES
    
//    NSString *str = @"中华人民共和国万岁!!!";
//    
//    NSString *encrypeStr = [CryptUtils encryptWithText:str];
//    
//    NSLog(@"加密： %@", encrypeStr);
//    
//    NSString *decryptStr = [CryptUtils decryptWithText:encrypeStr];
//    NSLog(@"解密： %@", decryptStr);
    
    
    ///-----///
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"original" ofType:@"txt"];
//    
//    NSString *encryptStr = [CryptUtils encrptWithContentOf:path withKey:@"cubeengine"];
//    
//    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
//    
//    NSString *docDir= [array objectAtIndex:0];
//    
//    NSString *fileName = @"cube.license";
//    
//    NSString *licensePath = [docDir stringByAppendingPathComponent:fileName];
//    NSLog(@"licensePath  =  %@", licensePath);
//    NSError *error;
//    [encryptStr writeToFile:licensePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
//    if (nil == error) {
//        NSLog(@"write file ok");
//        NSLog(@"encryptStr = %@", encryptStr);
//    }
//    ///------///
//    
//    NSString *decrypt = [CryptUtils decrptWithContentOf:licensePath withKey:@"cubeengine"];
//    
//    NSLog(@"decrypt = %@", decrypt);
//    
//    NSString *fp = [[NSBundle mainBundle] pathForResource:@"cube" ofType:@"license"];
//    
//    NSString *testDecrypt = [CryptUtils decrptWithContentOf:fp withKey:@"cubeengine"];
//    
//    NSLog(@"testDecrypt = %@", testDecrypt);
    
#pragma - mark CCCrypt
    char key[9] = {'c', 'u', 'b', 'e', 't', 'e', 'a', 'm', '\0'};
    //加密
     NSString *encrptFilePath = [[NSBundle mainBundle] pathForResource:@"original" ofType:@"txt"];
    if (nil != encrptFilePath)
    {
        NSString *fileN = @"cube.license";
        NSString *outPath = [DOCUMENT_PATH stringByAppendingPathComponent:fileN];
        int len = [self encryptWithContentOfFile:encrptFilePath withKey:key withOutputFile:outPath];
    }
    
    //解密
    NSString *fileN = @"cube.license";
    NSString *decryptFilePath = [DOCUMENT_PATH stringByAppendingPathComponent:fileN];
    
//    NSString *decryptFilePath = [[NSBundle mainBundle] pathForResource:@"cube" ofType:@"license"];
    NSString *outPath;
    if (nil != decryptFilePath)
    {
        NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docPath = [array objectAtIndex:0];
        NSString *fileN = @"cube.xml";
        outPath = [docPath stringByAppendingPathComponent:fileN];
        NSLog(@"outPath = %@", outPath);
        [self decryptWithContentOfFile:decryptFilePath withKey:key withOutputFile:outPath];
    }
#pragma mark - XMLDictionary
    //XML 解析
    NSDictionary *rootDic = [[XMLDictionaryParser sharedInstance] dictionaryWithFile:outPath];
    
    NSLog(@"rootDic.cout = %ld",  rootDic.count);
    NSArray *cubeServers = [rootDic arrayValueForKeyPath:@"CubeServers"];
    for (NSDictionary *dic in cubeServers)
    {
        NSDictionary *server = [dic dictionaryValueForKeyPath:@"CubeServer"];
        NSString *port = [server stringValueForKeyPath:@"Port"];
    }
    NSDictionary *company = [rootDic dictionaryValueForKeyPath:@"Company"];
    NSString *comName = [company stringValueForKeyPath:@"Name"];
    NSString *appKey = [rootDic stringValueForKeyPath:@"AppKey"];
    
}
- (int)encryptWithContentOfFile:(NSString *)path withKey:(char *)key withOutputFile:(NSString *)outPath
{
    
    if (nil != path)
    {
        NSData *content = [[NSData alloc] initWithContentsOfFile:path];
        const char *buffer = [content bytes];
        int bufSize = content.length;
        
        char *output = malloc(bufSize + 1);
        memset(output, 0x0, bufSize + 1);
        
        int outputLen =[[CCCryptology sharedSingleton] simpleEncrypt:output text:buffer length:bufSize key:key];
        
        if (outputLen > 0)
        {
            NSLog(@"Output length: %d", outputLen);
            //            NSLog(@"encrypt.output = %s", output);
        }
        
        if (nil != outPath)
        {
            //写文件
            //获取文件指针
            const char *cFilePath = [outPath UTF8String];
            FILE *pFile = fopen(cFilePath, "w");
            //向文件写数据
            fwrite (output, 1, strlen(output),pFile);
            
            fflush(pFile);
        }
        
        free(output);
        
        return outputLen;
    }
    return 0;
}

- (int)decryptWithContentOfFile:(NSString *)path withKey:(char *)key withOutputFile:(NSString *)outPath
{
    if (nil != path)
    {
        NSData *content = [[NSFileManager defaultManager] contentsAtPath:path];
        const char * buffer = [content bytes];
        
        int bufSize = content.length;
        
        char *output = malloc(bufSize + 1);
        memset(output, 0x0, bufSize + 1);
        
        //        char key[9] = {'c', 'u', 'b', 'e', 't', 'e', 'a', 'm', '\0'};
        
        int outputLen = [[CCCryptology sharedSingleton] simpleDecrypt:output text:buffer length:bufSize key:key];
        
        if (outputLen > 0)
        {
            NSLog(@"Output length: %d", outputLen);
            //            NSLog(@"decrypt.output = %s", output);
        }
        
        if (nil != outPath)
        {
            //写文件
            //获取文件指针
            const char *cFilePath = [outPath UTF8String];
            FILE *pFile = fopen(cFilePath, "w");
            //向文件写数据
            fwrite (output, 1, strlen(output),pFile);
            
            fflush(pFile);
        }
        free(output);
        return outputLen;
    }
    return 0;
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
