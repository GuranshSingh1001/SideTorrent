//
//  TorrentHandle+Extensions.swift
//  iTorrent
//
//  Created by Даниил Виноградов on 12.12.2025.
//

import LibTorrent

extension TorrentHandle.Snapshot {
    var timeRemains: String {
        guard downloadRate > 0 else { return %"time.infinity" }
        guard totalWanted >= totalWantedDone else { return "Almost done" }
        return ((totalWanted - totalWantedDone) / downloadRate).timeString
    }

    /// Returns a bounded number of segments for UI drawing.
    /// Large torrents can contain hundreds of thousands of pieces; rendering every
    /// piece creates huge arrays and expensive drawing work on memory-constrained hosts.
    var segmentedProgress: [Double] {
        guard let pieces, !pieces.isEmpty else { return [0] }

        let maximumSegments = 1_000
        guard pieces.count > maximumSegments else {
            return pieces.map { $0.doubleValue }
        }

        let bucketSize = Double(pieces.count) / Double(maximumSegments)
        return (0..<maximumSegments).map { bucket in
            let start = Int(Double(bucket) * bucketSize)
            let end = min(pieces.count, Int(Double(bucket + 1) * bucketSize))
            guard start < end else { return 0 }

            // Preserve the strongest completion signal in each bucket.
            var completed = 0.0
            for index in start..<end {
                completed = max(completed, pieces[index].doubleValue)
            }
            return completed
        }
    }
    
    var stateText: String {
        let state = friendlyState
        var text = "\(state.name)"

        if state == .downloading {
            text += " - ↓ \(downloadRate.bitrateToHumanReadable)/s"
            text += " - \(timeRemains)"
        } else if state == .seeding {
            text += " - ↑ \(uploadRate.bitrateToHumanReadable)/s"
        }

        return text
    }
}
