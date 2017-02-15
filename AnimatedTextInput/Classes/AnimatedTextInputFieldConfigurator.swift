import UIKit

public struct AnimatedTextInputFieldConfigurator {

    public enum AnimatedTextInputType {
        case standard
        case email
        case password
        case numeric
        case selection
        case multiline
        case generic(textInput: TextInput)
        case customImage(image: UIImage?, autocapitalizationType: UITextAutocapitalizationType, autocorrectionType: UITextAutocorrectionType, keyboardType: UIKeyboardType)
        case customPassword(image: UIImage?, selectedImage: UIImage?, viewMode: UITextFieldViewMode)
    }

    static func configure(with type: AnimatedTextInputType) -> TextInput {
        switch type {
        case .standard:
            return AnimatedTextInputTextConfigurator.generate()
        case .email:
            return AnimatedTextInputEmailConfigurator.generate()
        case .password:
            return AnimatedTextInputPasswordConfigurator.generate()
        case .numeric:
            return AnimatedTextInputNumericConfigurator.generate()
        case .selection:
            return AnimatedTextInputSelectionConfigurator.generate()
        case .multiline:
            return AnimatedTextInputMultilineConfigurator.generate()
        case .generic(let textInput):
            return textInput
        case .customImage(let image, let autocapitalizationType, let autocorrectionType, let keyboardType):
            return AnimatedTextInputCustomImageConfigurator.generate(image: image, autocapitalizationType: autocapitalizationType, autocorrectionType: autocorrectionType, keyboardType: keyboardType)
        case .customPassword(let image, let selectedImage, let viewMode):
            return AnimatedTextInputCustomPasswordConfigurator.generate(image: image, selectedImage: selectedImage, viewMode: viewMode)
        }
    }
}


fileprivate struct Configuration {
    static let rightViewSize = CGSize(width: 51.0, height: 20.0)
}

fileprivate struct AnimatedTextInputTextConfigurator {
    
    static func generate() -> TextInput {
        let textField = AnimatedTextField()
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        return textField
    }
}

fileprivate struct AnimatedTextInputEmailConfigurator {

    static func generate() -> TextInput {
        let textField = AnimatedTextField()
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }
}

fileprivate struct AnimatedTextInputPasswordConfigurator {

    static func generate() -> TextInput {
        let bundle = Bundle(path: Bundle(for: AnimatedTextInput.self).path(forResource: "AnimatedTextInput", ofType: "bundle")!)
        let normalImage = UIImage(named: "cm_icon_input_eye_normal", in: bundle, compatibleWith: nil)
        let selectedImage = UIImage(named: "cm_icon_input_eye_selected", in: bundle, compatibleWith: nil)
        
        return AnimatedTextInputCustomPasswordConfigurator.generate(image: normalImage, selectedImage: selectedImage, viewMode: .whileEditing)
    }
}

fileprivate struct AnimatedTextInputNumericConfigurator {

    static func generate() -> TextInput {
        let textField = AnimatedTextField()
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .decimalPad
        textField.autocorrectionType = .no
        return textField
    }
}

fileprivate struct AnimatedTextInputSelectionConfigurator {

    static func generate() -> TextInput {
        let textField = AnimatedTextField()
        let bundle = Bundle(path: Bundle(for: AnimatedTextInput.self).path(forResource: "AnimatedTextInput", ofType: "bundle")!)
        let arrowImageView = UIImageView(image: UIImage(named: "disclosure", in: bundle, compatibleWith: nil))
        textField.rightView = arrowImageView
        textField.rightViewMode = .always
        textField.isUserInteractionEnabled = false
        return textField
    }
}

fileprivate struct AnimatedTextInputMultilineConfigurator {

    static func generate() -> TextInput {
        let textView = AnimatedTextView()
        textView.textContainerInset = .zero
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.autocorrectionType = .no
        return textView
    }
}

fileprivate struct AnimatedTextInputCustomImageConfigurator {

    static func generate(image: UIImage?,
                         autocapitalizationType: UITextAutocapitalizationType,
                         autocorrectionType: UITextAutocorrectionType,
                         keyboardType: UIKeyboardType) -> TextInput
    {
        let textField = AnimatedTextField()
        textField.rightViewMode = .always
        textField.keyboardType = keyboardType
        textField.autocorrectionType = autocorrectionType
        textField.autocapitalizationType = autocapitalizationType
        textField.rightViewPadding = 0.0
        let rightImage = UIImageView(image: image)
        rightImage.highlightedImage = UIImage(named: "alert_icon", in: nil, compatibleWith: nil)
        rightImage.frame = CGRect(origin: CGPoint.zero, size: Configuration.rightViewSize)
        rightImage.contentMode = .scaleAspectFit
        textField.rightView = rightImage
        textField.alertHandler = { alerted in
            rightImage.isHighlighted = alerted
        }
        
        return textField
    }
}

fileprivate struct AnimatedTextInputCustomPasswordConfigurator {
    
    static func generate(image normalImage: UIImage?, selectedImage: UIImage?, viewMode: UITextFieldViewMode) -> TextInput {
        let textField = AnimatedTextField()
        textField.rightViewMode = viewMode
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.rightViewPadding = 0.0
        let disclosureButton = UIButton(type: .custom)
        disclosureButton.frame = CGRect(origin: CGPoint.zero, size: Configuration.rightViewSize)
        disclosureButton.setImage(normalImage, for: .normal)
        disclosureButton.setImage(selectedImage, for: .selected)
        disclosureButton.setImage(UIImage(named: "alert_icon", in: nil, compatibleWith: nil), for: .disabled)
        textField.alertHandler = { alerted in
            disclosureButton.isEnabled = !alerted
        }
        
        textField.add(disclosureButton: disclosureButton) {
            disclosureButton.isSelected = !disclosureButton.isSelected
            let isResponder = textField.isFirstResponder
            textField.isSecureTextEntry = !textField.isSecureTextEntry
            if isResponder {
                textField.becomeFirstResponder()
            }
        }

        return textField
    }
}
