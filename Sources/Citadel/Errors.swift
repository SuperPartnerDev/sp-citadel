public enum SSHClientError: Error {
    case unsupportedPasswordAuthentication, unsupportedPrivateKeyAuthentication, unsupportedHostBasedAuthentication
    case channelCreationFailed
    case allAuthenticationOptionsFailed
}

public enum SSHChannelError: Error {
    case invalidDataType
}

public enum SSHExecError: Error {
    case commandExecFailed
    case invalidChannelType
    case invalidData
}

public enum SFTPError: Error {
    case atomicRenameUnsupported
    case unknownMessage
    case invalidPayload(type: SFTPMessageType)
    case invalidResponse
    case noResponseTarget
    case connectionClosed
    case missingResponse
    case fileHandleInvalid
    case errorStatus(SFTPMessage.Status)
    case unsupportedVersion(SFTPProtocolVersion)
    /// La longitud de trama que anunció el peer es 0 o supera `SFTPMessageParser.maximumMessageLength`.
    case invalidMessageLength(UInt32)
}

public enum CitadelError: Error {
    case invalidKeySize
    case invalidEncryptedPacketLength
    case invalidDecryptedPlaintextLength
    case insufficientPadding, excessPadding
    case invalidMac
    case cryptographicError
    case invalidSignature
    case signingError
    case unsupported
    case unauthorized
    case commandOutputTooLarge
    case channelCreationFailed
    case channelFailure
}

public struct AuthenticationFailed: Error, Equatable {}
