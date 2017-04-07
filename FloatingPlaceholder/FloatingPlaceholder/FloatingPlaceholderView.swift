//
//  FloatingPlaceholderView.swift
//  FloatingPlaceholder
//
//  Created by Jeremiah on 07/04/17.
//  Copyright © 2017 Jeremiah. All rights reserved.
//

import UIKit
import CoreText
open class FloatingPlaceholderView: UIView {
//    open static var instanceTransformer: ((FloatingPlaceholderView) -> Void)! = {
//        orginal in
//    }
   public enum State {
        case normal,float
    }
  @IBInspectable open var isTransform = true
  @IBInspectable open var leftInset = 16
    @IBInspectable open var rightInset : CGFloat = 16
    @IBInspectable open var normalPlaceholderColor: UIColor = UIColor.gray
    @IBInspectable open var floatingPlaceholderColor: UIColor  = UIColor.blue
     @IBInspectable open var textInnerPadding: CGFloat = 2
    @IBInspectable open var textColor: UIColor = UIColor.black
   
    @IBInspectable open var stringPlaceholderName: String = ""{
    didSet
    {
      textPlaceholder.string = stringPlaceholderName
        }
    }
    
   open var textPlaceholder = CATextLayer()
    //HelveticaNeue
    @IBInspectable open var normalPlaceholderFontName = "HelveticaNeue"
     @IBInspectable open var floatingPlaceholderFontName = "HelveticaNeue"
     @IBInspectable open var normalPlaceholderFontSize = 16.0
    @IBInspectable open var floatingPlaceholderFontSize = 12.0
    @IBInspectable open var inputFontName: String = "HelveticaNeue"
    @IBInspectable open var inputFontSize: CGFloat = 16
    @IBInspectable open var animationDuration = 0.5
    
    open var state = State.normal
    open var textfield = UITextField()
    
    open override func awakeFromNib() {
        build()
        
    }
    open func build(){
        textPlaceholder.contentsScale = UIScreen.main.scale
        addSubview(textfield)
        layer.addSublayer(textPlaceholder)
        addGestureRecognizer(UITapGestureRecognizer(target:self,action:#selector(focus)))
        textfield.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
      //  if isTransform { FloatingPlaceholderView.instanceTransformer(self) }
        configFontsAndColors()
        changeToNormal(animated: false)
        
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    open func configFontsAndColors(){
        textPlaceholder.font = CGFont(normalPlaceholderFontName as CFString)
        textfield.textColor = textColor
        textfield.font = UIFont(name: inputFontName, size: inputFontSize)
        textfield.tintColor = tintColor
        
    }
    open func layout(){
        var currentX: CGFloat = CGFloat(leftInset)
        let placeHolderUIFont = state == .normal ? UIFont(name: normalPlaceholderFontName, size: CGFloat(normalPlaceholderFontSize)) : UIFont(name: normalPlaceholderFontName, size: CGFloat(floatingPlaceholderFontSize))
        let placeHolderHeight: CGFloat = placeHolderUIFont!.lineHeight + 2
        let textFieldHeight = textfield.font!.lineHeight + 2
        let inputHeight = placeHolderHeight + textInnerPadding + textFieldHeight
        let widthForInput  = viewWidth - currentX - rightInset
        if state == .normal {
            textPlaceholder.frame = CGRect(x: currentX, y: viewHeight.half - placeHolderHeight.half, width: widthForInput, height: CGFloat(normalPlaceholderFontSize + 4))
        } else {
            textPlaceholder.frame = CGRect(x: currentX, y: viewHeight.half - inputHeight.half, width: widthForInput, height: CGFloat(normalPlaceholderFontSize + 4))
        }
        textfield.frame = CGRect(x: CGFloat(currentX), y: viewHeight.half + inputHeight.half - textFieldHeight, width: widthForInput, height: textFieldHeight)

    }
    open func changeToFloat(animated: Bool) {
        let animationDuration = animated ? self.animationDuration : 0.0
        state = .float
        CATransaction.begin()
        CATransaction.setAnimationDuration(animationDuration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
        textPlaceholder.foregroundColor = floatingPlaceholderColor.cgColor
        textPlaceholder.fontSize = CGFloat(floatingPlaceholderFontSize)
        layout()
        CATransaction.commit()
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: .curveEaseOut
            , animations: {
                self.textfield.alpha = 1.0
        }
            , completion: {
                _ in
                
        })
    }

    open func changeToNormal (animated:Bool)
    {
        let animationDuration = animated ? self.animationDuration : 0.0
        state = .normal
        CATransaction.begin()
        CATransaction.setAnimationDuration(animationDuration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
        textPlaceholder.foregroundColor = normalPlaceholderColor.cgColor
        textPlaceholder.fontSize = CGFloat(normalPlaceholderFontSize)
        layout()
        CATransaction.commit()
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: .curveEaseOut
            , animations: {
                self.textfield.alpha = 0.0
        }
            , completion: {
                _ in
                
        })

    }
    open func editingDidEnd() {
        if let text = textfield.text, text.characters.count > 0 {
            changeToFloat(animated: true)
        } else {
            changeToNormal(animated: true)
        }
    }

    open func focus() {
        textfield.becomeFirstResponder()
        changeToFloat(animated: true)
    }
    
}
