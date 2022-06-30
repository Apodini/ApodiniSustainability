import XCTest
@testable import Apodini
@testable import ApodiniSustainability
import ApodiniDocumentExport
import XCTApodiniNetworking
@_implementationOnly import PathKit

final class ApodiniSustainabilityInterfaceExporterTests: XCTestCase {
    
    let app = Application()
    let directory = Path("./SustainabilityDocument")
    let endpoint = "sustainability"
    
    static var configuration: SustainabilityDocumentConfiguration = .init()
    
    struct Greeter: Handler {
        @Binding var country: String?

        func handle() -> String {
            "Hello, \(country ?? "World")!"
        }
        
        var metadata: Metadata {
            ExecutionModality(.highPerformance)
            ResponseTime(value: 1)
            InstanceType(.large)
        }
    }
    
    struct GreeterService: Component {
        @PathParameter var country: String
        
        var content: some Component {
            Group($country) {
                Greeter(country: Binding<String?>($country))
                    .description("Say 'Hello' to a country.")
            }
        }
        
        var metadata: Metadata {
            Optional()
        }
    }

    struct HelloWorld: WebService {
        
        var content: some Component {
            GreeterService()
                .serviceIdentifier("greeter")
        }
        
        var configuration: Configuration {
            ApodiniSustainabilityInterfaceExporterTests.configuration
        }
    }
    
    func testSustainabilityDocument() throws {
        try HelloWorld().start(app: app)
        
        let document = try XCTUnwrap(app.storage.get(SustainabilityDocumentStorageKey.self))
        let service = try XCTUnwrap(document.services.first(where: { $0.id == "greeter" }))
        let modality = try XCTUnwrap(service.modalities.highPerformance)
        
        XCTAssertNotNil(modality)
    }
    
    func testDocumentDirectoryExport() throws {
        let exportOptions: SustainabilityDocumentExportOptions = .directory(directory.string, format: .yaml)
        Self.configuration = SustainabilityDocumentConfiguration(exportOptions)

        try HelloWorld().start(app: app)

        let document = try XCTUnwrap(app.storage.get(SustainabilityDocumentStorageKey.self))
        let export = try SustainabilityDocument.decode(from: directory + "sustainability_\(document.version).yaml")
        
        XCTAssertEqual(document, export)
    }
    
    func testSustainabilityDocumentEndpointExport() throws {
        let exportOptions: SustainabilityDocumentExportOptions = .endpoint(endpoint)
        Self.configuration = SustainabilityDocumentConfiguration(exportOptions)

        try HelloWorld().start(app: app)

        try app.testable().test(.GET, endpoint) { response in
            XCTAssertEqual(response.status, .ok)
            XCTAssertNoThrow(try response.bodyStorage.getFullBodyData(decodedAs: SustainabilityDocument.self, using: JSONDecoder()))
        }
    }
}
