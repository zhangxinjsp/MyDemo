//
//  SecurityViewController.m
//  MyDemo
//
//  Created by zhangxin on 16/1/29.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "SecurityViewController.h"

#import <Security/Security.h>
#import <CommonCrypto/CommonCryptor.h>

#import <CommonCrypto/CommonDigest.h>

@interface SecurityViewController () {
    UITextView* md5TextView;
    UIButton* md5Button;
}

@end

@implementation SecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self md5:@"zhangxin"];
    
    NSString* str = [self encryptWithText:@"zhangxin"];
    
    LOGINFO(@"%@", str);
    
    LOGINFO(@"%@", [self decryptWithText:str]);
    
    NSData* data = nil;
    NSData* newData = [NSKeyedArchiver archivedDataWithRootObject:data];
    NSData* aData = [NSKeyedUnarchiver unarchiveObjectWithData:newData];
    LOGINFO(@"%@", aData);
    
}

-(void)md5:(NSString*)string{
    
    NSString* temp = string;
    
    temp = [temp md5];
    
    LOGINFO(@"%@",temp);
}


- (NSString *)encryptWithText:(NSString *)sText
{
    //kCCEncrypt 加密
    return [self encrypt:sText encryptOrDecrypt:kCCEncrypt key:@"des"];
}

- (NSString *)decryptWithText:(NSString *)sText
{
    //kCCDecrypt 解密
    return [self encrypt:sText encryptOrDecrypt:kCCDecrypt key:@"des"];
}
/**
 *  AES 和DES加密相关的加密参数AES或DES就是相关的加密方式（kCCAlgorithmAES，kCCKeySizeAES256，kCCBlockSizeAES128）
 *
 *  @param sText            <#sText description#>
 *  @param encryptOperation <#encryptOperation description#>
 *  @param key              <#key description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key
{
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)//传递过来的是decrypt 解码
    {
        //解码 base64
        NSData* decryptData = [[NSData alloc]initWithBase64EncodedString:sText options:NSDataBase64DecodingIgnoreUnknownCharacters];//转成utf-8并decode
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else  //encrypt
    {
        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    /*
     DES加密 ：用CCCrypt函数加密一下，然后用base64编码下，传过去
     DES解密 ：把收到的数据根据base64，decode一下，然后再用CCCrypt函数解密，得到原本的数据
     */
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    
    //    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOutAvailable = (dataInLength + kCCBlockSizeAES128) & ~(kCCBlockSizeAES128 - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    NSString *initIv = @"12345678";
    const void *vkey = (const void *) [key UTF8String];
    const void *iv = (const void *) [initIv UTF8String];
    
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,//  加密/解密
                       kCCAlgorithmAES,//  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       vkey,  //密钥    加密和解密的密钥必须一致
                       kCCKeySizeAES256,//   DES 密钥的大小（kCCKeySizeDES=8）
                       iv, //  可选的初始矢量
                       dataIn, // 数据的存储单元
                       dataInLength,// 数据的大小
                       (void *)dataOut,// 用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
    {
        //得到解密出来的data数据，改变为utf-8的字符串
        NSData* data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else //encryptOperation==0  （加密过程中，把加好密的数据转成base64的）
    {
        //编码 base64
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        result = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    
    return result;
}




/*
 REA 加解密使用
 
 证书生成
 
 openssl genrsa -out private_key.pem 1024
 Generating RSA private key, 1024 bit long modulus
 ...........++++++
 ...........................................++++++
 e is 65537 (0x10001)
 zhangxin-2:Desktop archermind$ openssl req -new -key private_key.pem -out rsaCertReq.csr
 You are about to be asked to enter information that will be incorporated
 into your certificate request.
 What you are about to enter is what is called a Distinguished Name or a DN.
 There are quite a few fields but you can leave some blank
 For some fields there will be a default value,
 If you enter '.', the field will be left blank.
 -----
 Country Name (2 letter code) [AU]:cn
 State or Province Name (full name) [Some-State]:jiangsu
 Locality Name (eg, city) []:nanjing
 Organization Name (eg, company) [Internet Widgits Pty Ltd]:test
 Organizational Unit Name (eg, section) []:tes
 Common Name (e.g. server FQDN or YOUR name) []:test
 Email Address []:test@test.com
 
 Please enter the following 'extra' attributes
 to be sent with your certificate request
 A challenge password []:
 An optional company name []:
 zhangxin-2:Desktop archermind$ openssl x509 -req -days 3650 -in rsaCertReq.csr -signkey private_key.pem -out rsaCert.crt
 Signature ok
 subject=/C=cn/ST=jiangsu/L=nanjing/O=test/OU=tes/CN=test/emailAddress=test@test.com
 Getting Private key
 zhangxin-2:Desktop archermind$ openssl x509 -outform der -in rsaCert.crt -out public_key.der
 zhangxin-2:Desktop archermind$ openssl pkcs12 -export -out private_key.p12 -inkey private_key.pem -in rsaCert.crt
 Enter Export Password:
 Verifying - Enter Export Password:
 zhangxin-2:Desktop archermind$
 zhangxin-2:Desktop archermind$ openssl rsa -in private_key.pem -out rsa_public_key.pem -pubout
 writing RSA key
 zhangxin-2:Desktop archermind$ openssl pkcs8 -topk8 -in private_key.pem -out pkcs8_private_key.pem -nocrypt
 zhangxin-2:Desktop archermind$
 
 */
- (SecKeyRef)publicKey {
    SecKeyRef _publicKey=nil;
    
    OSStatus status = -1;
    if (_publicKey == nil) {
        SecTrustRef trust;
        SecTrustResultType trustResult;
        NSString *certPath = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"];
        NSData *derData = [NSData dataWithContentsOfFile:certPath];
        if (derData) {
            SecCertificateRef cert = SecCertificateCreateWithData(kCFAllocatorDefault, (CFDataRef)derData);
            SecPolicyRef policy = SecPolicyCreateBasicX509();
            status = SecTrustCreateWithCertificates(cert, policy, &trust);
            if (status == errSecSuccess && trust) {
                NSArray *certs = [NSArray arrayWithObject:(__bridge id)cert];
                status = SecTrustSetAnchorCertificates(trust, (CFArrayRef)certs);
                if (status == errSecSuccess) {
                    status = SecTrustEvaluate(trust, &trustResult);
                    // 自签名证书可信
                    if (status == errSecSuccess && (trustResult == kSecTrustResultUnspecified || trustResult == kSecTrustResultProceed)) {
                        _publicKey = SecTrustCopyPublicKey(trust);
                        if (_publicKey) {
                            NSLog(@"Get public key successfully~ %@", _publicKey);
                        }
                        if (cert) {
                            CFRelease(cert);
                        }
                        if (policy) {
                            CFRelease(policy);
                        }
                        if (trust) {
                            CFRelease(trust);
                        }
                    }
                }
            }
        }
    }
    return _publicKey;
}

-(NSMutableData *)RSAEncrypotoTheData:(NSString *)plainText
{
    
    SecKeyRef publicKey=nil;
    publicKey=[self publicKey];
    size_t cipherBufferSize = SecKeyGetBlockSize(publicKey);
    uint8_t *cipherBuffer = NULL;
    
    cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0*0, cipherBufferSize);
    
    NSData *plainTextBytes = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    int blockSize = (int)cipherBufferSize - 11; // 这个地方比较重要是加密数组长度
    int numBlock = (int)ceil([plainTextBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [[NSMutableData alloc] init];
    for (int i=0; i<numBlock; i++) {
        int bufferSize = (int)MIN(blockSize,[plainTextBytes length]-i*blockSize);
        NSData *buffer = [plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(publicKey,
                                        kSecPaddingPKCS1,
                                        (const uint8_t *)[buffer bytes],
                                        [buffer length],
                                        cipherBuffer,
                                        &cipherBufferSize);
        if (status == noErr)
        {
            NSData *encryptedBytes = [[NSData alloc]
                                       initWithBytes:(const void *)cipherBuffer
                                       length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        }
        else
        {
            return nil;
        }
    }
    if (cipherBuffer)
    {
        free(cipherBuffer);
    }
    
    NSLog(@"encryptedData, %@", encryptedData);
    
    NSString *encrypotoResult = [NSString stringWithFormat:@"%@",[encryptedData base64EncodedStringWithOptions:0]];
    
    NSLog(@"encrypotoResult : %@", encrypotoResult);
    
    return encryptedData;
}

- (SecKeyRef)privateKeyWithPassword:(NSString *)pkcsPassword {
    
    SecKeyRef _privateKey = nil;
    NSString *pkcsPath = [[NSBundle mainBundle] pathForResource:@"private_key" ofType:@"p12"];
    
    SecIdentityRef identity;
    SecTrustRef trust;
    OSStatus status = -1;
    if (_privateKey == nil) {
        NSData *p12Data = [NSData dataWithContentsOfFile:pkcsPath];
        if (p12Data) {
            CFStringRef password = (__bridge CFStringRef)pkcsPassword;
            const void *keys[] = {
                kSecImportExportPassphrase
            };
            const void *values[] = {
                password
            };
            CFDictionaryRef options = CFDictionaryCreate(kCFAllocatorDefault, keys, values, 1, NULL, NULL);
            CFArrayRef items = CFArrayCreate(kCFAllocatorDefault, NULL, 0, NULL);
            status = SecPKCS12Import((CFDataRef)p12Data, options, &items);
            if (status == errSecSuccess) {
                CFDictionaryRef identity_trust_dic = CFArrayGetValueAtIndex(items, 0);
                identity = (SecIdentityRef)CFDictionaryGetValue(identity_trust_dic, kSecImportItemIdentity);
                trust = (SecTrustRef)CFDictionaryGetValue(identity_trust_dic, kSecImportItemTrust);
                // certs数组中包含了所有的证书
                CFArrayRef certs = (CFArrayRef)CFDictionaryGetValue(identity_trust_dic, kSecImportItemCertChain);
                if ([(__bridge NSArray *)certs count] && trust && identity) {
                    // 如果没有下面一句，自签名证书的评估信任结果永远是kSecTrustResultRecoverableTrustFailure
                    status = SecTrustSetAnchorCertificates(trust, certs);
                    if (status == errSecSuccess) {
                        SecTrustResultType trustResultType;
                        // 通常, 返回的trust result type应为kSecTrustResultUnspecified，如果是，就可以说明签名证书是可信的
                        status = SecTrustEvaluate(trust, &trustResultType);
                        if ((trustResultType == kSecTrustResultUnspecified || trustResultType == kSecTrustResultProceed) && status == errSecSuccess) {
                            // 证书可信，可以提取私钥与公钥，然后可以使用公私钥进行加解密操作
                            status = SecIdentityCopyPrivateKey(identity, &_privateKey);
                            if (status == errSecSuccess && _privateKey) {
                                // 成功提取私钥
                                NSLog(@"Get private key successfully~ %@", _privateKey);
                            }
                        }
                    }
                }
            }
            if (options) {
                CFRelease(options);
            }
        }
    }
    return _privateKey;
}

- (NSData *)decryptWithPrivateKey:(NSData *)cipherData {
    // 分配内存块，用于存放解密后的数据段
    
    SecKeyRef _privateKey=nil;
    _privateKey = [self privateKeyWithPassword:@""];
    
    size_t plainBufferSize = SecKeyGetBlockSize(_privateKey);
    NSLog(@"plainBufferSize = %zd", plainBufferSize);
    uint8_t *plainBuffer = malloc(plainBufferSize * sizeof(uint8_t));
    // 计算数据段最大长度及数据段的个数
    double totalLength = [cipherData length];
    size_t blockSize = plainBufferSize;
    size_t blockCount = (size_t)ceil(totalLength / blockSize);
    NSMutableData *decryptedData = [NSMutableData data];
    // 分段解密
    for (int i = 0; i < blockCount; i++) {
        NSUInteger loc = i * blockSize;
        // 数据段的实际大小。最后一段可能比blockSize小。
        int dataSegmentRealSize = MIN(blockSize, totalLength - loc);
        // 截取需要解密的数据段
        NSData *dataSegment = [cipherData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
        OSStatus status = SecKeyDecrypt(_privateKey, kSecPaddingPKCS1, (const uint8_t *)[dataSegment bytes], dataSegmentRealSize, plainBuffer, &plainBufferSize);
        if (status == errSecSuccess) {
            NSData *decryptedDataSegment = [[NSData alloc] initWithBytes:(const void *)plainBuffer length:plainBufferSize];
            [decryptedData appendData:decryptedDataSegment];
//            [decryptedDataSegment release];
        } else {
            if (plainBuffer) {
                free(plainBuffer);
            }
            return nil;
        }
    }
    if (plainBuffer) {
        free(plainBuffer);
    }
    NSLog(@"decrypted string :%@", [[NSString alloc]initWithData:decryptedData encoding:NSUTF8StringEncoding]);
    
    return decryptedData;
}

/**
 对数据进行sha256签名
 */

- (NSData *)rsaSHA256SignData:(NSData *)plainData {
    SecKeyRef key = [self privateKeyWithPassword:@""];
    
    size_t signedHashBytesSize = SecKeyGetBlockSize(key);
    uint8_t* signedHashBytes = malloc(signedHashBytesSize);
    memset(signedHashBytes, 0x0, signedHashBytesSize);
    
    size_t hashBytesSize = CC_SHA256_DIGEST_LENGTH;
    uint8_t* hashBytes = malloc(hashBytesSize);
    if (!CC_SHA256([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return nil;
    }
    
    SecKeyRawSign(key,
                  kSecPaddingPKCS1SHA256,
                  hashBytes,
                  hashBytesSize,
                  signedHashBytes,
                  &signedHashBytesSize);
    
    NSData* signedHash = [NSData dataWithBytes:signedHashBytes
                                        length:(NSUInteger)signedHashBytesSize];
    
    if (hashBytes)
        free(hashBytes);
    if (signedHashBytes)
        free(signedHashBytes);
    
    return signedHash;
}

//这边对签名的数据进行验证 验签成功，则返回YES
- (BOOL)rsaSHA256VerifyData:(NSData *)plainData     withSignature:(NSData *)signature {
    SecKeyRef key = [self publicKey];
    
    size_t signedHashBytesSize = SecKeyGetBlockSize(key);
    const void* signedHashBytes = [signature bytes];
    
    size_t hashBytesSize = CC_SHA256_DIGEST_LENGTH;
    uint8_t* hashBytes = malloc(hashBytesSize);
    if (!CC_SHA256([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return NO;
    }
    
    OSStatus status = SecKeyRawVerify(key,
                                      kSecPaddingPKCS1SHA256,
                                      hashBytes,
                                      hashBytesSize,
                                      signedHashBytes,
                                      signedHashBytesSize);
    
    return status == errSecSuccess;
}

//创建密钥对
- (void)createSecKeyPair {
    SInt32 iKeySize = 1024;
    CFNumberRef keySize = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &iKeySize);
    const void* values[] = { kSecAttrKeyTypeRSA, keySize };
    const void* keys[] = { kSecAttrKeyType, kSecAttrKeySizeInBits };
    CFDictionaryRef parameters = CFDictionaryCreate(kCFAllocatorDefault, keys, values, 2, NULL, NULL);
    
    SecKeyRef publicKey, privateKey;
    OSStatus ret = SecKeyGeneratePair(parameters, &publicKey, &privateKey);
    if ( ret == errSecSuccess )
        NSLog(@"Key success!");
    else
        NSLog(@"Key Failure! %i", (int)ret);
}

//保存密钥对
- (NSData *)getPublicKeyBitsFromKey:(SecKeyRef)givenKey {
    
    static const uint8_t publicKeyIdentifier[] = "com.your.company.publickey";
    NSData *publicTag = [[NSData alloc] initWithBytes:publicKeyIdentifier length:sizeof(publicKeyIdentifier)];
    
    OSStatus sanityCheck = noErr;
    NSData * publicKeyBits = nil;
    
    NSMutableDictionary * queryPublicKey = [[NSMutableDictionary alloc] init];
    [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPublicKey setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
    [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Temporarily add key to the Keychain, return as data:
    NSMutableDictionary * attributes = [queryPublicKey mutableCopy];
    [attributes setObject:(__bridge id)givenKey forKey:(__bridge id)kSecValueRef];
    [attributes setObject:@YES forKey:(__bridge id)kSecReturnData];
    CFTypeRef result;
    sanityCheck = SecItemAdd((__bridge CFDictionaryRef) attributes, &result);
    if (sanityCheck == errSecSuccess) {
        publicKeyBits = CFBridgingRelease(result);
        
        // Remove from Keychain again:
        (void)SecItemDelete((__bridge CFDictionaryRef) queryPublicKey);
    }
    
    /*
     以上是保存到keychain且转换为data类型数据，以下从keychain中取出保存的public key
     SecKeyRef publicKeyBits = nil;//必要时可以直接使用
     
     CFDataRef publicKeyBits = nil;
     NSMutableDictionary * queryPublicKey = [[NSMutableDictionary alloc] init];
     // Set the public key query dictionary.
     [queryPublicKey setObject:(id)kSecClassKey forKey:(id)kSecClass];
     [queryPublicKey setObject:publicTag forKey:(id)kSecAttrApplicationTag];
     [queryPublicKey setObject:(id)kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];
     [queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecReturnData];
     
     // Get the key bits.
     sanityCheck = SecItemCopyMatching((CFDictionaryRef)queryPublicKey, (CFTypeRef *)&publicKeyBits);
     */
    return publicKeyBits;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
