//
//  UISegmentedProgressView.swift
//  iTorrent
//
//  Created by Даниил Виноградов on 01.04.2024.
//

import SwiftUI
import UIKit

@IBDesignable
public class UISegmentedProgressView: UIView {
    public var progress: [Double] = [0.5] {
        didSet {
            guard oldValue != progress else { return }
            setNeedsDisplay()
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override public var intrinsicContentSize: CGSize {
        .init(width: UIView.noIntrinsicMetric, height: defaultHeight)
    }

    override public func tintColorDidChange() {
        super.tintColorDidChange()
        setNeedsDisplay()
    }

    override public func draw(_ rect: CGRect) {
        super.draw(rect)

        guard !progress.isEmpty, bounds.width > 0, bounds.height > 0,
              let context = UIGraphicsGetCurrentContext() else { return }

        // A screen cannot display more independent horizontal details than it has
        // physical pixels. Keep the full per-piece model, but rasterize it at the
        // view's pixel resolution instead of issuing a Core Graphics stroke for
        // every piece (large torrents can contain millions of pieces).
        let scale = window?.screen.scale ?? UIScreen.main.scale
        let columnCount = min(progress.count, max(1, Int(ceil(bounds.width * scale))))
        let pieceCount = progress.count
        let columnWidth = bounds.width / CGFloat(columnCount)
        context.setFillColor(tintColor.cgColor)

        for column in 0 ..< columnCount {
            let startIndex = column * pieceCount / columnCount
            let endIndex = max(startIndex + 1, (column + 1) * pieceCount / columnCount)
            var completed: Double = 0

            for pieceIndex in startIndex ..< min(endIndex, pieceCount) {
                completed += min(1, max(0, progress[pieceIndex]))
            }

            let averageProgress = completed / Double(min(endIndex, pieceCount) - startIndex)
            guard averageProgress > 0 else { continue }

            // Encode sub-pixel completion as vertical coverage within each pixel
            // column, so sparse and partially complete regions remain visible.
            let barHeight = bounds.height * averageProgress
            let barRect = CGRect(
                x: CGFloat(column) * columnWidth,
                y: bounds.midY - barHeight / 2,
                width: columnWidth + 0.5 / scale,
                height: barHeight
            )
            context.fill(barRect)
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        isOpaque = false
        #if os(visionOS)
        backgroundColor = .tertiarySystemFill
        #else
        backgroundColor = .systemFill
        #endif
    }

    private func setup() {
        clipsToBounds = true
        layer.cornerRadius = defaultHeight / 2
        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .vertical)
    }

    let defaultHeight: Double = 4
}

public struct SegmentedProgressView: UIViewRepresentable {
    @Binding var progress: [Double]

    public func makeUIView(context: Context) -> UISegmentedProgressView {
        UISegmentedProgressView()
    }

    public func updateUIView(_ uiView: UISegmentedProgressView, context: Context) {
        uiView.progress = progress
    }
}
