import SwiftUI

struct TerminalTab: View {
    @Environment(NodeAppModel.self) private var appModel

    private var terminalURL: URL? {
        if let host = gatewayHost {
            if host.hasSuffix(".ts.net") {
                return URL(string: "https://\(host)/terminal/")
            }
            if let port = gatewayPort {
                let scheme = useTLS ? "https" : "http"
                return URL(string: "\(scheme)://\(host):\(port)/terminal/")
            }
        }
        return nil
    }
    
    private var gatewayHost: String? {
        if let lastConnection = GatewaySettingsStore.loadLastGatewayConnection() {
            switch lastConnection {
            case let .manual(host, _, _, _):
                if host.hasSuffix(".ts.net") {
                    return host
                }
                return host
            case .discovered:
                break
            }
        }
        if let remoteAddr = appModel.gatewayRemoteAddress {
            if remoteAddr.hasSuffix(".ts.net") {
                return remoteAddr
            }
        }
        return appModel.gatewayRemoteAddress
    }
    
    private var gatewayPort: Int? {
        if let lastConnection = GatewaySettingsStore.loadLastGatewayConnection() {
            switch lastConnection {
            case let .manual(_, port, _, _):
                return port
            case .discovered:
                break
            }
        }
        return 18789
    }
    
    private var useTLS: Bool {
        if gatewayHost?.hasSuffix(".ts.net") == true {
            return true
        }
        return GatewaySettingsStore.loadLastGatewayConnection()?.useTLS ?? false
    }
    
    private var token: String? {
        guard let instanceId = GatewaySettingsStore.loadStableInstanceID() else { return nil }
        return GatewaySettingsStore.loadGatewayToken(instanceId: instanceId)
    }
    
    private var isConnected: Bool {
        appModel.gatewayServerName != nil || appModel.gatewayRemoteAddress != nil
    }

    var body: some View {
        ZStack {
            if isConnected, let url = terminalURL {
                TerminalWebView(gatewayURL: url, token: token)
                    .ignoresSafeArea()
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "terminal")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                    
                    Text("Terminal")
                        .font(.title2.bold())
                    
                    Text("Connect to a gateway to use the terminal")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    
                    if !isConnected {
                        Text("Go to Settings to connect")
                            .font(.footnote)
                            .foregroundStyle(.blue)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 0.043, green: 0.063, blue: 0.125))
            }
        }
    }
}
