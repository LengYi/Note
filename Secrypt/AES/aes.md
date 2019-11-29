# AES 加解密

## AES规则
原输入数据不够16字节的整数位时，就要补齐。因此就会有padding，若使用不同的padding，那么加密出来的结果也会不一样。

## 填充模式

~~~
1、ANSI X.923

在ANSI X.923的方式下，先是填充00，最后一个字节填充padded的字节个数。

例子： | DD DD DD DD DD DD DD DD | DD DD DD 00 00 00 00 05 |

2、ISO 10126
在ISO 10126的方式下，先是填充随机值，最后一个字节填充padded的字节个数。

例子： | DD DD DD DD DD DD DD DD | DD DD DD 95 81 28 A7 05 |

3、PKCS7

在PKCS7的方式下，如果一共需要padded多少个字节，所有填充的地方都填充这个值。

例子： | DD DD DD DD DD DD DD DD | DD DD DD 05 05 05 05 05 |

4、ISO/IEC 7816-4

在ISO/IEC 7816-4方式下，第一个填充的字节是80，后面的都填充00。

例子： | DD DD DD DD DD DD DD DD | DD DD DD 80 00 00 00 00 |

5、Zero padding

在Zero padding方式下，每一个需要填充的字节都填00。

例子： | DD DD DD DD DD DD DD DD | DD DD DD 00 00 00 00 00 |
~~~

## PKCS5/PKCS7
在分组加密算法中，我们首先要将原文进行分组，然后每个分组进行加密，然后组装密文。

假设我们现在的数据长度是24字节，BlockSize是8字节，那么很容易分成3组，一组8字节；
考虑过一个问题没，如果现有的待加密数据不是BlockSize的整数倍，那该如何分组？
例如，有一个17字节的数据，BlockSize是8字节，怎么分组？
我们可以对原文进行填充（padding），将其填充到8字节的整数倍！
假设使用PKCS#5进行填充（以下都是以PKCS#5为示例），BlockSize是8字节（64bit)

假设待加密数据长度为x，那么将会在后面padding的字节数目为8-(x%8)，每个padding的字节值是8-(x%8)。

特别地，当待加密数据长度x恰好是8的整数倍，也是要在后面多增加8个字节，每个字节是0x08。

PKCS#5的实现：

~~~
static size_t padding(unsigned char *src, size_t srcLen)
{
    // PKCS#5
    size_t paddNum = 8 - srcLen % 8;

    for (int i = 0; i < paddNum; ++i) {
        src[srcLen + i] = paddNum;
    }   
    return srcLen + paddNum;
}
~~~

## PKCS5以及PKCS7的区别
~~~
PKCS#5在填充方面，是PKCS#7的一个子集：
PKCS#5只是对于8字节（BlockSize=8）进行填充，填充内容为0x01-0x08；
但是PKCS#7不仅仅是对8字节填充，其BlockSize范围是1-255字节。
所以，PKCS#5可以向上转换为PKCS#7，但是PKCS#7不一定可以转换到PKCS#5（用PKCS#7填充加密的密文，用PKCS#5解出来是错误的）。
~~~

## AES在线加解密网站
[链接](http://www.seacha.com/tools/aes.html)

苹果提供给我们的API只有这一个函数用来加密或者解密：

~~~
CCCryptorStatus CCCrypt(
    CCOperation op,        /* kCCEncrypt, etc. */
    CCAlgorithm alg,        /* kCCAlgorithmAES128, etc. */
    CCOptions options,      /* kCCOptionPKCS7Padding, etc. */
    const void *key,
    size_tkeyLength,
    const void *iv,        /* optional initialization vector */
    const void *dataIn,    /* optional per op and alg */
    size_t dataInLength,
    void *dataOut,          /* data RETURNED here */
    size_t dataOutAvailable,
    size_t *dataOutMoved)
    __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_2_0);
~~~

+ 其中第一个 CCOperation 只有两个值，kCCEncrypt 表示加密，kCCDecrypt 表示解密。
+ 第二个参数表示加密的算法，它只有以下向种类型：

~~~
enum {
    kCCAlgorithmAES128 = 0,
    kCCAlgorithmAES = 0,
    kCCAlgorithmDES,
    kCCAlgorithm3DES,      
    kCCAlgorithmCAST,      
    kCCAlgorithmRC4,
    kCCAlgorithmRC2,  
    kCCAlgorithmBlowfish    
};
typedef uint32_tCCAlgorithm;
~~~

这里使用的是 kCCAlgorithmAES128 表示使用AES128位加密。

+ 第三个参数表示选项，这里使用的是 kCCOptionECBMode ，表示ECB：

~~~
enum {
    /* options for block ciphers */
    kCCOptionPKCS7Padding  = 0x0001,
    kCCOptionECBMode        = 0x0002
    /* stream ciphers currently have no options */
};
typedef uint32_tCCOptions;
~~~

+ 第四个参数表示加密/解密的密钥。
+ 第五个参数keyLength表示密钥的长度。
+ 第六个参数iv是个固定值，通过直接使用密钥即可。大家一定要注视这个参数，如果安卓、服务端和iOS端不统一，那么加密结果就会不一样，解密可能能解出来，但是解密后在末尾会出现一些\0、\t之类的。
+ 第七个参数dataIn表示要加密/解密的数据。
+ 第八个参数dataInLength表示要加密/解密的数据的长度。
+ 第九个参数dataOut用于接收加密后/解密后的结果。
+ 第十个参数dataOutAvailable表示加密后/解密后的数据的长度。
+ 第十一个参数dataOutMoved表示实际加密/解密的数据的长度。（因为有补齐）

## 加密算法 （No Padding）

~~~
+ (NSString *)hyb_AESEncrypt:(NSString *)plainTextpassword:(NSString *)key {
  if (key == nil || (key.length != 16 && key.length != 32)) {
    return nil;
  }
  
  char keyPtr[kCCKeySizeAES128+1];
  memset(keyPtr, 0, sizeof(keyPtr));
  [keygetCString:keyPtrmaxLength:sizeof(keyPtr)encoding:NSUTF8StringEncoding];
  
  
  char ivPtr[kCCBlockSizeAES128+1];
  memset(ivPtr, 0, sizeof(ivPtr));
  [keygetCString:ivPtrmaxLength:sizeof(ivPtr)encoding:NSUTF8StringEncoding];
  
  NSData* data = [plainTextdataUsingEncoding:NSUTF8StringEncoding];
  NSUInteger dataLength = [datalength];
  
  int diff = kCCKeySizeAES128 - (dataLength % kCCKeySizeAES128);
  unsigned long newSize = 0;
  
  if(diff > 0) {
    newSize = dataLength + diff;
  }
  
  char dataPtr[newSize];
  memcpy(dataPtr, [databytes], [datalength]);
  for(int i = 0; i < diff; i++) {
    // 这里是关键，这里是使用NoPadding的
    dataPtr[i + dataLength] = 0x0000;
  }
  
  size_tbufferSize = newSize + kCCBlockSizeAES128;
  void *buffer = malloc(bufferSize);
  memset(buffer, 0, bufferSize);
  
  size_tnumBytesCrypted = 0;
  
  CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                        kCCAlgorithmAES128,
                                        kCCOptionECBMode,
                                        [keyUTF8String],
                                        kCCKeySizeAES128,
                                        ivPtr,
                                        dataPtr,
                                        sizeof(dataPtr),
                                        buffer,
                                        bufferSize,
                                        &numBytesCrypted);
  
  if (cryptStatus == kCCSuccess) {
    NSData *resultData = [NSDatadataWithBytesNoCopy:bufferlength:numBytesCrypted];
    return [GTMBase64stringByEncodingData:resultData];
  }
  
  free(buffer);
  return nil;
}
~~~

## 解密算法

~~~
+ (NSString *)hyb_AESDecrypt:(NSString *)encryptTextpassword:(NSString *)key {
  if (key == nil || (key.length != 16 && key.length != 32)) {
    return nil;
  }
  
  char keyPtr[kCCKeySizeAES128 + 1];
  memset(keyPtr, 0, sizeof(keyPtr));
  [keygetCString:keyPtrmaxLength:sizeof(keyPtr)encoding:NSUTF8StringEncoding];
  
  char ivPtr[kCCBlockSizeAES128 + 1];
  memset(ivPtr, 0, sizeof(ivPtr));
  [keygetCString:ivPtrmaxLength:sizeof(ivPtr)encoding:NSUTF8StringEncoding];
  
  NSData *data = [GTMBase64decodeData:[encryptTextdataUsingEncoding:NSUTF8StringEncoding]];
  NSUInteger dataLength = [datalength];
  size_tbufferSize = dataLength + kCCBlockSizeAES128;
  void *buffer = malloc(bufferSize);
  
  size_tnumBytesCrypted = 0;
  CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                        kCCAlgorithmAES128,
                                        kCCOptionECBMode,
                                        [keyUTF8String],
                                        kCCBlockSizeAES128,
                                        ivPtr,
                                        [databytes],
                                        dataLength,
                                        buffer,
                                        bufferSize,
                                        &numBytesCrypted);
  if (cryptStatus == kCCSuccess) {
    NSData *resultData = [NSDatadataWithBytesNoCopy:bufferlength:numBytesCrypted];
    
    NSString *decoded=[[NSString alloc]initWithData:resultDataencoding:NSUTF8StringEncoding];
    return decoded;
  }
  
  free(buffer);
  return nil;
}
~~~