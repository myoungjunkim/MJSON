// MJSON.swift
//
// Copyright (c) 2016 MJ Kim 
//

public enum MJSONError: Error {
    case notFoundKey(String, MJSON)
    case notFoundIndex(Int, MJSON)
    case failedToGetString(Any, MJSON)
    case failedToGetBool(Any, MJSON)
    case failedToGetNumber(Any, MJSON)
    case failedToGetArray(Any, MJSON)
    case failedToGetDictionary(Any, MJSON)
    case invalidJSONObject
    case decodeError(Any, MJSON, Error)
}

public struct MJSON: CustomDebugStringConvertible, Equatable {
    
    public static func ==(lhs: MJSON, rhs: MJSON) -> Bool {
        return (lhs.source as? NSObject) == (rhs.source as? NSObject)
    }
    
    public static let null = MJSON()
    
    public fileprivate(set) var source: Any
    
    fileprivate let breadcrumb: Breadcrumb?
    
    public init(_ object: MJSONWritableType) {
        source = object.jsonValueBox.source
        breadcrumb = nil
    }
    
    public init(_ object: [MJSONWritableType]) {
        source = object.map { $0.jsonValueBox.source }
        breadcrumb = nil
    }
    
    public init(_ object: [MJSON]) {
        source = object.map { $0.source }
        breadcrumb = nil
    }
    
    public init(_ object: [String : MJSON]) {
        source = object.reduce([String : Any]()) { dictionary, object in
            var dictionary = dictionary
            dictionary[object.key] = object.value.source
            return dictionary
        }
        breadcrumb = nil
    }
    
    public init(_ object: [String : MJSONWritableType]) {
        source = object.reduce([String : Any]()) { dic, element in
            var dic = dic
            dic[element.key] = element.value.jsonValueBox.source
            return dic
        }
        breadcrumb = nil
    }
    
    public init() {
        source = NSNull()
        breadcrumb = nil
    }
    
    public init(data: Data) throws {
        let source = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        self.init(source: source, breadcrumb: nil)
    }
    
    public init(any: Any) throws {
        guard JSONSerialization.isValidJSONObject(any) else {
            throw MJSONError.invalidJSONObject
        }
        self.init(source: any, breadcrumb: nil)
    }
    
    init(source: Any, breadcrumb: Breadcrumb?) {
        self.source = source
        self.breadcrumb = breadcrumb
    }
    
    public func data(options: JSONSerialization.WritingOptions = []) throws -> Data {
        guard JSONSerialization.isValidJSONObject(source) else {
            throw MJSONError.invalidJSONObject
        }
        return try JSONSerialization.data(withJSONObject: source, options: options)
    }
    
    public func currentPath() -> String {
        
        var path: String = ""
        
        var currentBreadcrumb: Breadcrumb? = breadcrumb
        
        while let _currentBreadcrumb = currentBreadcrumb {
            path = _currentBreadcrumb.path + path
            currentBreadcrumb = _currentBreadcrumb.mjson.breadcrumb
        }
        
        return "Root->" + path
    }
    
    public var debugDescription: String {
        return ""
            + "Path:\n\(currentPath())\n"
            + "\n"
            + "Source:\n\(source)"
    }
}

extension MJSON {
    
    final class Breadcrumb: CustomStringConvertible, CustomDebugStringConvertible {
        
        let mjson: MJSON
        let path: String
        
        init(mjson: MJSON, key: String) {
            self.mjson = mjson
            self.path = "[\"\(key)\"]"
        }
        
        init(mjson: MJSON, index: Int) {
            self.mjson = mjson
            self.path = "[\(index)]"
        }
        
        var description: String {
            return "\(path)"
        }
        
        var debugDescription: String {
            return "\(path)\n\(mjson)"
        }
    }
}

extension MJSON {
    
    /// 키가 없는 경우, MJSON.null 리턴
    public subscript (key: String) -> MJSON {
        get {
            return (source as? [String : Any])
                .flatMap { $0[key] }
                .map { MJSON(source: $0, breadcrumb: Breadcrumb(mjson: self, key: key)) } ?? MJSON.null
        }
        set {
            if source is NSNull {
                source = [String : Any]()
            }
            
            guard var dictionary = source as? [String : Any] else {
                return
            }
            dictionary[key] = newValue.source
            source = dictionary
        }
    }
    
    /// 인덱스가 없는 경우 MJSON.null 리턴
    public subscript (index: Int) -> MJSON {
        get {
            return (source as? [Any])
                .flatMap { $0[index] }
                .map { MJSON(source: $0, breadcrumb: Breadcrumb(mjson: self, index: index)) } ?? MJSON.null
        }
        set {
            
            if source is NSNull {
                source = [Any]()
            }
            
            guard var array = source as? [Any] else {
                return
            }
            array[index] = newValue.source
            source = array
        }
    }
}

/// MJSON 계층 제어
extension MJSON {
    
    private func next(_ key: String) throws -> MJSON {
        guard !(self[key].source is NSNull) else {
            throw MJSONError.notFoundKey(key, self)
        }
        return self[key]
    }
    
    // type이 Dictionary인 경우 MJSON 객체 리턴은 dictionary[key] 외 MJSONError 처리
    public func next(_ key: String...) throws -> MJSON {
        return try key.reduce(self) { mjson, key -> MJSON in
            try mjson.next(key)
        }
    }
    
    // type이 Array인 경우 MJSON 객체 리턴은 array[index] 외 MJSONError 처리
    public func next(_ index: Int) throws -> MJSON {
        guard !(self[index].source is NSNull) else {
            throw MJSONError.notFoundIndex(index, self)
        }
        return self[index]
    }
    
    // MJSON 상위로 self인 경우 MJSON상위로 리턴하고 self리턴함
    public func back() -> MJSON {
        return breadcrumb?.mjson ?? self
    }
}

extension MJSON: Swift.ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self.init()
    }
}

extension MJSON: Swift.ExpressibleByStringLiteral {
    
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self.init(value)
    }
    
    public init(unicodeScalarLiteral value: StringLiteralType) {
        self.init(value)
    }
}

extension MJSON: Swift.ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(value)
    }
}

extension MJSON: Swift.ExpressibleByBooleanLiteral {
    
    public init(booleanLiteral value: BooleanLiteralType) {
        self.init(value)
    }
}

extension MJSON: Swift.ExpressibleByFloatLiteral {
    
    public init(floatLiteral value: FloatLiteralType) {
        self.init(value)
    }
}

extension MJSON: Swift.ExpressibleByDictionaryLiteral {
    
    public init(dictionaryLiteral elements: (String, MJSON)...) {
        let dictionary = elements.reduce([String : MJSON]()) { dic, element in
            var dic = dic
            dic[element.0] = element.1
            return dic
        }
        self.init(dictionary)
    }
}

extension MJSON: Swift.ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: MJSON...) {
        self.init(elements)
    }
}
