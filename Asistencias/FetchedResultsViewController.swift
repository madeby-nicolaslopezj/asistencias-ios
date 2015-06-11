//
//  FetchedResultsViewController.swift
//  Asistencias
//
//  Created by Nicolás López on 11-06-15.
//  Copyright (c) 2015 Nicolás López. All rights reserved.
//

import UIKit
import CoreData
import Meteor

class FetchedResultsViewController: UIViewController, ContentLoading, SubscriptionLoaderDelegate {
    // MARK: - Lifecycle
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Model
    
    var managedObjectContext: NSManagedObjectContext!
    
    func saveManagedObjectContext() {
        var error: NSError?
        if !managedObjectContext!.save(&error) {
            println("Encountered error saving managed object context: \(error)")
        }
    }
    
    // MARK: - View Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updatePlaceholderView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadContentIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        placeholderView?.frame = self.view.bounds
    }
    
    // MARK: - Content Loading
    
    private(set) var contentLoadingState: ContentLoadingState = .Initial  {
        didSet {
            if isViewLoaded() {
                updatePlaceholderView()
            }
        }
    }
    
    var isContentLoaded: Bool {
        switch contentLoadingState {
        case .Loaded:
            return true
        default:
            return false
        }
    }
    
    private(set) var needsLoadContent: Bool = true
    
    func setNeedsLoadContent() {
        needsLoadContent = true
        if isViewLoaded() {
            loadContentIfNeeded()
        }
    }
    
    func loadContentIfNeeded() {
        if needsLoadContent {
            loadContent()
        }
    }
    
    func loadContent() {
        needsLoadContent = false
        
        subscriptionLoader = SubscriptionLoader()
        subscriptionLoader!.delegate = self
        
        configureSubscriptionLoader(subscriptionLoader!)
        
        subscriptionLoader!.whenReady { [weak self] in
            self?.contentLoadingState = .Loaded
        }
        
        if !subscriptionLoader!.isReady {
            if Meteor.connectionStatus == .Offline {
                contentLoadingState = .Offline
            } else {
                contentLoadingState = .Loading
            }
        }
    }
    
    func resetContent() {
        subscriptionLoader = nil
        contentLoadingState = .Initial
    }
    
    
    
    private var subscriptionLoader: SubscriptionLoader?
    
    func configureSubscriptionLoader(subscriptionLoader: SubscriptionLoader) {
    }
    
    func createFetchedResultsController() -> NSFetchedResultsController? {
        return nil
    }
    
    // MARK: SubscriptionLoaderDelegate
    
    func subscriptionLoader(subscriptionLoader: SubscriptionLoader, subscription: METSubscription, didFailWithError error: NSError) {
        contentLoadingState = .Error(error)
    }
    
    // MARK: Connection Status Notification
    
    func connectionStatusDidChange() {
        if !isContentLoaded && Meteor.connectionStatus == .Offline {
            contentLoadingState = .Offline
        }
    }
    
    // MARK: - User
    
    /**var currentUser: User? {
    if let userID = Meteor.userID {
    let userObjectID = Meteor.objectIDForDocumentKey(METDocumentKey(collectionName: "users", documentID: userID))
    return managedObjectContext.existingObjectWithID(userObjectID, error: nil) as? User
    }
    return nil;
    }**/
    
    // MARK: - Placeholder View
    
    private var placeholderView: PlaceholderView?
    private var savedCellSeparatorStyle: UITableViewCellSeparatorStyle = .None
    
    func updatePlaceholderView() {
        if isContentLoaded {
            if placeholderView != nil {
                placeholderView?.removeFromSuperview()
                placeholderView = nil
            }
        } else {
            if placeholderView == nil {
                placeholderView = PlaceholderView()
                self.view.addSubview(placeholderView!)
            }
        }
        
        switch contentLoadingState {
        case .Loading:
            placeholderView?.showLoadingIndicator()
        case .Offline:
            placeholderView?.showTitle("Could not establish connection to server", message: nil)
        case .Error(let error):
            placeholderView?.showTitle(error.localizedDescription, message: error.localizedFailureReason)
        default:
            break
        }
    }

}
