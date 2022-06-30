import XCTest
@testable import Apodini
@testable import ApodiniSustainability

final class ServiceIdentifierMetadataTests: XCTestCase {
    
    struct Greeter: Handler {
        func handle() -> String {
            "Hello World"
        }
    }
    
    struct ServiceIdentifierGreeter: Handler {
        func handle() -> String {
            "Hello World"
        }

        var metadata: Metadata {
            ServiceIdentifier("greeter")
        }
    }
    
    struct DefaultServiceIdentifierComponent: Component {
        var content: some Component {
            Greeter()
        }
    }
    
    struct ServiceIdentifierComponent: Component {
        var content: some Component {
            ServiceIdentifierGreeter()
        }
    }
    
    struct ServiceIdentifierModifierComponent: Component {
        var content: some Component {
            Greeter()
                .serviceIdentifier("")
        }
    }
    
    func testDefaultServiceIdentifier() throws {
        let modelBuilder = SemanticModelBuilder(Application())
        let visitor = SyntaxTreeVisitor(modelBuilder: modelBuilder)
        let component = DefaultServiceIdentifierComponent()
        Group {
            component.content
        }.accept(visitor)
        visitor.finishParsing()

        let endpoint: AnyEndpoint = try XCTUnwrap(modelBuilder.collectedEndpoints.first)
        let serviceIdentifier = endpoint[Context.self].get(valueFor: ServiceIdentifierComponentMetadata.self)

        XCTAssertEqual(serviceIdentifier, nil)
    }
    
    func testServiceIdentifierMetadata() throws {
        let modelBuilder = SemanticModelBuilder(Application())
        let visitor = SyntaxTreeVisitor(modelBuilder: modelBuilder)
        let component = ServiceIdentifierComponent()
        Group {
            component.content
        }.accept(visitor)
        visitor.finishParsing()

        let endpoint: AnyEndpoint = try XCTUnwrap(modelBuilder.collectedEndpoints.first)
        let serviceIdentifier = endpoint[Context.self].get(valueFor: ServiceIdentifierComponentMetadata.self)

        XCTAssertEqual(serviceIdentifier, "greeter")
    }
    
    func testServiceIdentifierModifier() throws {
        let modelBuilder = SemanticModelBuilder(Application())
        let visitor = SyntaxTreeVisitor(modelBuilder: modelBuilder)
        let component = ServiceIdentifierModifierComponent()
        Group {
            component.content
        }.accept(visitor)
        visitor.finishParsing()

        let endpoint: AnyEndpoint = try XCTUnwrap(modelBuilder.collectedEndpoints.first)
        let serviceIndentifier = endpoint[Context.self].get(valueFor: ServiceIdentifierComponentMetadata.self)

        XCTAssertEqual(serviceIndentifier, "")
    }
}
