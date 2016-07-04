//
//  StageModel.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation
import UIKit
import SQLite


// Handles Stages information
class StageModel {

	// hold all relevant information about a stage
	internal struct stageData {
		var idStage: Int
		var name: String
	}

    // all stage records will be stored here
	private var stages: [StageModel.stageData] = []


	// reads stage informations from the database
	// should be called once for initialization purposes
	internal func readStagesFromDB() {
		// SELECT * FROM stages
		do {
			let db = app.getDBController().getDatabaseConnection()

			let stagesTable = Table("stages")
			let idStage = Expression<Int?>("id_stage")
			let name    = Expression<String?>("name")

			for stage in try db!.prepare(stagesTable) {
				self.stages.append(StageModel.stageData(
					idStage: stage[idStage]!,
					name: stage[name]!
				))
			}
		} catch {
			print("Error happened while retrieving stages from the database")
		}		
	}

    // returns all matching items related to a given stage
    internal func getMatchingItemsForStage(loadForIdStage: Int) -> [MatchingItemModel.matchingItemData] {
		var itemList: [MatchingItemModel.matchingItemData] = []

		/*
		SELECT * FROM stages_play_items LEFT OUTER JOIN play_items 
			ON play_items.id_play_item = stages_play_items.id_item
		WHERE stages_play_items.id_stage = '?'
		*/
		do {
			let db = app.getDBController().getDatabaseConnection()

			let playItemsTable = Table("play_items")
			let idPlayItem = Expression<Int?>("id_play_item")
			let alias      = Expression<String?>("alias")
			let width      = Expression<Double?>("width")
			let height     = Expression<Double?>("height")

			let stagesPlayItemsTable = Table("stages_play_items")
			let idStage = Expression<Int?>("id_stage")
			let idItem  = Expression<Int?>("id_item")
			let winX    = Expression<Double?>("win_x")
			let winY    = Expression<Double?>("win_y")

			let joinedStagesPlayItems = stagesPlayItemsTable
				.join(.LeftOuter, playItemsTable, on: idPlayItem == stagesPlayItemsTable[idItem])
				.filter(idStage == loadForIdStage)

			for item in try db!.prepare(joinedStagesPlayItems) {
				let newItem = MatchingItemModel.matchingItemData(
					idPlayItem: item[idItem]!,
					idStage: item[idStage]!,
					alias: item[playItemsTable[alias]]!,
					nodeName: Defines.SKNODE_NAME.matchingItem,
					width: CGFloat(item[width]!),
					height: CGFloat(item[height]!),
					winningPosition: CGPointMake(CGFloat(item[winX]!), CGFloat(item[winY]!)),
					startPosition: CGPointMake(0, 0),
					zPosition: Defines.Z_INDEX_MAP.items,
					playable: true,
					userData: nil
				)

				itemList.append(newItem)
			}
		} catch {
			print("Error happened while retrieving play items from the database")
		}

		return itemList
    }

	// returns all miracle items related to a given stage
	internal func getMiracleItemsForStage(loadForIdStage: Int) -> [MiracleItemModel.miracleItemData] {
		var itemList: [MiracleItemModel.miracleItemData] = []

		/*
		SELECT * FROM stages_miracle_items
			LEFT OUTER JOIN miracle_items ON miracle_items.id_miracle_item = stages_miracle_items.id_item
		WHERE stages_miracle_items.id_stage = '?'
		*/
		do {
			let db = app.getDBController().getDatabaseConnection()
			
			let miracleItemsTable = Table("miracle_items")
			let idMiracleItem     = Expression<Int?>("id_miracle_item")
			let idMiracleItemType = Expression<Int?>("id_miracle_item_type")
			let alias             = Expression<String?>("alias")
			let width             = Expression<Double?>("width")
			let height            = Expression<Double?>("height")

			let stagesMiracleItemsTable = Table("stages_miracle_items")
			let idStage = Expression<Int?>("id_stage")
			let idItem  = Expression<Int?>("id_item")
			let startX  = Expression<Double?>("start_x")
			let startY  = Expression<Double?>("start_y")

			let joinedStagesMiracleItems = stagesMiracleItemsTable
				.join(.LeftOuter, miracleItemsTable, on: idMiracleItem == stagesMiracleItemsTable[idItem])
				.filter(idStage == loadForIdStage)

			for item in try db!.prepare(joinedStagesMiracleItems) {
				let newItem = MiracleItemModel.miracleItemData(
					idMiracleItem: item[idItem]!,
					type: Defines.MIRACLE_ITEM_TYPE[item[idMiracleItemType]!],
					alias: item[alias]!,
					nodeName: Defines.SKNODE_NAME.miracleItem,
					width: CGFloat(item[width]!),
					height: CGFloat(item[height]!),
					startPosition: CGPointMake(CGFloat(item[startX]!), CGFloat(item[startY]!)),
					zPosition: Defines.Z_INDEX_MAP.miracleItems,
					userData: nil
				)

				itemList.append(newItem)
			}
		} catch {
			print("Error happened while retrieving miracle items from the database")
		}
		
		return itemList
	}

	// tells the short name of a stage by stage-index
	internal func getStageShortName(atIndex: Int) -> String {
		for stage in self.stages {
			if stage.idStage == atIndex {
				return stage.name
			}
		}

		return ""
	}

	// returns the currently used number of stages
	internal func getNumberOfStages() -> Int {
		return self.stages.count
	}

}
