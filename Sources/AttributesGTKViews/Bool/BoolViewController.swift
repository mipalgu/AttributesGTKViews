final class BoolViewController {

    private let viewModel: BoolViewModel

    private let view: BoolView

    init(viewModel: BoolViewModel, view: BoolView) {
        self.viewModel = viewModel
        self.view = view
        view.onStateChange { [weak self] _, value in
            guard let self else { return }
            self.viewModel.attribute.boolValue = value
        }
        viewModel.onAttributeChange { [weak self] _, value in
            guard let self else { return }
            self.view.widget.state = value
        }
        self.view.widget.state = self.viewModel.attribute.boolValue
    }

}
