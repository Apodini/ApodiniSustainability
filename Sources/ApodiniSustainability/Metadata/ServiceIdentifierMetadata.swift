import Apodini

public struct ServiceIdentifierMetadataContextKey: OptionalContextKey {
    public typealias Value = String
}

extension ComponentMetadataNamespace {
    /// Name definition for the ``ServiceIdentifierComponentMetadata``
    public typealias ServiceIdentifier = ServiceIdentifierComponentMetadata
}

/// The ``ServiceIdentifierComponentMetadata`` can be used to define a service identifier.
///
/// The Metadata is available under the ``ComponentMetadataNamespace/ServiceIdentifier`` name and can be used like the following:
/// ```swift
/// struct Greeter: Component {
///     // ...
///     var metadata: Metadata {
///         ServiceIdentifier("greeter")
///     }
/// }
/// ```
public struct ServiceIdentifierComponentMetadata: ComponentMetadataDefinition {
    public typealias Key = ServiceIdentifierMetadataContextKey
    public let value: String
    
    /// Creates a new `ServiceIdentifier` metadata
    /// - Parameter value: The `value` that is used to create the `ServiceIdentifierComponentMetadata`.
    public init(_ value: String) {
        self.value = value
    }
}

extension Component {
    /// A `serviceIdentifier` modifier can be used to specify the `ServiceIdentifierComponentMetadata` via a `ComponentMetadataModifier`.
    /// - Parameter value: The `value` that is used for the `Component`.
    /// - Returns: The modified `Component` with the `ServiceIdentifierComponentMetadata`.
    public func serviceIdentifier(_ value: String) -> ComponentMetadataModifier<Self> {
        ComponentMetadataModifier(modifies: self, with: ServiceIdentifierComponentMetadata(value))
    }
}
