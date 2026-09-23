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
        // Fork propio de la capa SSH (decisión del operador, 22 sep 2026,
        // apple-dev/ENCARGO-FORK-SSH.md): nace del d88989f (0.3.7) de Wellz26/swift-nio-ssh
        // con el arreglo de Apple para CVE-2026-43798 encima (sp.1) y los hallazgos F1, F2,
        // F3/F5 y F4 de la revisión de seguridad del 22 sep 2026 (sp.2). Fijado por versión
        // exacta: nadie fuera de SuperPartner publica una versión de esta capa, y una versión
        // nueva entra solo cuando alguien cambia este número a propósito.
        .package(url: "https://github.com/SuperPartnerDev/swift-nio-ssh.git", exact: "0.3.7-sp.2"),
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
