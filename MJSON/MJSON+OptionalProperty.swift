// MJSON+OptionalProperty.swift
//
// Copyright (c) 2016 MJ Kim
//

import Foundation

extension MJSON {
    
    public var dictionary: [String : MJSON]? {
        return (source as? [String : Any])?.reduce([String : MJSON]()) { dic, element in
            var dic = dic
            dic[element.key] = MJSON(source: element.value, breadcrumb: Breadcrumb(mjson: self, key: element.key))
            return dic
        }
    }
    
    public var array: [MJSON]? {
        return (source as? [Any])?
            .enumerated()
            .map { MJSON(source: $0.element, breadcrumb: Breadcrumb(mjson: self, index: $0.offset)) }
    }
    
    public var string: String? {
        return source as? String
    }
    
    public var number: NSNumber? {
        return source as? NSNumber
    }
    
    public var double: Double? {
        return number?.doubleValue
    }
    
    public var float: Float? {
        return number?.floatValue
    }
    
    public var int: Int? {
        return number?.intValue
    }
    
    public var uInt: UInt? {
        return number?.uintValue
    }
    
    public var int8: Int8? {
        return number?.int8Value
    }
    
    public var uInt8: UInt8? {
        return number?.uint8Value
    }
    
    public var int16: Int16? {
        return number?.int16Value
    }
    
    public var uInt16: UInt16? {
        return number?.uint16Value
    }
    
    public var int32: Int32? {
        return number?.int32Value
    }
    
    public var uInt32: UInt32? {
        return number?.uint32Value
    }
    
    public var int64: Int64? {
        return number?.int64Value
    }
    
    public var uInt64: UInt64? {
        return number?.uint64Value
    }
    
    public var bool: Bool? {
        return number?.boolValue
    }
    
    public func getOrNil<T>(with decoder: Decoder<T>) -> T? {
        do {
            return try decoder.decode(self)
        } catch {
            return nil
        }
    }
    
    public func getOrNil<T>(_ s: (MJSON) throws -> T) -> T? {
        do {
            return try s(self)
        } catch {
            return nil
        }
    }
}
