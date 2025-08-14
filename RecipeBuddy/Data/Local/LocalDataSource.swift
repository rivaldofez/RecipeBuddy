//
//  LocalDataSource.swift
//  RecipeBuddy
//
//  Created by Rivaldo Fernandes on 13/08/25.
//

import CoreData

protocol LocalDataSourceProtocol {
    func fetchRecipes(sortByTimeAscending: Bool, filterTags: [String], isFavorite: Bool?) async throws -> [RecipeModel]
    func fetchRecipe(for id: String) async throws -> RecipeModel?
    func insertIfNotExists(_ recipes: [RecipeModel]) throws
    func updateFavoriteRecipe(for id: String, isFavorite: Bool) async throws -> Bool
    func fetchMealPlan(for date: String) async throws -> MealPlanModel?
    func inserMealPlan(_ mealPlan: MealPlanModel) throws
}

final class LocalDataSource: LocalDataSourceProtocol {
    static let shared = LocalDataSource()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RecipeBuddy")
        let description = container.persistentStoreDescriptions.first
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func updateFavoriteRecipe(for id: String, isFavorite: Bool) async throws -> Bool {
        try context.performAndWait {
            let req: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
            req.predicate = NSPredicate(format: "id == %@", id)
            req.fetchLimit = 1
            
            if let recipe = try context.fetch(req).first {
                recipe.isFavorite = isFavorite
                try context.save()
                return true
            } else {
                return false
            }
        }
    }
    
    func fetchRecipe(for id: String) async throws -> RecipeModel? {
        try await context.perform {
            let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id)
            request.fetchLimit = 1
            let results = try self.context.fetch(request)
            
            return results.first.map { entity in
                RecipeModel(
                    id: entity.id ?? "",
                    title: entity.title ?? "",
                    tags: entity.tags?.components(separatedBy: ",") ?? [],
                    minutes: Int(entity.minutes),
                    image: entity.image ?? "",
                    ingredients: (entity.ingredients as? Set<IngredientEntity> ?? []).map {
                        IngredientModel(name: $0.name ?? "", quantity: $0.quantity ?? "")
                    }.sorted(by: { $0.name > $1.name }),
                    steps: entity.steps?.components(separatedBy: ",") ?? [],
                    isFavorite: entity.isFavorite
                )
            }
        }
    }
    
    func fetchRecipes(
        sortByTimeAscending: Bool = true,
        filterTags: [String] = [],
        isFavorite: Bool? = nil
    ) async throws -> [RecipeModel] {
        try await context.perform {
            let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
    
            let sortDescriptor = NSSortDescriptor(key: "minutes", ascending: sortByTimeAscending)
            request.sortDescriptors = [sortDescriptor]
            
            var predicates: [NSPredicate] = []
    
            if !filterTags.isEmpty {
                let tagPredicates = filterTags.map { tag in
                    NSPredicate(format: "tags CONTAINS[c] %@", tag)
                }
                let tagsCompound = NSCompoundPredicate(orPredicateWithSubpredicates: tagPredicates)
                predicates.append(tagsCompound)
            }
        
            if let favorite = isFavorite {
                predicates.append(NSPredicate(format: "isFavorite == %@", NSNumber(value: favorite)))
            }
        
            if !predicates.isEmpty {
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            }
            
            let results = try self.context.fetch(request)
            
            return results.map { entity in
                RecipeModel(
                    id: entity.id ?? "",
                    title: entity.title ?? "",
                    tags: entity.tags?.components(separatedBy: ",") ?? [],
                    minutes: Int(entity.minutes),
                    image: entity.image ?? "",
                    ingredients: (entity.ingredients as? Set<IngredientEntity> ?? []).map {
                        IngredientModel(name: $0.name ?? "", quantity: $0.quantity ?? "")
                    }.sorted(by: { $0.name > $1.name }),
                    steps: entity.steps?.components(separatedBy: ",") ?? [],
                    isFavorite: entity.isFavorite
                )
            }
        }
    }

    func insertIfNotExists(_ recipes: [RecipeModel]) throws {
        try context.performAndWait {
            let req: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
            let existing = try context.fetch(req)
            let existingIDs: Set<String> = Set(existing.compactMap { $0.id })

            for r in recipes {
                guard !existingIDs.contains(r.id) else {
                    continue
                }

                let entity = RecipeEntity(context: context)
                entity.id = r.id
                entity.title = r.title
                entity.minutes = Int64(r.minutes)
                entity.image = r.image
                entity.tags = r.tags.joined(separator: ",")
                entity.steps = r.steps.joined(separator: ",")
                entity.isFavorite = r.isFavorite ?? false

                // Add ingredients
                let ingredientsSet: Set<IngredientEntity> = Set(r.ingredients.map { ing in
                    let e = IngredientEntity(context: context)
                    e.name = ing.name
                    e.quantity = ing.quantity
                    e.recipe = entity
                    return e
                })
                entity.ingredients = ingredientsSet as NSSet
            }

            try context.save()
        }
    }
    
    func inserMealPlan(_ mealPlan: MealPlanModel) throws {
        try context.performAndWait {
            let request: NSFetchRequest<MealPlanEntity> = MealPlanEntity.fetchRequest()
            request.predicate = NSPredicate(format: "date == %@", mealPlan.date)

            let existing = try context.fetch(request)
            let entity: MealPlanEntity
            if let first = existing.first {
                entity = first
            } else {
                entity = MealPlanEntity(context: context)
            }

            entity.idRecipes = mealPlan.idRecipes
            entity.date = mealPlan.date
        
            try context.save()
        }
    }
    
    func fetchMealPlan(for date: String) async throws -> MealPlanModel? {
        try await context.perform {
            let request: NSFetchRequest<MealPlanEntity> = MealPlanEntity.fetchRequest()
            request.predicate = NSPredicate(format: "date == %@", date)
            request.fetchLimit = 1
            let results = try self.context.fetch(request)
            
            return results.first.map { entity in
                MealPlanModel(date: entity.date ?? "", idRecipes: entity.idRecipes ?? "")
            }
        }
    }
}
