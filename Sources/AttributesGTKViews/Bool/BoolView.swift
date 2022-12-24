import Gtk

/// A view for displaying a boolean attribute.
/// 
/// The view uses a `Gtk.Switch` to display the value.
final class BoolView {

    private var _onStateChange: (BoolView, Bool) -> Void = { _, _ in }

    private(set) var widget: Switch

    var currentState: Bool {
        get {
            widget.state
        } set {
            guard newValue != currentState else {
                return
            }
            widget.state = newValue
            _onStateChange(self, newValue)
        }
    }

    init(state: Bool = false) {
        self.widget = Switch()
        self.widget.state = state
    }

    func onStateChange(_ callback: @escaping (BoolView, Bool) -> Void) {
        self._onStateChange = callback
        widget.onStateSet { [weak self] _, value in
            guard let self, value != self.widget.state else { return true }
            self._onStateChange(self, value)
            return false
        }
    }

}
