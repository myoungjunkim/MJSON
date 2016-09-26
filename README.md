# MJSON
간단하고 확장가능한 JSON 라이브러리 (Swift 3.0 기준)

SwiftyJSON이 Swift 3.0을 지원하는게 좀처럼 빠르게 되고 있지 않아서 몇가지 생각난 것들과 같이 정리하여 JSON 라이브러리를 회사에서 내부적으로 사용하기 위해 만들었습니다.
이름은 MJSON (MJ가 만든 JOSN 라이브러리라는 의미 ㅡ_ㅡ;)입니다.

SwiftyJSON과 같은 사용성이 높은 Easy-Read와 try-catch를 이용한 엄격한 값을 얻을 수 있도록 Strict-Read를 지원합니다.

# 사용방법
## JSON 읽어오기
### 쉬운 방법

```swift
let urlString: String? = mjson[3]["shot"]["images"]["3x_image"].string
```

### 엄격한 방법 (try-catch)

값이 없는 경우, 'MJSONError' 보내어 실패위치는 MJSONError에서 확인

값 얻기 (String, Bool, Number)

```swift
let id: String = try mjson
       .next(0)
       .next("id")
       .getString()
```

** 디코더한 값 얻기 (사용자지정 객체)**<br>
디코더를 사용한 사용자 정의 각체 변환을 할 수 있고 throwable

```swift
let urlDecoder = Decoder<URL> { (mjson) throws -> URL in
    URL(string: try mjson.getString())!
}

let imageURL: URL = try mjson
       .next(0)
       .next("image")
       .next("3x_image")
       .get(with: urlDecoder)
```

**기본 Getter**

엄격한 겟터

```swift
extension MJSON {
    public func getDictionary() throws -> [String : MJSON]
    public func getArray() throws -> [MJSON]
    public func getNumber() throws -> NSNumber
    public func getInt() throws -> Int
    public func getInt8() throws -> Int8
    public func getInt16() throws -> Int16
    public func getInt32() throws -> Int32
    public func getInt64() throws -> Int64
    public func getUInt() throws -> UInt
    public func getUInt8() throws -> UInt8
    public func getUInt16() throws -> UInt16
    public func getUInt32() throws -> UInt32
    public func getUInt64() throws -> UInt64
    public func getString() throws -> String
    public func getBool() throws -> Bool
    public func getFloat() throws -> Float
    public func getDouble() throws -> Double
}

///
extension MJSON {
    public func get<T>(_ s: (MJSON) throws -> T) rethrows -> T
    public func get<T>(with decoder: Decoder<T>) throws -> T
}
```

Optional 읽기전용 속성
```swift
extension MJSON {
    public var dictionary: [String : Any]? { get }
    public var array: [Any]? { get }
    public var string: String? { get }
    public var number: NSNumber? { get }
    public var double: Double? { get }
    public var float: Float? { get }
    public var int: Int? { get }
    public var uInt: UInt? { get }
    public var int8: Int8? { get }
    public var uInt8: UInt8? { get }
    public var int16: Int16? { get }
    public var uInt16: UInt16? { get }
    public var int32: Int32? { get }
    public var uInt32: UInt32? { get }
    public var int64: Int64? { get }
    public var uInt64: UInt64? { get }
    public var bool: Bool? { get }
}
```

#### MJSON 초기화

```swift
let jsonData: Data = ...
let mjson = try MJSON(data: jsonData)
```

```swift
let jsonData: Data
let json: Any = try JSONSerialization.jsonObject(with: data, options: [])
let mjson = try MJSON(any: json)
```

```swift
let userInfo: [AnyHashable: Any]
let mjson = try MJSON(any: json)
```

```swift
let objects: [Any]
let mjson = try MJSON(any: json)
```

필요하지 않는 경우

```swift
let object: [String : MJSON]
let mjson = MJSON(object)
```

```swift
let object: [MJSON]
let mjson = MJSON(object)
```

```swift
let object: [MJSONWritableType]
let mjson = MJSON(object)
```

```swift
let object: [String : MJSONWritableType]
let mjson = MJSON(object)
```
---

## 현재 경로 얻기(디버깅 정보)

```swift

let path = try mjson
    .next(0)
    .next("image")        
    .next("3x_image")
    .currentPath()    

// path => "[0]["image"]["hidpi_image"]"
```

## JSON 계층 되돌아가기

```swift

try jayson
    .next(0)
    .next("image")
    .back() // <---
    .next("image")
    .next("3x_image")

```

### JSON 생성

```swift
var mjson = MJSON()
mjson["id"] = 1234
mjson["active"] = true
mjson["name"] = "MJ"

var images = [String:MJSON]()
images["large"] = "https://...1"
images["medium"] = "https://...2"
images["small"] = "https://...3"

mjson["images"] = MJSON(images)

let data = try mjson.data(options: .prettyPrinted)
```

-> data
```
{
  "name" : "MJ",
  "active" : true,
  "id" : 1234,
  "images" : {
    "large" : "https:\/\/...1",
    "small" : "https:\/\/...2",
    "medium" : "https:\/\/...3"
  }
}
```

#### MJSON 변환예제

```swift
var mjson = MJSON()

mjson["String"] = "String"
mjson["NSString"] = MJSON("NSString" as NSString)
mjson["NSNumber"] = NSNumber(value: 0)
mjson["Int"] = 64
mjson["Int8"] = MJSON(8 as Int8)
mjson["Int16"] = MJSON(16 as Int16)
mjson["Int32"] = MJSON(32 as Int32)
mjson["Int64"] = MJSON(64 as Int64)

mjson["UInt"] = MJSON(64 as UInt)
mjson["UInt8"] = MJSON(8 as UInt8)
mjson["UInt16"] = MJSON(16 as UInt16)
mjson["UInt32"] = MJSON(32 as UInt32)
mjson["UInt64"] = MJSON(64 as UInt64)

mjson["Bool_true"] = true
mjson["Bool_false"] = false

mjson["Float"] = MJSON(1.0 / 3.0 as Float)
mjson["Double"] = MJSON(1.0 / 3.0 as Double)
mjson["CGFloat"] = MJSON(1.0 / 3.0 as CGFloat)
```

## 요구사항

Swift **3.0** iOS, macOS 

## 설치

준비중...

## 작성자

MJ Kim, myoungjun.kim@gmail.com

## License

MJSON is available under the MIT license. See the LICENSE file for more info.
