import Apodini

// MARK: - SustainabilityDocumentConfiguration
/// An object that holds export options of the `ApodiniSustainability` document
public class SustainabilityDocumentConfiguration: Configuration {
    
    let exportOptions: SustainabilityDocumentExportOptions?
    
    /// Initializer for a ``SustainabilityDocumentConfiguration`` instance
    /// - Parameter exportOptions: Export options of the `ApodiniSustainability` document
    public init(_ exportOptions: SustainabilityDocumentExportOptions? = nil) {
        self.exportOptions = exportOptions
    }
    
    /// Configures `app` by registering the ``InterfaceExporter`` that handles `ApodiniSustainability` document export
    /// - Parameter app: Application instance to register the configuration in Apodini
    public func configure(_ app: Application) {
        app.registerExporter(exporter: ApodiniSustainabilityInterfaceExporter(app, configuration: self))
    }
}

public extension WebService {
    /// A typealias for ``SustainabilityDocumentConfiguration``
    typealias Sustainability = SustainabilityDocumentConfiguration
}
