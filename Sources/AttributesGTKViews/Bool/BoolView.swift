import Gtk

/// A view for displaying a boolean attribute.
/// 
/// The view uses a `Gtk.Switch` to display the value.
final class BoolView {

    private(set) var widget: Switch

    var currentState: Bool {
        widget.state
    }

    init(state: Bool = false) {
        self.widget = Switch()
        self.widget.state = state
    }

    func onStateChange(_ callback: @escaping (BoolView, Bool) -> Void) {
        widget.onStateSet { [weak self] _, value in
            guard let self, value != self.widget.state else { return true }
            callback(self, value)
            return false
        }
    }

}
