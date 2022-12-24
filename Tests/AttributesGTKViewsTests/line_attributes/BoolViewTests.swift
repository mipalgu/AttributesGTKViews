import Attributes
import Foundation
import Gtk
import XCTest

@testable import AttributesGTKViews

/// Test class for ``BoolView``.
final class BoolViewTests: GTKTestCase {

    /// The view under test.
    var view: BoolView!

    /// Reinstantiate the view before every test.
    override func gtkSetUp() async throws {
        view = BoolView()
    }

    /// Test the init sets the attributes correctly.
    func testInit() {
        exec { _ in
            var view = BoolView(state: true)
            XCTAssertTrue(view.currentState)
            view = BoolView()
            XCTAssertFalse(view.currentState)
        }
    }

    /// Test the GTK widget properties are created correctly for the given attribute.
    func testWidgetGetter() {
        exec { _ in
            let widget = self.view.widget
            XCTAssertEqual(widget.state, self.view.currentState)
        }
    }

    /// Tests whether the attribute and the widget remain in sync.
    func testWidgetAttributeSync() {
        exec { [self] _ in
            XCTAssertFalse(self.view.currentState)
            XCTAssertFalse(self.view.widget.active)
            XCTAssertFalse(self.view.widget.state)
            view.widget.state = true
            XCTAssertTrue(self.view.currentState)
            XCTAssertTrue(self.view.widget.active)
            XCTAssertTrue(self.view.widget.state)
            view.widget.state = false
            XCTAssertFalse(self.view.currentState)
            XCTAssertFalse(self.view.widget.active)
            XCTAssertFalse(self.view.widget.state)
        }
    }

    func testCallbackIsTriggeredOnSetState() {
        exec { [self] _ in
            var reportedView: BoolView?
            var reportedValue = false
            self.view.onStateChange { view, value in
                reportedView = view
                reportedValue = value
            }
            self.view.currentState = true
            XCTAssertNotNil(reportedView)
            XCTAssertTrue(reportedValue)
            if let reportedView = reportedView {
                XCTAssertIdentical(reportedView, self.view)
            }
        }
    }

    #if SHOW_VIEWS

    /// Preview the ``BoolView``.
    func testBoolView() {
        preview {
            self.view.widget
        } task: {
            for _ in 0..<10 {
                let newValue = !self.view.currentState
                self.view.widget.state = newValue
                XCTAssertEqual(self.view.currentState, newValue)
                XCTAssertEqual(self.view.widget.state, newValue)
                XCTAssertEqual(self.view.widget.active, newValue)
                usleep(1000000)
            }
        }
    }

    #endif

}
