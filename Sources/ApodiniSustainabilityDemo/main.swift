import Apodini
import ApodiniREST
import ArgumentParser
import ApodiniSustainability

struct Greeter: Handler {
    @Parameter var country: String?

    func handle() -> String {
        "Hello, \(country ?? "World")! 🚀"
    }
    
    var metadata: Metadata {
        ExecutionModality(.highPerformance)
        ResponseTime(value: 1)
    }
}

struct GreeterService: Component {
    
    var content: some Component {
        Greeter()
            .description("Say 'Hello' to a country.")
    }
    
    var metadata: Metadata {
        Optional()
        ServiceIdentifier("greeter")
    }
}

struct HelloWorld: WebService {
    
    @OptionGroup
    var options: SustainabilityDocumentExportOptions
    
    var configuration: Configuration {
        REST()
        Sustainability(options)
    }

    var content: some Component {
        GreeterService()
    }
}

HelloWorld.main()
