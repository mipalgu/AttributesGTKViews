// GTKViewTester.swift 
// AttributesGTKViews 
// 
// Created by Morgan McColl.
// Copyright © 2022 Morgan McColl. All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// 
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 
// 2. Redistributions in binary form must reproduce the above
//    copyright notice, this list of conditions and the following
//    disclaimer in the documentation and/or other materials
//    provided with the distribution.
// 
// 3. All advertising materials mentioning features or use of this
//    software must display the following acknowledgement:
// 
//    This product includes software developed by Morgan McColl.
// 
// 4. Neither the name of the author nor the names of contributors
//    may be used to endorse or promote products derived from this
//    software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// 
// -----------------------------------------------------------------------
// This program is free software; you can redistribute it and/or
// modify it under the above terms or under the terms of the GNU
// General Public License as published by the Free Software Foundation;
// either version 2 of the License, or (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program; if not, see http://www.gnu.org/licenses/
// or write to the Free Software Foundation, Inc., 51 Franklin Street,
// Fifth Floor, Boston, MA  02110-1301, USA.
// 

import Foundation
import Gtk
import XCTest

/// Helper protocol for performing tests using GTK view.
protocol GTKViewTester {

    /// Perform some GTK code without displaying the view.
    /// - Parameter fn: The code to perform that uses GTK.
    func exec(_ fn: @escaping (ApplicationRef) -> Void)

    /// Preform some GTK code that also displays some view.
    /// - Parameters:
    ///   - fn: A function that creates a view that will be displayed.
    ///   - width: The width of the application window containing the view.
    ///   - height: The height of the applicaton window containing the view.
    func preview<Widget>(
        _ fn: @escaping () -> Widget, width: Int, height: Int
    ) where Widget: WidgetProtocol

}

/// ``GTKViewTester`` default implementation.
extension GTKViewTester {

    /// Perform some GTK code without displaying the view. This function creates
    /// a default app that the GTK code is run within. This function also asserts
    /// that the return status from the application is equal to `EXIT_SUCCESS`.
    /// - Parameter fn: The code to perform that uses GTK.
    func exec(_ fn: @escaping (ApplicationRef) -> Void) {
        let status = Application.run(startupHandler: nil, activationHandler: fn)
        XCTAssertEqual(status, Int(EXIT_SUCCESS))
    }

    /// Preform some GTK code that also displays some view. This function creates
    /// a GTK application and window of suitable size, and then adds the view
    /// created by `fn` as a child of the window.
    /// - Parameters:
    ///   - fn: A function that creates a view that will be displayed.
    ///   - width: The width of the application window containing the view.
    ///   - height: The height of the applicaton window containing the view.
    func preview<Widget>(
        _ fn: @escaping () -> Widget, width: Int = 320, height: Int = 240
    ) where Widget: WidgetProtocol {
        exec { app in
            let window = ApplicationWindowRef(application: app)
            window.title = "AttributesGTKViewsTests"
            window.setDefaultSize(width: width, height: height)
            window.set(child: fn())
            window.show()
        }
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
    func testPreview<Widget>(
        width: Int = 320,
        height: Int = 240,
        widget: @escaping () -> Widget,
        task: @escaping () async throws -> Void = { sleep(5) }
    ) where Widget: WidgetProtocol {
        exec { app in
            let window = ApplicationWindowRef(application: app)
            window.title = "AttributesGTKViewsTests"
            window.setDefaultSize(width: width, height: height)
            window.set(child: widget())
            window.show()
            Task {
                try await task()
                window.close()
                app.quit()
            }
        }
    }

}
