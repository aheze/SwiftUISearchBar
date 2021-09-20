//
//  SearchBar.swift
//  SwiftUISearchBar
//
//  Created by Zheng on 9/20/21.
//

import SwiftUI
import Combine


/**
 View Modifier for applying the search bar.
 */
internal struct SearchBarModifier: ViewModifier {
    
    var searchBarConfigurator: SearchBarConfigurator
    
    func body(content: Content) -> some View {
        content
        .overlay(
            ViewControllerResolver { viewController in
                viewController.navigationItem.searchController = self.searchBarConfigurator.searchController
            }
            .frame(width: 0, height: 0)
        )
    }
}

/**
 Extension to make applying the View Modifier easier..
 */
extension View {
    func add(_ searchBarConfigurator: SearchBarConfigurator) -> some View {
        return self.modifier(SearchBarModifier(searchBarConfigurator: searchBarConfigurator))
    }
}

/**
 Access the parent view controller of the SwiftUI View.
 */
internal final class ViewControllerResolver: UIViewControllerRepresentable {
    
    /// Closure to call when `didMove`
    let onResolve: (UIViewController) -> Void
        
    init(onResolve: @escaping (UIViewController) -> Void) {
        self.onResolve = onResolve
    }
    
    func makeUIViewController(context: Context) -> ParentResolverViewController {
        ParentResolverViewController(onResolve: onResolve)
    }
    
    func updateUIViewController(_ uiViewController: ParentResolverViewController, context: Context) { }
}

internal class ParentResolverViewController: UIViewController {
    
    let onResolve: (UIViewController) -> Void
    
    init(onResolve: @escaping (UIViewController) -> Void) {
        self.onResolve = onResolve
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init(onResolve:) to instantiate ParentResolverViewController.")
    }
        
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if let parent = parent {
            onResolve(parent)
        }
    }
}

 /**
 Search bar at the top of the NavigationView.
 
 Source: [http://blog.eppz.eu/swiftui-search-bar-in-the-navigation-bar/]( http://blog.eppz.eu/swiftui-search-bar-in-the-navigation-bar/).
 
 MIT License
 */
class SearchBarConfigurator: NSObject, ObservableObject {
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    /// The text inside the search bar.
    @Published var searchText: String = "" {
        willSet {
            self.objectWillChange.send()
        }
    }
    
    /// Instance of the search controller.
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    override init() {
        super.init()
        
        /// Prevent a gray overlay over the list.
        self.searchController.obscuresBackgroundDuringPresentation = false
        
        /// Set the delegate.
        self.searchController.searchResultsUpdater = self
    }
}

/**
 Listen for changes in the search bar's text.
 */
extension SearchBarConfigurator: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        /// Publish search bar text changes.
        if let searchBarText = searchController.searchBar.text {
            self.searchText = searchBarText
        }
    }
}
