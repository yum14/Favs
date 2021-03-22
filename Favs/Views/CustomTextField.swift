//
//  CustomTextField.swift
//  CustomTextField
//
//  Created by yum on 2021/03/14.
//

import Swift
import SwiftUI
import Combine

struct CustomTextField: UIViewRepresentable {
    
    private var placeholder: String
    @Binding private var text: String
    private var textField = UITextField()
    private var isFirstResponder: Bool? = false
    private var onCommit: () -> Void
    
    init(_ placeholder: String, text: Binding<String>, isFirstResponder: Bool?, onCommit: @escaping () -> Void = { }) {
        self.placeholder = placeholder
        self._text = text
        self.isFirstResponder = isFirstResponder
        self.onCommit = onCommit
    }
    
    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
        textField.placeholder = self.placeholder
        textField.delegate = context.coordinator
        return textField
    }
    
    func makeCoordinator() -> CustomTextField.Coordinator {
        return Coordinator(textField: textField, text: $text, onCommit: onCommit)
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.text = text
        
        DispatchQueue.main.async {
            if let isFirstResponder = self.isFirstResponder, uiView.window != nil {
                if isFirstResponder && !uiView.isFirstResponder {
                    uiView.becomeFirstResponder()
                } else if !isFirstResponder && uiView.isFirstResponder {
                    uiView.resignFirstResponder()
                }
            }
        }
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        private var dispose = Set<AnyCancellable>()
        private var onCommit: () -> Void
        @Binding var text: String
        var didBecomeFirstResponder = false
        
        init(textField: UITextField, text: Binding<String>, onCommit: @escaping () -> Void = {}) {
            
            self._text = text
            self.onCommit = onCommit
            super.init()
            
            textField.delegate = self
            NotificationCenter.default
                .publisher(for: UITextField.textDidChangeNotification, object: textField)
                .compactMap { $0.object as? UITextField }
                .filter { $0.markedTextRange == nil } // マークされたテキストを無視する
                .compactMap { $0.text }
                .receive(on: RunLoop.main)
                .assign(to: \.text, on: self)
                .store(in: &dispose)
            
        }
        
        public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            self.onCommit()
        }
        
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            
            return true
        }
        //        func textFieldDidChangeSelection(_ textField: UITextField) {
        //            text = textField.text ?? ""
        //        }
        
    }
    
}
