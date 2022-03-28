//
//  SloxEditor.swift
//  Slox
//
//  Created by Patrick Van den Bergh on 26/03/2022.
//

import SwiftUI
import Combine

struct SloxEditor: NSViewRepresentable {
    @Binding var text: String
    
    typealias NSViewType = SloxEditorView
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeNSView(context: Context) -> SloxEditorView {
        let sloxEditorView = SloxEditorView(text: text)
        sloxEditorView.delegate = context.coordinator
        return sloxEditorView
    }
    
    func updateNSView(_ nsView: SloxEditorView, context: Context) {
    }
}

// MARK: - Coordinator

extension SloxEditor {
    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: SloxEditor
        
        init(_ parent: SloxEditor) {
            self.parent = parent
        }
        
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            if let text = textView.textStorage?.string {
                // Here I can put code for syntax highlighting
                self.parent.text = text
            }
        }
    }
}

// MARK: - SloxEditorView
class SloxEditorView: NSView {
    var text: String {
        didSet {
            textView.string = text
        }
    }
    
    weak var delegate: NSTextViewDelegate?
    
    private lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.drawsBackground = true
        scrollView.borderType = .noBorder
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalRuler = false
        scrollView.autoresizingMask = [.width, .height]
        return scrollView
    }()
    
    private lazy var textView: NSTextView = {
        let textView = NSTextView()
        textView.autoresizingMask = .width
        textView.backgroundColor = NSColor.textBackgroundColor
        textView.delegate = self.delegate
        textView.drawsBackground = true
        textView.font = NSFont(name: "Courier", size: 16.0)
        textView.isEditable = true
        textView.isHorizontallyResizable = false
        textView.isVerticallyResizable = true
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.textColor = NSColor.labelColor
        textView.allowsUndo = true
        return textView
    }()
    
    init(text: String) {
        self.text = text
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillDraw() {
        super.viewWillDraw()
        scrollView.documentView = textView
        addSubview(scrollView)
        setupScrollViewConstraints()
    }
    
    func setupScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}
