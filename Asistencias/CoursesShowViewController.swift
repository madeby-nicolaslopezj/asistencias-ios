//
//  CoursesShowViewController.swift
//  Asistencias
//
//  Created by Nicolás López on 11-06-15.
//  Copyright (c) 2015 Nicolás López. All rights reserved.
//

import UIKit
import CoreData
import Meteor

class CoursesShowViewController: FetchedResultsViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rutInputContainerView: UIView!
    @IBOutlet weak var moduleLabel: UILabel!
    @IBOutlet weak var studentsCountLabel: UILabel!
    @IBOutlet weak var startSessionButton: UIButton!
    
    var rutInputViewController: RutInputViewController?
    
    // MARK: - Model

    var courseID: NSManagedObjectID? {
        didSet {
            assert(managedObjectContext != nil)
            
            if courseID != nil {
                if courseID != oldValue {
                    course = managedObjectContext!.existingObjectWithID(self.courseID!, error: nil) as? Course
                }
            } else {
                course = nil
            }
        }
    }
    
    private var courseObserver: ManagedObjectObserver?

    private var course: Course? {
        didSet {
            if course != oldValue {
                if course != nil {
                    courseObserver = ManagedObjectObserver(course!) { (changeType) -> Void in
                        switch changeType {
                        case .Deleted, .Invalidated:
                            self.course = nil
                        case .Updated, .Refreshed:
                            self.courseDidChange()
                        default:
                            break
                        }
                    }
                } else {
                    courseObserver = nil
                    resetContent()
                }
                
                courseDidChange()
                setNeedsLoadContent()
            }
        }
    }
    
    func courseDidChange() {

        if course != nil {
            if let sessionId = course?.valueForKey("currentSessionId") as! String? {
                var objectId = METDocumentKey(collectionName: "sessions", documentID: sessionId)
                var managedId = Meteor.objectIDForDocumentKey(objectId)
                self.sessionID = managedId
            }
        }
        
        if isViewLoaded() {
            updateViewWithModel()
        }
        
    }
    
    var sessionID: NSManagedObjectID? {
        didSet {
            assert(managedObjectContext != nil)
            
            if let currentSessionId = sessionID {
                if let currentSession = managedObjectContext!.existingObjectWithID(self.sessionID!, error: nil) as? Session {
                    session = currentSession
                } else {
                    dispatch_after(500, dispatch_get_main_queue(), {
                        self.sessionID = currentSessionId
                    });
                }
            } else {
                session = nil
            }
        }
    }
    
    private var sessionObserver: ManagedObjectObserver?
    
    private var session: Session? {
        didSet {
            if session != oldValue {
                if session != nil {
                    sessionObserver = ManagedObjectObserver(session!) { (changeType) -> Void in
                        switch changeType {
                        case .Deleted, .Invalidated:
                            self.session = nil
                        case .Updated, .Refreshed:
                            self.sessionDidChange()
                        default:
                            break
                        }
                    }
                } else {
                    sessionObserver = nil
                    resetContent()
                }
                
                sessionDidChange()
                setNeedsLoadContent()
            }
        }
    }
    
    func sessionDidChange() {
        if isViewLoaded() {
            updateViewWithModel()
        }
        initCheckCount()
    }
    
    private var checksCount: Int {
        get {
            if course != nil {
                if let sessionId = course?.valueForKey("currentSessionId") as! String? {
                    let fetchRequest = NSFetchRequest(entityName: "Check")
                    fetchRequest.predicate = NSPredicate(format: "session == %@", sessionId)
                    
                    var error = NSErrorPointer()
                    var results: Array = managedObjectContext.executeFetchRequest(fetchRequest, error: error)!
                    
                    return results.count
                }
            }
            
            return 0
        }
    }
    
    
    private var checksCountController: NSFetchedResultsController?
    
    func initCheckCount() {
        if course != nil {
            if let sessionId = course?.valueForKey("currentSessionId") as! String? {
                let fetchRequest = NSFetchRequest(entityName: "Check")
                fetchRequest.predicate = NSPredicate(format: "session == %@", sessionId)
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "session", ascending: true)]
                
                var error = NSErrorPointer()
                var results: Array = managedObjectContext.executeFetchRequest(fetchRequest, error: error)!
                
                checksCountController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
                
                checksCountController!.delegate = self
                checksCountController!.performFetch(error)
                
                if error != nil {
                    println("Error fetching check count \(error)")
                }
            }
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        checksCountDidChange()
    }
    
    func checksCountDidChange() {
        if isViewLoaded() {
            updateViewWithModel()
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.masksToBounds = true
        self.startSessionButton!.addTarget(self, action: "createSession", forControlEvents: UIControlEvents.TouchUpInside)
        //addTaskContainerView.preservesSuperviewLayoutMargins = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateViewWithModel()
    }
    
    // MARK: - Content Loading
    
    override func loadContent() {
        if course == nil {
            return
        }
        
        super.loadContent()
    }
    
    override func configureSubscriptionLoader(subscriptionLoader: SubscriptionLoader) {
        if course != nil {
            subscriptionLoader.addSubscriptionWithName("app.course", parameters: course!)
        }
    }
    
    // MARK: - Updating View
    
    func updateViewWithModel() {
        if course == nil {
            
        } else {
            self.nameLabel!.text = course?.name
            
            
            if self.session == nil {
                self.rutInputContainerView!.hidden = true
                self.startSessionButton!.hidden = false
                self.studentsCountLabel!.text = "No ha empezado la sesión"
                self.moduleLabel!.text = ""
            } else {
                if let module = session?.module {
                    self.moduleLabel.text = "Modulo \(module)"
                }
                
                if self.checksCount == 1 {
                    self.studentsCountLabel!.text = "\(self.checksCount) alumno marcó asistencia"
                } else {
                    self.studentsCountLabel!.text = "\(self.checksCount) alumnos marcaron asistencias"
                }
                
                self.rutInputContainerView!.hidden = false
                self.startSessionButton!.hidden = true
                
            }
            
            
            
            
        }
    }
    
    // MARK: - Actions

    @IBAction func closeButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Rut Delegate
    
    func getStudentNameWithRut(rut: String) -> String? {
        
        let fetchRequest = NSFetchRequest(entityName: "Student")
        fetchRequest.predicate = NSPredicate(format: "rut == %@", rut)
        fetchRequest.fetchLimit = 1;
        
        var error: NSErrorPointer = nil
        var results: Array = managedObjectContext.executeFetchRequest(fetchRequest, error: error)!
        
        if results.count == 1 {
            var student = results[0] as! Student
            self.markStudentAssistance(student)
            return student.name
        }
        
        return nil
    }
    
    func markStudentAssistance(student: Student) {
        println("Checking in...")
        self.session?.addStudent(student);
    }
    
    // MARK: - Create Session
    
    func createSession() {
        println("Creating new session")
        let courseId: String = Meteor.documentKeyForObjectID(course!.objectID).documentID as! String
        
        let newSession = NSEntityDescription.insertNewObjectForEntityForName("Session", inManagedObjectContext:managedObjectContext) as! Session
        newSession.course = courseId
        //newSession.module = ModuleHelper.module
        
        var error = NSErrorPointer()
        if !managedObjectContext.save(error) {
            println("Encountered error saving objects: \(error)")
        } else {
            println("Session created")
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRutInput" {
            rutInputViewController = segue.destinationViewController as? RutInputViewController
            rutInputViewController?.coursesShowViewController = self
        }
    }
    
}
