//
//  UITextView.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 11/04/22.
//

import SwiftUI
import UIKit


struct TextView: UIViewRepresentable {
 
    @Binding var text: String
    var placeholderText: String
    typealias UIViewType = UITextView
    func makeUIView(context: UIViewRepresentableContext<TextView>) -> UITextView {
          let textView = UITextView()
        textView.isSelectable = true
               textView.isUserInteractionEnabled = true
               textView.textColor = .lightGray
               textView.textContainer.lineFragmentPadding = 0
               textView.backgroundColor = .bkgColor()
               textView.layer.cornerRadius = 24
               textView.clipsToBounds = true
               textView.font = .init(name: DMSANSFONTLIST.Regular, size: 16)
               textView.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
          textView.textContainer.lineFragmentPadding = 0
          textView.textContainerInset = .zero
          textView.text = placeholderText
          textView.textColor = .placeholderText
        textView.tintColor = .black
          return textView
      }
 
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<TextView>) {
          
          if text != "" || uiView.textColor == .label {
              uiView.text = text
              uiView.textColor = .label
          }
          
          uiView.delegate = context.coordinator
      }
      
      func frame(numLines: CGFloat) -> some View {
          let height = UIFont.systemFont(ofSize: 17).lineHeight * numLines
          return self.frame(height: height)
      }
      
      func makeCoordinator() -> TextView.Coordinator {
          Coordinator(self)
      }
      
      class Coordinator: NSObject, UITextViewDelegate {
          var parent: TextView
          
          init(_ parent: TextView) {
              self.parent = parent
          }
          
          func textViewDidChange(_ textView: UITextView) {
              parent.text = textView.text
              textView.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
          }
          
          func textViewDidBeginEditing(_ textView: UITextView) {
              if textView.textColor == .placeholderText {
                  textView.text = ""
                  textView.textColor = .label
              }
              textView.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
          }
          
          func textViewDidEndEditing(_ textView: UITextView) {
              if textView.text == "" {
                  textView.text = parent.placeholderText
                  textView.textColor = .placeholderText
              }
              textView.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
          }
      }
}

struct UITextView_Previews: PreviewProvider {
    static var previews: some View {
        TextView(text: .constant("TextView"), placeholderText: "Placeholder")
    }
}
