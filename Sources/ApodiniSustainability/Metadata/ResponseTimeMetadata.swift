import Apodini

public struct ResponseTimeMetadataContextKey: OptionalContextKey {
    public typealias Value = Int
}

extension HandlerMetadataNamespace {
    /// Name definition for the ``ResponseTimeHandlerMetadata``
    public typealias ResponseTime = ResponseTimeHandlerMetadata
}

/// The ``ResponseTimeHandlerMetadata`` can be used to define a response time requirement.
///
/// The Metadata is available under the ``HandlerMetadataNamespace/ResponseTime`` name and can be used like the following:
/// ```swift
/// struct Greeter: Handler {
///     // ...
///     var metadata: Metadata {
///         ResponseTime(1)
///     }
/// }
/// ```
public struct ResponseTimeHandlerMetadata: HandlerMetadataDefinition {
    public typealias Key = ResponseTimeMetadataContextKey
    public let value: Int
    
    /// Creates a new `ResponseTime` metadata
    /// - Parameter value: The `value` that is used to create the `ResponseTimeHandlerMetadata`.
    public init(value: Int) {
        self.value = value
    }
}

extension Handler {
    /// A `responseTime` modifier can be used to specify the `ResponseTimeHandlerMetadata` via a `HandlerMetadataModifier`.
    /// - Parameter value: The `value` that is used for the `Handler`.
    /// - Returns: The modified `Handler` with the `ResponseTimeHandlerMetadata`.
    public func responseTime(value: Int) -> HandlerMetadataModifier<Self> {
        HandlerMetadataModifier(modifies: self, with: ResponseTimeHandlerMetadata(value: value))
    }
}
