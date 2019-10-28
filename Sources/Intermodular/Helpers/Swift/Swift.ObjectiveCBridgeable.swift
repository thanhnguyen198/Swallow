//
// Copyright (c) Vatsal Manot
//

import Swift

public protocol ObjectiveCBridgeable: _ObjectiveCBridgeable where _ObjectiveCType == ObjectiveCType {
    associatedtype _ObjectiveCType = ObjectiveCType
    associatedtype ObjectiveCType

    static func bridgeFromObjectiveC(_ source: ObjectiveCType) throws -> Self

    func bridgeToObjectiveC() throws -> ObjectiveCType
}

// MARK: - Implementation -

extension ObjectiveCBridgeable {
    @inlinable
    public func _bridgeToObjectiveC() -> _ObjectiveCType {
        return try! bridgeToObjectiveC()
    }

    @inlinable
    public static func _forceBridgeFromObjectiveC(_ source: _ObjectiveCType, result: inout Self?) {
        try! _conditionallyBridgeFromObjectiveC(source, result: &result).throwSelfIfFalse()
    }

    @discardableResult
    @inlinable
    public static func _conditionallyBridgeFromObjectiveC(_ source: _ObjectiveCType, result: inout Self?) -> Bool {
        result = try? bridgeFromObjectiveC(source)

        return result != nil
    }

    @inlinable
    public static func _unconditionallyBridgeFromObjectiveC(_ source: _ObjectiveCType?) -> Self {
        guard let source = source else {
            return (self as! Initiable.Type).init() as! Self
        }

        return try! bridgeFromObjectiveC(source)
    }
}
