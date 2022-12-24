import Attributes

/// The BoolViewController is the type that is responsible for managing and
/// displaying a view for a `LineAttribute.bool` property.
public final class BoolViewController {

    /// The underlying view model that is reponsible for managing the data
    /// associated with this controller.
    let viewModel: BoolViewModel

    /// The view that is responsible for presenting the data associated with
    /// this controller to the screen.
    let view: BoolView

    /// Create a new BoolViewController.
    /// 
    /// This initialiser creates a new BoolViewController utilising a key path
    /// from a `Modifiable` object that contains the value that this
    /// view model is associated with.
    /// 
    /// - Parameter root: A reference to the base `Modifiable` object that
    /// contains the value that this view model is associated with.
    /// 
    /// - Parameter path: An `Attributes.Path` that points to the value
    /// from the base `Modifiable` object.
    /// 
    /// - Parameter defaultValue: The defalut value to use for the
    /// value if the value ceases to exist. This is necessary to
    /// prevent `SwiftUi` crashes during animations when the value is
    /// deleted.
    /// 
    /// - Parameter label: The label to use when presenting the value.
    /// 
    /// - Parameter notifier: A `GlobalChangeNotifier` that will be used to
    /// notify any listeners when a trigger is fired.
    public convenience init<Root: Modifiable>(
        root: Ref<Root>,
        path: Attributes.Path<Root, Bool>,
        defaultValue: Bool,
        label: String,
        notifier: GlobalChangeNotifier? = nil
    ) {
        let viewModel = BoolViewModel(
            root: root,
            path: path,
            defaultValue: defaultValue,
            label: label,
            notifier: notifier
        )
        let view = BoolView(state: defaultValue)
        self.init(viewModel: viewModel, view: view)
    }

    /// Create a new BoolViewController.
    /// 
    /// This initialiser creates a new BoolViewController utilising a key path
    /// from a `Modifiable` object that contains the value that this
    /// view model is associated with.
    /// 
    /// - Parameter root: A reference to the base `Modifiable` object that
    /// contains the value that this view model is associated with.
    /// 
    /// - Parameter path: An `Attributes.Path` that points to an optional
    /// containing the value from the base `Modifiable` object.
    /// 
    /// - Parameter defaultValue: The defalut value to use for the
    /// value if the value ceases to exist. This is necessary to
    /// prevent `SwiftUi` crashes during animations when the value is
    /// deleted.
    /// 
    /// - Parameter label: The label to use when presenting the value.
    /// 
    /// - Parameter notifier: A `GlobalChangeNotifier` that will be used to
    /// notify any listeners when a trigger is fired.
    public convenience init<Root: Modifiable>(
        root: Ref<Root>,
        path: Attributes.Path<Root, Bool?>,
        defaultValue: Bool,
        label: String,
        notifier: GlobalChangeNotifier? = nil
    ) {
        let viewModel = BoolViewModel(
            root: root,
            path: path,
            defaultValue: defaultValue,
            label: label,
            notifier: notifier
        )
        let view = BoolView(state: defaultValue)
        self.init(viewModel: viewModel, view: view)
    }

    /// Create a new BoolViewController.
    /// 
    /// This initialiser creates a new BoolViewController utilising a
    /// reference to the value directly. It is useful to call this
    /// initialiser when utilising values that do not exist within a
    /// `Modifiable` object.
    /// 
    /// - Parameter valueRef: A reference to the value that this view model
    /// is associated with.
    /// 
    /// - Parameter errorsRef: A const-reference to the errors that are
    /// associated with the value.
    /// 
    /// - Parameter label: The label to use when presenting the value.
    public convenience init(
        valueRef: Ref<Bool>,
        errorsRef: ConstRef<[String]> = ConstRef(copying: []),
        label: String
    ) {
        let viewModel = BoolViewModel(valueRef: valueRef, errorsRef: errorsRef, label: label)
        let view = BoolView()
        self.init(viewModel: viewModel, view: view)
    }

    /// Create a new BoolViewController.
    /// 
    /// This initialiser creates a BoolViewController by taking the underlying
    /// view model and view directly. Generally, this initialiser is redundant
    /// and shouldn't be called directly. The several convience initialisers
    /// on this controller should be used instead.
    /// 
    /// This controller is responsible for tying the data associated with
    /// a boolean to a view. In other words, this controller simply leaves
    /// the data management to an underlying view model and the presentation
    /// of that data to an underlying view. Therefore, this controller simply
    /// facilitates the communication between the view model and view so that
    /// when changes occur in the data they are reflected within the GUI, and,
    /// vice versa, when changes occur within the GUI (generally from user
    /// interaction), those changes are reflected within the underlying data.
    /// 
    /// - Parameter viewModel: The view model that contains the manages the
    /// data associated with this controller.
    /// 
    /// - Parameter view: The view that is responsible for presenting the
    /// data of this controller within the user interface.
    init(viewModel: BoolViewModel, view: BoolView) {
        self.viewModel = viewModel
        self.view = view
        self.view.currentState = self.viewModel.value
        self.view.onStateChange { [weak self] _, value in
            guard let self else { return }
            self.viewModel.value = value
        }
        self.viewModel.onValueChange { [weak self] _, value in
            guard let self else { return }
            self.view.currentState = value
        }
    }

}
