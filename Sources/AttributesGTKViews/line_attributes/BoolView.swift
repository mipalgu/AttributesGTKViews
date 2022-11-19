import Attributes
import Foundation
import Gtk

/// A view for displaying a boolean attribute.
/// 
/// The view uses a `Gtk.Switch` to display the value.
final class BoolView {

    /// The widget that is shown on screen.
    /// 
    /// This widget automatically updates `attribute` when the user changes
    /// the position of the switch.
    private(set) lazy var widget: Switch = {
        let widget = Switch()
        widget.state = attribute.boolValue
        widget.onStateSet { [weak self] _, value in
            guard let self else { return false }
            self.attribute.boolValue = value
            return false
        }
        return widget
    }()

    /// The attribute that is displayed by this view.
    /// 
    /// When changing the value of this attribute, `widget` is updated to match.
    var attribute: LineAttribute {
        didSet {
            widget.state = attribute.boolValue
        }
    }

    /// Create a new BoolView.
    /// 
    /// - Parameter attribute: The attribute that is displayed by this view.
    init(attribute: LineAttribute) {
        self.attribute = attribute
    }

}
