import AppKit
import ServiceManagement

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var stream: AdapterStream?
    private let loginItem = NSMenuItem(title: "Launch at Login", action: nil, keyEquivalent: "")

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        showPlaceholder()
        buildMenu()

        guard let (pl, fw) = resolveAdapterPaths() else {
            statusItem.button?.title = "⚠︎"
            return
        }
        stream = AdapterStream(perlScriptURL: pl, frameworkURL: fw) { [weak self] np in
            self?.handle(np)
        }
        stream?.start()
    }

    func applicationWillTerminate(_ notification: Notification) {
        stream?.stop()
    }

    private func handle(_ np: NowPlaying) {
        guard np.isTidal, let title = np.title else {
            showPlaceholder()
            return
        }
        let icon = (np.playing ?? false) ? "♪ " : "❙❙ "
        let label: String
        if let artist = np.artist, !artist.isEmpty {
            label = "\(artist) - \(title)"
        } else {
            label = title
        }
        statusItem.button?.title = icon + truncate(label, 50)
    }

    private func showPlaceholder() {
        statusItem.button?.title = "♪"
    }

    private func buildMenu() {
        let menu = NSMenu()
        loginItem.target = self
        loginItem.action = #selector(toggleLaunchAtLogin)
        refreshLoginState()
        menu.addItem(loginItem)
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
    }

    @objc private func toggleLaunchAtLogin() {
        let service = SMAppService.mainApp
        do {
            if service.status == .enabled {
                try service.unregister()
            } else {
                try service.register()
            }
        } catch {
            NSLog("Launch-at-login toggle failed: \(error)")
        }
        refreshLoginState()
    }

    private func refreshLoginState() {
        loginItem.state = (SMAppService.mainApp.status == .enabled) ? .on : .off
    }

    private func truncate(_ s: String, _ max: Int) -> String {
        s.count <= max ? s : String(s.prefix(max - 1)) + "…"
    }

    private func resolveAdapterPaths() -> (URL, URL)? {
        let fm = FileManager.default
        let bundle = Bundle.main

        if let pl = bundle.url(forResource: "mediaremote-adapter", withExtension: "pl"),
           let fw = bundle.privateFrameworksURL?.appendingPathComponent("MediaRemoteAdapter.framework"),
           fm.fileExists(atPath: fw.path) {
            return (pl, fw)
        }

        let cwd = URL(fileURLWithPath: fm.currentDirectoryPath)
        let pl = cwd.appendingPathComponent("vendor/mediaremote-adapter.pl")
        let fw = cwd.appendingPathComponent("vendor/MediaRemoteAdapter.framework")
        if fm.fileExists(atPath: pl.path), fm.fileExists(atPath: fw.path) {
            return (pl, fw)
        }
        return nil
    }
}
