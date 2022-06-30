import Apodini

public struct OptionalMetadataContextKey: OptionalContextKey {
    public typealias Value = Bool
}

extension ComponentMetadataNamespace {
    /// Name definition for the ``OptionalComponentMetadataMetadata``
    public typealias Optional = OptionalComponentMetadata
}

/// The ``OptionalComponentMetadataMetadata`` can be used to declare a ``Component`` optional.
///
/// The Metadata is available under the ``ComponentMetadataNamespace/Optional`` name and can be used like the following:
/// ```swift
/// struct ExampleComponent: Component {
///     // ...
///     var metadata: Metadata {
///         Optional()
///     }
/// }
/// ```
public struct OptionalComponentMetadata: ComponentMetadataDefinition {
    public typealias Key = OptionalMetadataContextKey
    public let value: Bool
    
    /// Creates a new `Optional` metadata
    public init() {
        self.value = true
    }
    
    /// Creates a new `Optional` metadata
    /// - Parameter value: The `value` that is used to create the `OptionalComponentMetadata`.
    /// - Note: This is used to create the `OptionalComponentMetadata` in the `optional` modifier.
    fileprivate init(_ value: Bool) {
        self.value = value
    }
}

extension Component {
    /// A `optional` modifier can be used to specify the `OptionalComponentMetadata` via a `ComponentMetadataModifier`.
    /// - Parameter value: The `value` that is used for the `Component`.
    /// - Returns: The modified `Component` with the `OptionalComponentMetadata`.
    public func optional(_ value: Bool) -> ComponentMetadataModifier<Self> {
        ComponentMetadataModifier(modifies: self, with: OptionalComponentMetadata(value))
    }
}
