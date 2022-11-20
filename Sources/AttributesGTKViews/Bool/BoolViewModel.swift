import Attributes

final class BoolViewModel {

    /// The attribute that is displayed by this view.
    /// 
    /// When changing the value of this attribute, `widget` is updated to match.
    var attribute: LineAttribute {
        didSet {
            callback(self, attribute.boolValue)
        }
    }

    private var callback: (BoolViewModel, Bool) -> Void

    /// Create a new BoolView.
    /// 
    /// - Parameter attribute: The attribute that is displayed by this view.
    init(attribute: LineAttribute, onAttributeChange: @escaping (BoolViewModel, Bool) -> Void = { _, _ in }) {
        self.attribute = attribute
        self.callback = onAttributeChange
    }

    func onAttributeChange(_ callback: @escaping (BoolViewModel, Bool) -> Void) {
        self.callback = callback
    }

}
