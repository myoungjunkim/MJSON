// MJSONWritableType.swift
//
// Copyright (c) 2016 MJ Kim
//

import Foundation

public struct MJSONValueBox {
    
    public let source: Any
    
    public init(_ object: NSNull) {
        self.source = object
    }
    
    public init(_ object: String) {
        self.source = object
    }
    
    public init(_ object: NSString) {
        self.source = object
    }
    
    public init(_ object: NSNumber) {
        self.source = object
    }
    
    public init(_ object: Int) {
        self.source = object
    }
    
    public init(_ object: Float) {
        self.source = object
    }
    
    public init(_ object: Double) {
        self.source = object
    }
    
    public init(_ object: Bool) {
        self.source = object
    }
}

public protocol MJSONWritableType {
    
    var jsonValueBox: MJSONValueBox { get }
}

extension NSNull: MJSONWritableType {
    public var jsonValueBox: MJSONValueBox {
        return MJSONValueBox(self)
    }
}

extension String: MJSONWritableType {
    public var jsonValueBox: MJSONValueBox {
        return MJSONValueBox(self)
    }
}

extension NSString: MJSONWritableType {
    public var jsonValueBox: MJSONValueBox {
        return MJSONValueBox(self)
    }
}

extension NSNumber: MJSONWritableType {
    public var jsonValueBox: MJSONValueBox {
        return MJSONValueBox(self)
    }
}

extension Int: MJSONWritableType {
    public var jsonValueBox: MJSONValueBox {
        return MJSONValueBox(self)
    }
}

extension Float: MJSONWritableType {
    public var jsonValueBox: MJSONValueBox {
        return MJSONValueBox(self)
    }
}

extension Double: MJSONWritableType {
    public var jsonValueBox: MJSONValueBox {
        return MJSONValueBox(self)
    }
}

extension Bool: MJSONWritableType {
    public var jsonValueBox: MJSONValueBox {
        return MJSONValueBox(self)
    }
}

extension Int8: MJSONWritableType {
    public var jsonValueBox: MJSONValueBox {
        return MJSONValueBox(NSNumber(value: self))
    }
}

extension Int16: MJSONWritableType {
    public var jsonValueBox: MJSONValueBox {
        return MJSONValueBox(NSNumber(value: self))
    }
}

extension Int32: MJSONWritableType {
    public var jsonValueBox: MJSONValueBox {
        return MJSONValueBox(NSNumber(value: self))
    }
}

extension Int64: MJSONWritableType {
    public var jsonValueBox: MJSONValueBox {
        return MJSONValueBox(NSNumber(value: self))
    }
}

extension UInt: MJSONWritableType {
    public var jsonValueBox: MJSONValueBox {
        return MJSONValueBox(NSNumber(value: self))
    }
}

extension UInt8: MJSONWritableType {
    public var jsonValueBox: MJSONValueBox {
        return MJSONValueBox(NSNumber(value: self))
    }
}

extension UInt16: MJSONWritableType {
    public var jsonValueBox: MJSONValueBox {
        return MJSONValueBox(NSNumber(value: self))
    }
}

extension UInt32: MJSONWritableType {
    public var jsonValueBox: MJSONValueBox {
        return MJSONValueBox(NSNumber(value: self))
    }
}

extension UInt64: MJSONWritableType {
    public var jsonValueBox: MJSONValueBox {
        return MJSONValueBox(NSNumber(value: self))
    }
}

