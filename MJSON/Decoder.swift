// Decoder.swift
//
// Copyright (c) 2016 MJ Kim
//

public struct Decoder<T> {
    
    let decode: (MJSON) throws -> T
    
    public init(_ s: @escaping (MJSON) throws -> T) {
        self.decode = s
    }
}
