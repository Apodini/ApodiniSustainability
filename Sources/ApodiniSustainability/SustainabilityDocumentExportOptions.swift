import ApodiniDocumentExport
import ArgumentParser

// MARK: - SustainabilityDocumentExportOptions
/// An object that defines export options of the document
public struct SustainabilityDocumentExportOptions: ExportOptions {
    /// A path to a local directory used to export the document
    @Option(name: .customLong("directory"), help: "A path to a local directory to export the document")
    public var directory: String?
    /// An endpoint path of the web service used to expose document
    @Option(name: .customLong("endpoint"), help: "A path to an endpoint of the web service to expose the document")
    public var endpoint: String?
    /// Format of the `ApodiniSustainability` document export
    ///
    /// `ApodiniSustainability` supports `json` or `yaml` format.
    /// - Note: Defaults to `json`
    @Option(name: .customLong("format"), help: "Format of the document, either `json` or `yaml`")
    public var format: FileFormat = .json
    
    /// Creates an instance of this parsable type using the definitions given by each property’s wrapper.
    public init() {}
}
