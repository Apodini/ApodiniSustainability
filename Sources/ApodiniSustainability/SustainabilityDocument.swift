import Foundation
import Apodini
import ApodiniDocumentExport

/// Identifying storage key for `ApodiniSustainability` document
public struct SustainabilityDocumentStorageKey: Apodini.StorageKey {
    public typealias Value = SustainabilityDocument
}

/// A document that describes Apodini web service sustainability metadata
public struct SustainabilityDocument: Value {
    
    /// Apodini web service server path
    public let serverPath: String
    /// Apodini web service version
    public let version: String
    /// Apodini web service description
    public let description: String?
    /// Service
    public let services: [Service]
    
    /// Initializes a new `ApodiniSustainability` document.
    public init(
        serverPath: String,
        version: String,
        description: String?,
        services: [Service]
    ) {
        self.serverPath = serverPath
        self.version = version
        self.description = description
        self.services = services
    }
}

public struct Service: Value {

    /// Service Identifier
    public let id: String
    /// Service Name
    public let name: String
    /// Description Metadata
    public let description: String
    /// Optional Metadata
    public var optional: Bool?
    /// Execution Modalities
    public var modalities: ExecutionModalities

    public init(
        id: String,
        name: String,
        description: String,
        optional: Bool?,
        modalities: ExecutionModalities
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.optional = optional
        self.modalities = modalities
    }
}

public struct ExecutionModalities: Value {

    /// High Performance Version
    public let highPerformance: ServiceVersion?
    /// Standard Version
    public let standard: ServiceVersion?
    /// Low Power Version
    public let lowPower: ServiceVersion?
    
    public init(
        highPerformance: ServiceVersion? = nil,
        standard: ServiceVersion? = nil,
        lowPower: ServiceVersion? = nil
    ) {
        self.highPerformance = highPerformance
        self.standard = standard
        self.lowPower = lowPower
    }
    
    func merge(with: ExecutionModalities) -> ExecutionModalities {
        return ExecutionModalities(
            highPerformance: with.highPerformance ?? highPerformance,
            standard: with.standard ?? standard,
            lowPower: with.lowPower ?? lowPower
        )
    }
}

public struct ServiceVersion: Value {
    
    /// Service Version Identifier
    public let id: AnyHandlerIdentifier
    /// Service Version Name
    public let name: String
    /// Description Metadata
    public let description: String?
    /// Service Version Requirements
    public let requirements: Requirements?
    
    public init(
        id: AnyHandlerIdentifier,
        name: String,
        description: String?,
        requirements: Requirements?
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.requirements = requirements
    }
}

public struct Requirements: Value {
    
    /// Response Time
    public let responseTime: Int?
    /// Instance Type
    public let instanceType: InstanceTypeOption?
    
    public init?(
        responseTime: Int?,
        instanceType: InstanceTypeOption?
    ) {
        if(responseTime != nil || instanceType != nil){
            self.responseTime = responseTime
            self.instanceType = instanceType
        } else {
            return nil
        }
    }
}
