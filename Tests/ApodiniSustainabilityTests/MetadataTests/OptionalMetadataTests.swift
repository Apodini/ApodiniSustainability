import XCTest
@testable import Apodini
@testable import ApodiniSustainability

final class OptionalMetadataTests: XCTestCase {
    
    struct Greeter: Handler {
        func handle() -> String {
            "Hello World"
        }
    }
    
    
    struct OptionalMetadataGreeter: Handler {
        func handle() -> String {
            "Hello World"
        }
        
        var metadata: Metadata {
            Optional()
        }
    }
    
    
    struct ExecutionModalityModifierComponent: Component {
        var content: some Component {
            Greeter()
                .executionModality(.lowPower)
        }
    }
    
    struct DefaultOptionalMetadataComponent: Component {
        var content: some Component {
            Greeter()
        }
    }
    
    struct OptionalMetadataComponent: Component {
        var content: some Component {
            OptionalMetadataGreeter()
        }
        
        var metadata: Metadata {
            ServiceIdentifier("greeter")
            Optional()
        }
    }
    
    struct OptionalModifierComponent: Component {
        var content: some Component {
            Greeter()
                .optional(true)
        }
    }
    
    func testDefaultOptionalMetadata() throws {
        let modelBuilder = SemanticModelBuilder(Application())
        let visitor = SyntaxTreeVisitor(modelBuilder: modelBuilder)
        let component = DefaultOptionalMetadataComponent()
        Group {
            component.content
        }.accept(visitor)
        visitor.finishParsing()

        let endpoint: AnyEndpoint = try XCTUnwrap(modelBuilder.collectedEndpoints.first)
        let optional = endpoint[Context.self].get(valueFor: OptionalComponentMetadata.self)

        XCTAssertEqual(optional, nil)
    }
    
    func testOptionalMetadata() throws {
        let modelBuilder = SemanticModelBuilder(Application())
        let visitor = SyntaxTreeVisitor(modelBuilder: modelBuilder)
        let component = OptionalMetadataComponent()
        Group {
            component.content
        }.accept(visitor)
        visitor.finishParsing()

        let endpoint: AnyEndpoint = try XCTUnwrap(modelBuilder.collectedEndpoints.first)
        
        let optional = endpoint[Context.self].get(valueFor: OptionalComponentMetadata.self)

        XCTAssertEqual(optional, true)
    }
    
    func testOptionalModifier() throws {
        let modelBuilder = SemanticModelBuilder(Application())
        let visitor = SyntaxTreeVisitor(modelBuilder: modelBuilder)
        let component = OptionalModifierComponent()
        Group {
            component.content
        }.accept(visitor)
        visitor.finishParsing()

        let endpoint: AnyEndpoint = try XCTUnwrap(modelBuilder.collectedEndpoints.first)
        let optional = endpoint[Context.self].get(valueFor: OptionalComponentMetadata.self)

        XCTAssertEqual(optional, true)
    }
}
