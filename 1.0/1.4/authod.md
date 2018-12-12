## HTTP 请求校验方案
### 问题
1. 这个请求是私钥持有者发起的
2. 对body进行hash校验确保这个请求体没有被窜改过
3. 添加过期时间防止抓包进行重放攻击

### 实现
所有API请求头包含Authorization header，Authorization header 的格式如下:

~~~
Authorization: BEC wid={wallet ID}&expire={expire timestamp}&payload_hash={payload hash}&signature={signature}
~~~

保证“BEC”字符串后面只有一个空格。BEC后面的字符串使用 x-www-form-urlencoded 编码。

参数内容如下：

+ wallet ID: 子 public key 的压缩格式(base16 编码, 长度为 66 字节), 生成路径为 m/1/1
+ expire timestamp: unix epoch second. 请求有效截止时间戳.
+ payload hash: hex_encode(sha256(request body)) 或 如果没有请求体则设置为空字符串(比如 GET 请求), 服务端会验证收到的请求体哈希是否匹配.
+ signature: 请求认证的签名, 具体见下面一段.
signature 的生成使用 wallet ID 对应的 privkey 签名(ECDSA, SECP256k1 曲线)如下字段的 sha256, 格式如下:

~~~
urlsafe_base64encode(ecdsa_sign(sha256({expire}\n{payload_hash}\n{HTTP Method}\n{path}\n{raw_query})))
(raw_query 为 url-encoded 后的 query)
~~~

~~~
  private static func getBTCHeaders(privateKey: String, urlStr: String, method: HTTPMethod, params: [String: Any]) -> HTTPHeaders? {
            var urlRequest: URLRequest
            do {
                urlRequest = try URLRequest(url: urlStr, method: .post, headers: nil)
            } catch {
                print(error)
                return nil
            }

            guard let url = urlRequest.url else {
                return nil
            }
            guard let signKey = BTKey(privateKey: privateKey) else {
                return nil
            }
            var baseHeaders = [String: String]()
            let expire = String(Date.getCurrentTimeStamp() + Int64(5*60))
            guard let pubKey = signKey.publicKey else {
                print("getBTCHeaders failed key error")
                return nil
            }
            var payloadHash = ""
            if method == .post {
                if let httpBody = query(params).data(using: .utf8, allowLossyConversion: false) {
                    payloadHash = httpBody.sha256().hexString
                }
            }
            var rawDataStr: String = "\(expire)\n\(payloadHash)\n\(method.rawValue)\n\(url.path)\n"
            if method == .get {
                // get method url里面是有query的，post没有
                rawDataStr = rawDataStr + query(params)
            }
            let hashData = rawDataStr.data(using: .utf8, allowLossyConversion: false)?.sha256()
            let signature = signKey.sign(hashData).base64URLEncodedString()
// 公钥 + 过期时间 + body 哈希值 + body 哈希值使用公钥签名
            let author = "BEC wid=\(pubKey.hexString)&expire=\(expire)&payload_hash=\(payloadHash)&signature=\(signature)"
            baseHeaders["Authorization"] = author
            return baseHeaders
        }
~~~