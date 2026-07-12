import Foundation

final class AdapterStream: @unchecked Sendable {
    private let perlScriptURL: URL
    private let frameworkURL: URL
    private let onUpdate: (NowPlaying) -> Void

    private var process: Process?
    private var buffer = Data()
    private var stopping = false

    init(perlScriptURL: URL, frameworkURL: URL, onUpdate: @escaping (NowPlaying) -> Void) {
        self.perlScriptURL = perlScriptURL
        self.frameworkURL = frameworkURL
        self.onUpdate = onUpdate
    }

    func start() {
        stopping = false
        launch()
    }

    func stop() {
        stopping = true
        process?.terminate()
        process = nil
    }

    private func launch() {
        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: "/usr/bin/perl")
        proc.arguments = [
            perlScriptURL.path,
            frameworkURL.path,
            "stream",
            "--no-diff",
        ]

        let outPipe = Pipe()
        proc.standardOutput = outPipe
        proc.standardError = FileHandle.nullDevice

        outPipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let chunk = handle.availableData
            guard !chunk.isEmpty else { return }
            DispatchQueue.main.async { self?.consume(chunk) }
        }

        proc.terminationHandler = { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                guard let self, !self.stopping else { return }
                self.launch()
            }
        }

        do {
            try proc.run()
            process = proc
        } catch {
            FileHandle.standardError.write(Data("Failed to start adapter: \(error)\n".utf8))
        }
    }

    private func consume(_ data: Data) {
        buffer.append(data)
        let newline = UInt8(ascii: "\n")
        while let idx = buffer.firstIndex(of: newline) {
            let line = buffer.subdata(in: buffer.startIndex..<idx)
            buffer.removeSubrange(buffer.startIndex...idx)
            guard !line.isEmpty,
                  let msg = try? JSONDecoder().decode(StreamMessage.self, from: line)
            else { continue }
            let payload = msg.payload
            DispatchQueue.main.async { [weak self] in self?.onUpdate(payload) }
        }
    }
}
