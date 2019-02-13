//
//  ACDatabaseController.swift
//  ACTouchBar
//
//  Created by Yuhel Tanaka on 2019/02/06.
//  Copyright © 2019 Yuhel Tanaka. All rights reserved.
//

import Cocoa
import CoreData

class ACDatabaseController: NSObject {
    
    static let shared = ACDatabaseController()
    let appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate

    func fetchProblemsInformationData() -> [Problem] {
        var problems:[Problem] = []
        
        let managedContext: NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        managedContext.parent = appDelegate.persistentContainer.viewContext
        managedContext.automaticallyMergesChangesFromParent = true
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProblemsDB")
        
        do {
            let fetchedArray = try managedContext.fetch(fetchRequest)

            for problem in fetchedArray {
                let id = problem.value(forKey: "id") as! String
                let title = problem.value(forKey: "title") as! String
                let contest_id = problem.value(forKey: "contest_id") as! String
                problems.append(Problem.init(id: id, contest_id: title, title: contest_id))
            }
        } catch let error {
            print(error)
        }
        return problems
    }
    
    func fetchSubmissionDetailsData(user_id: String) -> [Submission] {
        var problems:[Submission] = []
        
        let managedContext: NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        
        managedContext.parent = appDelegate.persistentContainer.viewContext
        managedContext.automaticallyMergesChangesFromParent = true
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SubmissionsDB")
        let sortDescripter = NSSortDescriptor(key: "submission_id", ascending: false)
        let predicate = NSPredicate(format:"%K = %@", "user_id", user_id)
        
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescripter]
        fetchRequest.fetchLimit = globalVars.shared.numberOfRecentSubmissions
        
        do {
            let fetchedArray = try managedContext.fetch(fetchRequest)
            
            for problem in fetchedArray {
                let contest_id = problem.value(forKey: "contest_id") as! String
                let epoch_second = problem.value(forKey: "epoch_second") as! Int
                let execution_time = problem.value(forKey: "contest_id") as? Int
                let id = problem.value(forKey: "submission_id") as! Int
                let language = problem.value(forKey: "language") as! String
                let length = problem.value(forKey: "length") as! Int
                let point = problem.value(forKey: "point") as! Float
                let problem_id = problem.value(forKey: "problem_id") as! String
                let result = problem.value(forKey: "result") as! String
                let user_id = problem.value(forKey: "user_id") as! String
                let sub = Submission.init(execution_time: execution_time, point: point, result: result, problem_id: problem_id, user_id: user_id, epoch_second: epoch_second, contest_id: contest_id, id: id, language: language, length: length)
                problems.append(sub)
            }
        } catch let error {
            print(error)
        }
        return problems
    }
    
    func saveProblemsInformationData(problems: [Problem]) {
        let viewContext: NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
        viewContext.parent = appDelegate.persistentContainer.viewContext
        viewContext.automaticallyMergesChangesFromParent = true
        
        for problem in problems {
            guard let entity = NSEntityDescription.entity(forEntityName: "ProblemsDB", in: viewContext) else {continue}
            let newRecord = NSManagedObject(entity: entity, insertInto: viewContext)
            
            newRecord.setValue(problem.id, forKey: "id")
            newRecord.setValue(problem.contest_id, forKey: "contest_id")
            newRecord.setValue(problem.title, forKey: "title")
        }
        
        do {
            try viewContext.save()
            print("success")
        }
        catch let error {
            print(error)
        }
    }
    
    func saveSubmissionDetailsData(submissions: [Submission]) {        
        appDelegate.backgroundContext.performAndWait {
            for submission in submissions {
                guard let entity = NSEntityDescription.entity(forEntityName: "SubmissionsDB", in: appDelegate.backgroundContext) else {continue}
                let newRecord = NSManagedObject(entity: entity, insertInto: appDelegate.backgroundContext)
                
                newRecord.setValue(submission.execution_time, forKey: "execution_time")
                newRecord.setValue(submission.point, forKey: "point")
                newRecord.setValue(submission.result, forKey: "result")
                newRecord.setValue(submission.problem_id, forKey: "problem_id")
                newRecord.setValue(submission.user_id, forKey: "user_id")
                newRecord.setValue(submission.epoch_second, forKey: "epoch_second")
                newRecord.setValue(submission.contest_id, forKey: "contest_id")
                newRecord.setValue(submission.id, forKey: "submission_id")
                newRecord.setValue(submission.language, forKey: "language")
                newRecord.setValue(submission.length, forKey: "length")
            }
            
            do {
                try appDelegate.backgroundContext.save()
                
                print("success")
            }
            catch let error {
                print(error)
            }
        }
    }
    
    func removeSubmissionDetailsData() {
        appDelegate.backgroundContext.performAndWait {
        
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SubmissionsDB")
        
            do {
                let fetchedArray = try appDelegate.backgroundContext.fetch(fetchRequest)
                print(fetchedArray)
                for i in fetchedArray {
                    appDelegate.backgroundContext.delete(i)
                }
            } catch let error {
                print(error)
            }
            
            do {
                try appDelegate.backgroundContext.save()
                print("success")
            }
            catch let error {
                print(error)
            }
        
        }
    }
    
    func removeProblemsInformationData() {
        let managedContext: NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        managedContext.parent = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProblemsDB")
        
        do {
            let fetchedArray = try managedContext.fetch(fetchRequest)
            print(fetchedArray)
            for i in fetchedArray {
                managedContext.delete(i)
            }
        } catch let error {
            print(error)
        }
        
        do {
            try managedContext.save()
            print("success")
        }
        catch let error {
            print(error)
        }
    }
    
    func saveUserProfileData(user_id: String, profile: UserProfile) {
        appDelegate.backgroundContext.performAndWait {
            guard let entity = NSEntityDescription.entity(forEntityName: "UserProfileDB", in: appDelegate.backgroundContext) else {return}
            let newRecord = NSManagedObject(entity: entity, insertInto: appDelegate.backgroundContext)
            
            newRecord.setValue(user_id , forKey: "user_id")
            
            newRecord.setValue(profile.country , forKey: "country")
            newRecord.setValue(profile.birth_year , forKey: "birth_year")
            newRecord.setValue(profile.twitter_id , forKey: "twitter_id")
            newRecord.setValue(profile.affiliation , forKey: "affiliation")
            newRecord.setValue(profile.ranking , forKey: "ranking")
            newRecord.setValue(profile.current_rating , forKey: "current_rating")
            newRecord.setValue(profile.number_of_times_implemented , forKey: "number_of_times_implemented")
            
            let R = profile.current_color.redComponent
            let G = profile.current_color.greenComponent
            let B = profile.current_color.blueComponent
            let imageData = profile.image?.tiffRepresentation
            
            newRecord.setValue(R , forKey: "current_color_r")
            newRecord.setValue(G , forKey: "current_color_g")
            newRecord.setValue(B , forKey: "current_color_b")
            newRecord.setValue(imageData , forKey: "image")
            
            do {
                try appDelegate.backgroundContext.save()
                print("success")
            }
            catch let error {
                print(error)
            }
        }
    }
    
    func fetchUserProfileData(user_id: String) -> UserProfile {
        var profile:UserProfile = UserProfile()
        
        let managedContext: NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        managedContext.parent = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserProfileDB")
        let predicate = NSPredicate(format:"%K = %@", "user_id", user_id)
        fetchRequest.predicate = predicate
        
        do {
            let fetchedArray = try managedContext.fetch(fetchRequest)
            
            for info in fetchedArray {
                let country = info.value(forKey: "country") as? String
                profile.country = country
                
                let birth_year = info.value(forKey: "birth_year") as? Int
                profile.birth_year = birth_year
                
                let twitter_id = info.value(forKey: "twitter_id") as? String
                profile.twitter_id = twitter_id
                
                let affiliation = info.value(forKey: "affiliation") as? String
                profile.affiliation = affiliation
                
                let ranking = info.value(forKey: "ranking") as? String
                profile.ranking = ranking
                
                let current_rating = info.value(forKey: "current_rating") as! Int
                profile.current_rating = current_rating
                
                let highest_rating = info.value(forKey: "highest_rating") as! Int
                profile.highest_rating = highest_rating
                
                let number_of_times_implemented = info.value(forKey: "number_of_times_implemented") as? Int
                profile.number_of_times_implemented = number_of_times_implemented
                
                let current_color_r = info.value(forKey: "current_color_r") as? Float
                let current_color_g = info.value(forKey: "current_color_g") as? Float
                let current_color_b = info.value(forKey: "current_color_b") as? Float
                if let R = current_color_r, let G = current_color_g, let B = current_color_b {
                    let currentColor = NSColor.init(red: CGFloat(R), green: CGFloat(G), blue: CGFloat(B), alpha: 1.0)
                    profile.current_color = currentColor
                }
                
                let imagedata = info.value(forKey: "image") as? Data
                if let imageData = imagedata, let image = NSImage(data: imageData) {
                    profile.image = image
                }
                
            }
        } catch let error {
            print(error)
        }
        return profile
    }
    
    func fetchSubmissionInformationData(user_id: String) -> UserInfo {
        let managedContext: NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        managedContext.parent = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SubmissionInfoDB")
        let predicate = NSPredicate(format:"%K = %@", "account_id", user_id)
        fetchRequest.predicate = predicate
        
        do {
            let fetchedArray = try managedContext.fetch(fetchRequest)
            for problem in fetchedArray {
                let accepted_count_rank = problem.value(forKey: "accepted_count_rank") as! Int
                let rated_point_sum = problem.value(forKey: "rated_point_sum") as! Float
                let rated_point_sum_rank = problem.value(forKey: "rated_point_sum_rank") as! Int
                let user_id = problem.value(forKey: "account_id") as! String
                let accepted_count = problem.value(forKey: "accepted_count") as! Int
                
            return UserInfo.init(accepted_count_rank: accepted_count_rank, rated_point_sum_rank: rated_point_sum_rank, rated_point_sum: rated_point_sum, user_id: user_id, accepted_count: accepted_count)
            }
        } catch let error {
            print(error)
        }
        
        return UserInfo.init(accepted_count_rank: 0, rated_point_sum_rank: 0, rated_point_sum: 0, user_id: user_id, accepted_count: 0)
    }
    
    func saveSubmissionInformationData(userInfo: UserInfo) {
        appDelegate.backgroundContext.performAndWait {
            guard let entity = NSEntityDescription.entity(forEntityName: "SubmissionInfoDB", in: appDelegate.backgroundContext) else {return}
            let newRecord = NSManagedObject(entity: entity, insertInto: appDelegate.backgroundContext)
            
            newRecord.setValue(userInfo.accepted_count_rank , forKey: "accepted_count_rank")
            newRecord.setValue(userInfo.rated_point_sum_rank , forKey: "rated_point_sum_rank")
            newRecord.setValue(userInfo.rated_point_sum , forKey: "rated_point_sum")
            newRecord.setValue(userInfo.user_id , forKey: "account_id")
            newRecord.setValue(userInfo.accepted_count , forKey: "accepted_count")
            
            do {
                try appDelegate.backgroundContext.save()
                print("success!")
            }
            catch let error {
                print("error",error)

            }
        }
    }
    
    func removeSubmissionInformationData() {
        appDelegate.backgroundContext.performAndWait {
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SubmissionInfoDB")
            
            do {
                let fetchedArray = try appDelegate.backgroundContext.fetch(fetchRequest)
                print(fetchedArray)
                for i in fetchedArray {
                    appDelegate.backgroundContext.delete(i)
                }
            } catch let error {
                print(error)
            }
            
            do {
                try appDelegate.backgroundContext.save()
                print("success")
            }
            catch let error {
                print(error)
            }
            
        }
    }
}


