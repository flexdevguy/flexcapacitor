

package com.flexcapacitor.effects.database.supportClasses {
	import com.flexcapacitor.data.database.SQLColumnData;
	import com.flexcapacitor.effects.database.InsertRecord;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.events.Event;
	
	
	/**
	 * @copy InsertRecord
	 * */  
	public class InsertRecordInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function InsertRecordInstance(target:Object) {
			super(target);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 * */
		override public function play():void {
			// Dispatch an effectStart event
			super.play();
			
			var action:InsertRecord = InsertRecord(effect);
			var connection:SQLConnection = action.connection;
			var tableName:String = action.tableName;
			var fields:Vector.<SQLColumnData> = action.fields;
			var statement:SQLStatement;
			var request:String;
			var field:SQLColumnData;
			var fieldsLength:int;
			var successful:Boolean;
			var alias:String;
			var executeError:SQLError;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (!connection) {
					dispatchErrorEvent("A connection is required");
				}
				if (!tableName) {
					dispatchErrorEvent("A table name must be specified");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			statement = new SQLStatement();
			statement.sqlConnection = connection;
			
			request = "INSERT INTO ";
			
			request += tableName + " (";
			
			fieldsLength = fields.length;
			
			// get column names
			for (var i:int;i<fieldsLength;i++) {
				field = fields[i];
				if (i>0) request += ",";
				request += field.name;
			}
			
			request += ") VALUES (";
			
			// set column alias and value
			for (i=0;i<fieldsLength;i++) {
				field = fields[i];
				if (i>0) request += ",";
				alias = ":" + field.name;
				request += alias;
				statement.parameters[alias] = field.value;
			}
			
			request += ")";
			
			// sql statement
			statement.text = request;
			
			try {
				statement.execute();
				successful = true;
			} catch(error:SQLError) {
				executeError = error;
				successful = false;
			}
			
			// success
			if (successful) {
				
				action.lastInsertRowID = connection.lastInsertRowID;
				
				if (hasEventListener(InsertRecord.SUCCESS)) {
					dispatchEvent(new Event(InsertRecord.SUCCESS));
				}
				
				if (action.successEffect) {
					playEffect(action.successEffect);
				}
			}
			else {
				action.sqlError = executeError;
				
				// fault
				if (hasEventListener(InsertRecord.FAULT)) {
					dispatchEvent(new Event(InsertRecord.FAULT));
				}
				
				if (action.faultEffect) {
					playEffect(action.faultEffect);
				}
				
				if (action.traceSQLError) {
					trace(executeError.details);
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			finish();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		
	}
}