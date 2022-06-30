import Apodini
import ApodiniDocumentExport

public enum ExecutionModalityOption: String, Value {
    case standard
    case highPerformance
    case lowPower
}

public struct ExecutionModalityMetadataContextKey: ContextKey {
    public static var defaultValue = ExecutionModalityOption.standard
    public typealias Value = ExecutionModalityOption
}

extension HandlerMetadataNamespace {
    /// Name definition for the ``ExecutionModalityHandlerMetadata``
    public typealias ExecutionModality = ExecutionModalityHandlerMetadata
}

/// The ``ExecutionModalityHandlerMetadata`` can be used to describe the execution modality of a ``Handler``.
///
/// The Metadata is available under the ``HandlerMetadataNamespace/ExecutionModality`` name and can be used like the following:
/// ```swift
/// struct ExampleHandler: Handler {
///     // ...
///     var metadata: Metadata {
///         ExecutionModality(.highPerformance)
///     }
/// }
/// ```
public struct ExecutionModalityHandlerMetadata: HandlerMetadataDefinition {
    public typealias Key = ExecutionModalityMetadataContextKey
    public let value: ExecutionModalityOption
    
    /// Creates a new `ExecutionModality` metadata
    /// - Parameter value: The execution modality option for the Component.
    public init(_ value: ExecutionModalityOption) {
        self.value = value
    }
}

extension Handler {
    /// A `executionModality` modifier can be used to specify the `ExecutionModalityHandlerMetadata` via a `HandlerModifier`.
    /// - Parameter value: The `executionModality` that is used for the `Handler`
    /// - Returns: The modified `Handler` with the `ExecutionModalityHandlerMetadata` added.
    public func executionModality(_ value: ExecutionModalityOption) -> HandlerMetadataModifier<Self> {
        HandlerMetadataModifier(modifies: self, with: ExecutionModalityHandlerMetadata(value))
    }
}
