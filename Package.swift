// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Citadel",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Citadel",
            targets: ["Citadel"]
        ),
    ],
    dependencies: [
        // .package(path: "/Users/joannisorlandos/git/joannis/swift-nio-ssh"),
        // Fijada en una versión exacta, no en un rango (revisión de seguridad del 22 sep
        // 2026, F2/F6): este no es el swift-nio-ssh de Apple sino el fork de un tercero, y
        // con "0.3.4" ..< "0.4.0" una 0.3.8 publicada allí entraba sola en la próxima
        // resolución, sin que nadie leyera el cambio. Qué hacer a futuro con esta
        // dependencia (migrar al de Apple, que va por la 0.13, o hacer un fork propio) es
        // una decisión abierta: apple-dev/REVISION-SEGURIDAD.md.
        .package(url: "https://github.com/Wellz26/swift-nio-ssh.git", exact: "0.3.7"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.81.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.2.0"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.12.3"),
    ],
    targets: [
        .target(name: "CCitadelBcrypt"),
        .target(
            name: "Citadel",
            dependencies: [
                .target(name: "CCitadelBcrypt"),
                .product(name: "NIOSSH", package: "swift-nio-ssh"),
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "_CryptoExtras", package: "swift-crypto"),
                .product(name: "BigInt", package: "BigInt"),
                .product(name: "Logging", package: "swift-log"),
            ],
            // Citadel es codigo de terceros (fork de orlandos-nl/Citadel) escrito para Swift 5:
            // compilado en modo Swift 6 suelta unos noventa avisos de concurrencia estricta que
            // no son de SP Mount y que tapan los nuestros. Se compila en modo Swift 5, que es el
            // que la libreria declara soportar; SPMountCore sigue en Swift 6 (SuperPartner, 17 sep 2026).
            // Modo Swift 5 (la libreria esta escrita para el) y sin avisos: Xcode impone la
            // version de Swift del proyecto a los paquetes, asi que el modo por si solo no
            // bastaba y seguian saliendo mas de cien avisos de concurrencia de codigo que no
            // es nuestro. Es un fork local por ruta, asi que unsafeFlags esta permitido.
            swiftSettings: [.swiftLanguageMode(.v5), .unsafeFlags(["-suppress-warnings"])]
        ),
        .testTarget(
            name: "CitadelTests",
            dependencies: [
                "Citadel",
                .product(name: "NIOSSH", package: "swift-nio-ssh"),
                .product(name: "BigInt", package: "BigInt"),
                .product(name: "Logging", package: "swift-log"),
            ]
        ),
    ]
)
