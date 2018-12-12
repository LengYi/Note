### 网络请求接口说明文档书写格式
## API返回结果格式
+ 正常情况下返回json字符串：返回结果为空或者无法正常解析为json对象，则视为“系统错误”
+ 注意，文档中提到的返回结果包含的字段都不能保证一定会存在
+ API返回结果定义：API返回结果
+ API错误码定义详见：API错误码

## API说明

~~~
  1. 外网主API （ https://xxx.xxx.com ）
  2. 外网行情API （ https://xxx.xxx.com ）
  3. 内网API （ https://xxx.xxx.com ）
~~~

请求总超时请默认配置为20秒，若接口WIKI中有特殊说明的超时，请参照特殊接口说明配置

# 完整接口示例
## favorite/list
获取当前首页收藏数字资产列表

## URL
https://api.xxx.com/favorite/list.json

## 支持格式
JSON

## HTTP请求方式
GET

## 是否需要登录
否
关于登录授权，待定

## 请求header
|   | 必选  | 类型及范围 | 说明 |
|:------------- |:---------------:| -------------:| -------------:|
| Cookie      | false |         string | 请透传服务端返回的Cookie，用于会话识别，有则传没有则不传 |
| access-token      | true        |           string | 用户授权的access-token|

## 请求参数
|   | 必选  | 类型及范围 | 说明 |
|:------------- |:---------------:| -------------:| -------------:|
| app_version      | false |         string | 客户端版本，必须做URLencode，内容不超过140个汉字，如1.0.0。 |
| language      | false        |           string | 客户端语言版本，zh-Hans：简体中文、zh-Hant：繁体中文、en：英文、ja: 日语、th 泰语、 id 印尼 ，默认为en（若传不在此列表内的语言值，也默认为en）。|
| os_version	      | false |         string | 客户端操作系统版本号，如10.1.1|

## 注意事项

## 返回结果
JSON示例

~~~
{
   "meta": {
       "code": 0,
       "message": "",
       "request_uri": "/favorite_token/list.json",
       "request_id": "4531a395677cc7b2c3d68709bdb99ef5d9b96860"
   },
   "response": {
        "data": [
             {
                   "id":  100 ,
                   "name": "Foundation",
                   "chain_type": 2,
                   "issuer": null,
                   "total_supply": null,
                   "unit": "ether",
                   "symbol": "ETH",
                   "decimals": 18,
                   "description": null,
                   "icon_url": "https://xxx.png",
                   "type": 1 , 
                   "extension" : {  //扩展字段
                       "gas": null
                   }
               },
                            {
                   "id":  101 ,
                   "name": "Foundation",
                   "chain_type": 2,
                   "issuer": null,
                   "total_supply": null,
                   "unit": "ether",
                   "symbol": "ETH",
                   "decimals": 18,
                   "description": null,
                   "icon_url": "https://xxx.png",
                   "type": 1 , 
                   "extension" : {  //扩展字段
                       "gas": null
                   }
               }
               ...
         ]
   }
}
~~~

## 返回字段说明
|   | 类型 | 说明 |
|:------------- |:---------------:| -------------:| -------------:|
| id      | int | 数字ID | 
| name      | string        | 资产名称 |
| chain_type      | string        | 链类型 |
| extension      | object        | 链类型 |

## API错误码
| 错误码  | 业务类型 | 中文错误提示 |
|:------------- |:---------------:| -------------:| -------------:|
| 400      | 无效请求 | 请求参数无效 | 
| 401      | 无效请求        | 未授权的请求 |
| 404      | 无效请求        | API接口不存在 |
| 405      | 无效请求        | API方法不允许调用 |