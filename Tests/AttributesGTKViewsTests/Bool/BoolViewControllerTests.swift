import Attributes
import Foundation
import Gtk
import XCTest

@testable import AttributesGTKViews

/// Test class for ``BoolViewController``.
final class BoolViewControllerTests: GTKTestCase {

    /// A ref containing a modifiable object with a bool value.
    var ref: Ref<EmptyModifiable>!

    /// A path to the bool value within the modifiable object referenced by ref.
    var path: Path<EmptyModifiable, Bool>!

    /// Reinstantiate the view before every test.
    override func gtkSetUp() async throws {
        let modifiable = EmptyModifiable(
            attributes: [
                AttributeGroup(
                    name: "Group",
                    fields: [Field(name: "bool", type: .bool)],
                    attributes: [
                        "bool": .bool(false)
                    ]
                )
            ]
        )
        self.ref = Ref(copying: modifiable)
        self.path = EmptyModifiable.path.attributes[0].attributes["bool"].wrappedValue.lineAttribute.boolValue
    }

    /// Test the init sets the attributes correctly.
    func testMainInit() {
        exec { _ in
            let viewModel = BoolViewModel(
                root: self.ref,
                path: self.path,
                defaultValue: false,
                label: "Bool"
            )
            let view = BoolView()
            let controller = BoolViewController(viewModel: viewModel, view: view)
            XCTAssertIdentical(controller.viewModel, viewModel)
            XCTAssertIdentical(controller.view, view)
            try self.checkSync(controller: controller)
        }
    }

    /// Checks whether the view model and view are updated when the other
    /// changes.
    /// 
    /// - Parameter controller: The controller that ties the view model and
    /// view together.
    private func checkSync(controller: BoolViewController) throws {
        XCTAssertFalse(controller.viewModel.value)
        XCTAssertFalse(controller.view.currentState)
        controller.viewModel.value = true
        XCTAssertTrue(controller.viewModel.value)
        XCTAssertTrue(controller.view.currentState)
        controller.viewModel.value = false
        XCTAssertFalse(controller.viewModel.value)
        XCTAssertFalse(controller.view.currentState)
        controller.view.currentState = true
        XCTAssertTrue(controller.viewModel.value)
        XCTAssertTrue(controller.view.currentState)
        controller.view.currentState = false
        XCTAssertFalse(controller.viewModel.value)
        XCTAssertFalse(controller.view.currentState)
    }

}
