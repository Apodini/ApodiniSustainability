<!--

This source file is part of the Apodini open source project

SPDX-FileCopyrightText: 2021 Paul Schmiedmayer and the project authors (see CONTRIBUTORS.md) <paul.schmiedmayer@tum.de>

SPDX-License-Identifier: MIT

-->

# Apodini Sustainability

[![Build](https://github.com/Apodini/ApodiniSustainability/actions/workflows/build.yml/badge.svg)](https://github.com/Apodini/ApodiniSustainability/actions/workflows/build.yml)
[![codecov](https://codecov.io/gh/Apodini/ApodiniSustainability/branch/develop/graph/badge.svg?token=5MMKMPO5NR)](https://codecov.io/gh/Apodini/ApodiniSustainability)

ApodiniSustainability includes metadata definitions for annotating Apodini web services with additional information to enable sustainability in cloud-native applications and the interface exporter to share the information.

## Hello World

This `HelloWorld` example shows the annotations of the Apodini web service with metadata and includes the `Sustainability` interface exporter in the configuration of the web service.

```
struct Greeter: Handler {
    @Parameter var country: String?

    func handle() -> String {
        "Hello, \(country ?? "World")! 🚀"
    }
    
    var metadata: Metadata {
        ExecutionModality(.highPerformance)
        ResponseTime(value: 1)
        InstanceType(.small)
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
        Sustainability(options)
    }

    var content: some Component {
        GreeterService()
    }
}
```

## Contributing
Contributions to this project are welcome. Please make sure to read the [contribution guidelines](https://github.com/Apodini/.github/blob/main/CONTRIBUTING.md) and the [contributor covenant code of conduct](https://github.com/Apodini/.github/blob/main/CODE_OF_CONDUCT.md) first.

## License
This project is licensed under the MIT License. See [Licenses](https://github.com/Apodini/ApodiniSustainability/tree/develop/LICENSES) for more information.
