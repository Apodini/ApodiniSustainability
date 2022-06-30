import Apodini
import ApodiniDocumentExport
import ApodiniNetworking
@_implementationOnly import Logging

final class ApodiniSustainabilityInterfaceExporter: InterfaceExporter {
    
    private let app: Application
    private let configuration: SustainabilityDocumentConfiguration
    private var services: [String: Service] = .init()
    private let logger = Logger(label: "org.apodini.sustainability")
    
    init(_ app: Application, configuration: SustainabilityDocumentConfiguration) {
        self.app = app
        self.configuration = configuration
    }
    
    func export<H>(_ endpoint: Endpoint<H>) -> () where H : Handler {
        
        guard let key = endpoint[Context.self].get(valueFor: ServiceIdentifierComponentMetadata.self) else { return }
        
        let requirements = Requirements(responseTime: endpoint[Context.self].get(valueFor: ResponseTimeHandlerMetadata.self), instanceType: endpoint[Context.self].get(valueFor: InstanceTypeHandlerMetadata.self))
        
        let serviceVersion = ServiceVersion(id: endpoint[AnyHandlerIdentifier.self], name: endpoint[HandlerDescription.self].rawValue, description: endpoint[Context.self].get(valueFor: HandlerDescriptionMetadata.self), requirements: requirements)
        
        let modalities: ExecutionModalities
        
        switch endpoint[Context.self].get(valueFor: ExecutionModalityHandlerMetadata.self) {
        case .highPerformance:
            modalities = ExecutionModalities(highPerformance: serviceVersion)
        case .lowPower:
            modalities = ExecutionModalities(lowPower: serviceVersion)
        default:
            modalities = ExecutionModalities(standard: serviceVersion)
        }
        
        let optional : Bool? = endpoint[Context.self].get(valueFor: OptionalComponentMetadata.self)
        
        services.merge([key : Service(
            id: key,
            name: key.replacingOccurrences(of: "-", with: " ").capitalized(with: nil),
            description: String.init(),
            optional: optional,
            modalities: modalities
        )]) { current, new in
            var service = current
            service.modalities = service.modalities.merge(with: new.modalities)
            if new.optional ?? false {
                service.optional = true
            }
            return service
        }
    }
    
    func export<H>(blob endpoint: Endpoint<H>) -> () where H : Handler, H.Response.Content == Blob {
        export(endpoint)
    }
    
    func finishedExporting(_ webService: WebServiceModel) {
        
        let document = SustainabilityDocument(
            serverPath: app.httpConfiguration.uriPrefix,
            version: webService.context.get(valueFor: APIVersionContextKey.self).semVerString,
            description: webService.context.get(valueFor: WebServiceDescriptionMetadata.self),
            services: [Service](services.values)
        )
        
        app.storage.set(SustainabilityDocumentStorageKey.self, to: document)
        
        guard let options = configuration.exportOptions else {
            return logger.notice("No configuration provided to handle the ApodiniSustainability document of the current version")
        }
            
        if let directory = options.directory {
            do {
                let filePath = try document.write(at: directory, outputFormat: options.format, fileName: "sustainability_\(document.version)")
                logger.info("ApodiniSustainability document exported at \(filePath) in \(options.format.rawValue)")
            } catch {
                logger.error("ApodiniSustainability export at \(directory) failed with error: \(error)")
            }
        }
        
        if let endpoint = options.endpoint {
//            app.httpServer.registerRoute(.GET, endpoint.httpPathComponents) { _ -> String in
//                options.format.string(of: document)
//            }
            app.httpServer.registerRoute(.GET, endpoint.httpPathComponents) { req in
                HTTPResponse(
                    version: req.version,
                    status: .ok,
                    headers: HTTPHeaders {
                        $0[.accessControlAllowOrigin] = .wildcard
                    },
                    bodyStorage: .buffer(initialValue: options.format.string(of: document))
                )
            }
            logger.info("ApodiniSustainability document served at \(endpoint) in \(options.format.rawValue) format")
        }
    }
}
