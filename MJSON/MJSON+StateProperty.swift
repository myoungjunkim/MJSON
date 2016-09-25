// MJSON+StateProperty.swift
//
// Copyright (c) 2016 MJ Kim
//

import Foundation

extension MJSON {
    
    public var isNull: Bool {
        return source is NSNull
    }
    
    public var isDictionary: Bool {
        return source is [String : Any]
    }
    
    public var isArray: Bool {
        return source is [Any]
    }
}
