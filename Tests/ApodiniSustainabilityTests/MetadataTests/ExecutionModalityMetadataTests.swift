import XCTest
@testable import Apodini
@testable import ApodiniSustainability

final class ExecutionModalityMetadataTests: XCTestCase {
    
    struct Greeter: Handler {
        func handle() -> String {
            "Hello World"
        }
    }
    
    struct ExecutionModalityGreeter: Handler {
        func handle() -> String {
            "Hello World"
        }

        var metadata: Metadata {
            ExecutionModality(.highPerformance)
        }
    }
    
    struct DefaultExecutionModalityComponent: Component {
        var content: some Component {
            Greeter()
        }
    }
    
    struct ExecutionModalityComponent: Component {
        var content: some Component {
            ExecutionModalityGreeter()
        }
    }
    
    struct ExecutionModalityModifierComponent: Component {
        var content: some Component {
            Greeter()
                .executionModality(.lowPower)
        }
    }
    
    func testDefaultExecutionModality() throws {
        let modelBuilder = SemanticModelBuilder(Application())
        let visitor = SyntaxTreeVisitor(modelBuilder: modelBuilder)
        let component = DefaultExecutionModalityComponent()
        Group {
            component.content
        }.accept(visitor)
        visitor.finishParsing()

        let endpoint: AnyEndpoint = try XCTUnwrap(modelBuilder.collectedEndpoints.first)
        let executionModality = endpoint[Context.self].get(valueFor: ExecutionModalityHandlerMetadata.self)

        XCTAssertEqual(executionModality, ExecutionModalityOption.standard)
    }
    
    func testExecutionModalityMetadata() throws {
        let modelBuilder = SemanticModelBuilder(Application())
        let visitor = SyntaxTreeVisitor(modelBuilder: modelBuilder)
        let component = ExecutionModalityComponent()
        Group {
            component.content
        }.accept(visitor)
        visitor.finishParsing()

        let endpoint: AnyEndpoint = try XCTUnwrap(modelBuilder.collectedEndpoints.first)
        let executionModality = endpoint[Context.self].get(valueFor: ExecutionModalityHandlerMetadata.self)

        XCTAssertEqual(executionModality, ExecutionModalityOption.highPerformance)
    }
    
    func testExecutionModalityModifier() throws {
        let modelBuilder = SemanticModelBuilder(Application())
        let visitor = SyntaxTreeVisitor(modelBuilder: modelBuilder)
        let component = ExecutionModalityModifierComponent()
        Group {
            component.content
        }.accept(visitor)
        visitor.finishParsing()

        let endpoint: AnyEndpoint = try XCTUnwrap(modelBuilder.collectedEndpoints.first)
        let executionModality = endpoint[Context.self].get(valueFor: ExecutionModalityHandlerMetadata.self)

        XCTAssertEqual(executionModality, ExecutionModalityOption.lowPower)
    }
}
