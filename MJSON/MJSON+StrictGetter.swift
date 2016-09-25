// MJSON+StrictGetter.swift
//
// Copyright (c) 2016 MJ Kim
//

import Foundation

extension MJSON {
    
    public func getDictionary() throws -> [String : MJSON] {
        guard let value = dictionary else {
            throw MJSONError.failedToGetDictionary(source, self)
        }
        return value
    }
    
    public func getArray() throws -> [MJSON] {
        guard let value = array else {
            throw MJSONError.failedToGetArray(source, self)
        }
        return value
    }
    
    public func getNumber() throws -> NSNumber {
        guard let value = number else {
            throw MJSONError.failedToGetNumber(source, self)
        }
        return value
    }
    
    public func getInt() throws -> Int {
        return try getNumber().intValue
    }
    
    public func getInt8() throws -> Int8 {
        return try getNumber().int8Value
    }
    
    public func getInt16() throws -> Int16 {
        return try getNumber().int16Value
    }
    
    public func getInt32() throws -> Int32 {
        return try getNumber().int32Value
    }
    
    public func getInt64() throws -> Int64 {
        return try getNumber().int64Value
    }
    
    public func getUInt() throws -> UInt {
        return try getNumber().uintValue
    }
    
    public func getUInt8() throws -> UInt8 {
        return try getNumber().uint8Value
    }
    
    public func getUInt16() throws -> UInt16 {
        return try getNumber().uint16Value
    }
    
    public func getUInt32() throws -> UInt32 {
        return try getNumber().uint32Value
    }
    
    public func getUInt64() throws -> UInt64 {
        return try getNumber().uint64Value
    }
    
    public func getString() throws -> String {
        guard let value = string else {
            throw MJSONError.failedToGetString(source, self)
        }
        return value
    }
    
    public func getBool() throws -> Bool {
        guard let value = source as? Bool else {
            throw MJSONError.failedToGetBool(source, self)
        }
        return value
    }
    
    public func getFloat() throws -> Float {
        return try getNumber().floatValue
    }
    
    public func getDouble() throws -> Double {
        return try getNumber().doubleValue
    }
    
    public func get<T>(_ s: (MJSON) throws -> T) rethrows -> T {
        do {
            return try s(self)
        } catch {
            throw MJSONError.decodeError(source, self, error)
        }
    }
    
    public func get<T>(with decoder: Decoder<T>) throws -> T {
        do {
            return try decoder.decode(self)
        } catch {
            throw MJSONError.decodeError(source, self, error)
        }
    }
    
}

