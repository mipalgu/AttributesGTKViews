import Gtk
import XCTest

class GTKTestCase: XCTestCase {

    /// An error for when polling a condition and it times out.
    private struct TimeoutError: Error {

        /// The error message.
        let description: String = "Timed out."

    }

    func gtkSetUp() async throws {}

    func gtkTearDown() async throws {}

    /// Perform some GTK code without displaying the view. This function creates
    /// a default app that the GTK code is run within. This function also asserts
    /// that the return status from the application is equal to `EXIT_SUCCESS`.
    /// - Parameter fn: The code to perform that uses GTK.
    func exec(_ fn: @escaping (ApplicationRef) async throws -> Void) {
        let status = Application.run(startupHandler: nil) { app in
            do {
                try self.poll {
                    try await self.gtkSetUp()
                    try await fn(app)
                    try await self.gtkTearDown()
                }
            } catch {
                XCTFail("\(error)")
            }
        }
        XCTAssertEqual(status, Int(EXIT_SUCCESS))
    }

    /// Preform some GTK code that also displays some view. This function creates
    /// a GTK application and window of suitable size, and then adds the view
    /// created by `fn` as a child of the window.
    /// - Parameters:
    ///   - width: The width of the application window containing the view.
    ///   - height: The height of the applicaton window containing the view.
    ///   - widget: A function that creates a view that will be displayed.
    ///   - task: A function to execute on a background thread while the view is
    /// displayed. The windows and app are terminated once this function
    /// returns.
    func preview<Widget>(
        width: Int = 320,
        height: Int = 240,
        widget: @escaping () -> Widget,
        task: @escaping () async throws -> Void = { sleep(5) }
    ) where Widget: WidgetProtocol {
        let status = Application.run(startupHandler: nil) { app in
            do {
                try self.poll { try await self.gtkSetUp() }
            } catch {
                XCTFail("\(error)")
                return
            }
            let window = ApplicationWindowRef(application: app)
            window.title = "AttributesGTKViewsTests"
            window.setDefaultSize(width: width, height: height)
            window.set(child: widget())
            window.show()
            Task {
                defer {
                    do {
                        try self.poll { try await self.gtkTearDown() }
                    } catch {
                        XCTFail("\(error)")
                    }
                    window.destroy()
                }
                try await task()
            }
        }
        XCTAssertEqual(status, Int(EXIT_SUCCESS))
    }

    func poll(_ task: @escaping () async throws -> Void) throws {
        let data = SharedData()
        let dataActor = SharedDataActor(data: data)
        Task {
            do {
                try await task()
            } catch {
                await dataActor.data.thrownError = error
            }
            await dataActor.data.running = false
        }
        while data.running {
            usleep(5000)
        }
        if let thrownError = data.thrownError {
            throw thrownError
        }
    }

    func pollCondition(timeout: Int = 60, _ task: @escaping () async -> Bool) throws {
        let data = SharedData()
        let dataActor = SharedDataActor(data: data)
        Task {
            for _ in 0..<timeout {
                if await task() {
                    await dataActor.data.running = false
                    return
                }
                sleep(1)
            }
            await dataActor.data.thrownError = TimeoutError()
            await dataActor.data.running = false
        }
        while data.running {
            usleep(5000)
        }
        if let thrownError = data.thrownError {
            throw thrownError
        }
    }

}

private final class SharedData {

    var running = true

    var thrownError: Error?

}

private actor SharedDataActor {

    var data: SharedData

    init(data: SharedData) {
        self.data = data
    }

}
