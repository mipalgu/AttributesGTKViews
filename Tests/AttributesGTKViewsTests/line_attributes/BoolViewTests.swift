import Attributes
import Foundation
import Gtk
import XCTest

@testable import AttributesGTKViews

/// Test class for ``LineView``.
final class BoolViewTests: XCTestCase, GTKViewTester {

    /// The view under test.
    var view = BoolView(attribute: .bool(true))

    /// Reinstantiate the view before every test.
    override func setUp() {
        view = BoolView(attribute: .bool(true))
    }

    /// Test the init sets the attribute correctly.
    func testInit() {
        XCTAssertTrue(view.attribute.boolValue)
    }

    /// Test the GTK widget properties are created correctly for the given attribute.
    func testWidgetGetter() {
        exec { _ in
            let widget = self.view.widget
            XCTAssertTrue(widget.state)
        }
    }

    /// Tests whether the attribute and the widget remain in sync.
    func testWidgetAttributeSync() {
        XCTAssertTrue(view.attribute.boolValue)
        XCTAssertTrue(view.widget.active)
        XCTAssertTrue(view.widget.state)
        view.attribute.boolValue = false
        XCTAssertFalse(view.attribute.boolValue)
        XCTAssertFalse(view.widget.active)
        XCTAssertFalse(view.widget.state)
        view.widget.state = true
        XCTAssertTrue(view.attribute.boolValue)
        XCTAssertTrue(view.widget.active)
        XCTAssertTrue(view.widget.state)
    }

    #if SHOW_VIEWS

    /// Preview the ``LineView``.
    func testBoolView() {
        testPreview {
            self.view.widget
        } task: {
            for _ in 0..<10 {
                let newValue = !self.view.attribute.boolValue
                self.view.attribute.boolValue = newValue
                XCTAssertEqual(self.view.attribute.boolValue, newValue)
                XCTAssertEqual(self.view.widget.state, newValue)
                XCTAssertEqual(self.view.widget.active, newValue)
                usleep(250000)
            }
        }
    }

    #endif

}
