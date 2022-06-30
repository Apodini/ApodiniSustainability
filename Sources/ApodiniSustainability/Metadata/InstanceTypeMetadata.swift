import Apodini
import ApodiniDocumentExport

public enum InstanceTypeOption: String, Value {
    case large
    case medium
    case small
}

public struct InstanceTypeMetadataContextKey: OptionalContextKey {
    public typealias Value = InstanceTypeOption
}

extension HandlerMetadataNamespace {
    /// Name definition for the ``InstanceTypeHandlerMetadata``
    public typealias InstanceType = InstanceTypeHandlerMetadata
}

/// The ``InstanceTypeHandlerMetadata`` can be used to describe the instance type of a ``Handler``.
///
/// The Metadata is available under the ``HandlerMetadataNamespace/InstanceType`` name and can be used like the following:
/// ```swift
/// struct ExampleHandler: Handler {
///     // ...
///     var metadata: Metadata {
///         InstanceType(.small)
///     }
/// }
/// ```
public struct InstanceTypeHandlerMetadata: HandlerMetadataDefinition {
    public typealias Key = InstanceTypeMetadataContextKey
    public let value: InstanceTypeOption
    
    /// Creates a new `InstanceType` metadata
    /// - Parameter value: The instance type option for the Component.
    public init(_ value: InstanceTypeOption) {
        self.value = value
    }
}

extension Handler {
    /// A `instanceType` modifier can be used to specify the `InstanceTypeHandlerMetadata` via a `HandlerModifier`.
    /// - Parameter value: The `instanceType` that is used for the `Handler`
    /// - Returns: The modified `Handler` with the `InstanceTypeHandlerMetadata` added.
    public func instanceType(_ value: InstanceTypeOption) -> HandlerMetadataModifier<Self> {
        HandlerMetadataModifier(modifies: self, with: InstanceTypeHandlerMetadata(value))
    }
}
