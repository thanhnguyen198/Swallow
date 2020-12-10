//
// Copyright (c) Vatsal Manot
//

import Swift

extension Decoder {
    public func decodeSingleValueNil() throws -> Bool {
        let container = try singleValueContainer()
        
        return container.decodeNil()
    }
    
    public func decode<T: Decodable>(single type: T.Type = T.self) throws -> T {
        let container = try singleValueContainer()
        
        return try container.decode(T.self)
    }
    
    public func decodeUnkeyedNil() throws -> Bool {
        var container = try unkeyedContainer()
        
        return try container.decodeNil()
    }
    
    public func decode<T: Decodable>(first type: T.Type = T.self) throws -> T {
        var container = try unkeyedContainer()
        
        return try container.decode(T.self)
    }
    
    public func decodeKeyedNil() throws -> Bool {
        let container = try self.container(keyedBy: AnyStringKey.self)
        
        return container.allKeys.isEmpty
    }
    
    public func decode<T: Decodable, Key: CodingKey>(_ type: T.Type = T.self, forKey key: Key) throws -> T {
        let container = try self.container(keyedBy: Key.self)
        
        return try container.decode(T.self, forKey: key)
    }
}

extension Decoder {
    public func decodeNil() throws -> Bool {
        let isSingleNil = try? decodeSingleValueNil()
        let isUnkeyedNil = try? decodeUnkeyedNil()
        let isKeyedNil = try? decodeKeyedNil()
        
        if isSingleNil == nil && isUnkeyedNil == nil && isKeyedNil == nil {
            throw DecodeNilError.failedToDecodeNil
        } else {
            return (isSingleNil ?? false) || (isUnkeyedNil ?? false) || (isKeyedNil ?? false)
        }
    }
}

// MARK: - Auxiliary Implementation -

private enum DecodeNilError: Error {
    case failedToDecodeNil
}