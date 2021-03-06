

package com.flexcapacitor.effects.database {
	
	import com.flexcapacitor.data.database.SQLColumnData;
	import com.flexcapacitor.effects.database.supportClasses.InsertRecordInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.data.SQLConnection;
	import flash.errors.SQLError;
	
	import mx.effects.IEffect;
	
	/**
	 * Event dispatched when file is successfully open
	 * */
	[Event(name="success", type="flash.events.Event")]
	
	/**
	 * Event dispatched when file opening is unsuccessful
	 * */
	[Event(name="fault", type="flash.events.Event")]
	
	/**
	 * Inserts a record into the database. AIR Only. 
	 * Set the traceSQLError property to true to check for errors (see below).   
	 * 
<pre>
 
	&lt;database:SQLConnection id="connection"/>
 
	&lt;db:GetDatabase id="database" fileName="myData.db" connection="{connection}">
		&lt;db:notCreatedEffect>
			&lt;db:CreateTable connection="{connection}" tableName="notes" >
				&lt;db:fields>
					&lt;database:SQLColumn name="id" 
										 autoIncrement="true" 
										 dataType="INTEGER" 
										 primaryKey="true"/>
					&lt;database:SQLColumn name="title"  
										 dataType="TEXT" />
					&lt;database:SQLColumn name="content"  
										 dataType="TEXT" />
					&lt;database:SQLColumn name="creationDate"  
										dataType="TEXT" />
					&lt;database:SQLColumn name="modifyDate"  
										dataType="TEXT" />
				&lt;/db:fields>
			&lt;/db:CreateTable>
		&lt;/db:notCreatedEffect>
	&lt;/db:GetDatabase>

	
	&lt;db:InsertRecord tableName="notes" connection="{connection}" 
						fault="trace(sqlError.message)" traceErrorMessage="true">
		&lt;db:fields>
			&lt;database:SQLColumnData name="title" value="USA" />
			&lt;database:SQLColumnData name="content" value="Minneapolis" />
		&lt;/db:fields>
	&lt;/db:InsertRecord>
	
	
	&lt;db:SelectRecords id="select" 
					  tableName="notes" 
					  connection="{connection}"
					  itemClass="{Note}"
					  >
	&lt;/db:SelectRecords>
</pre>
	 * 
 	 * <b>Notes</b>:<br/>
	 * <b>Error #3122: Attempt to write a readonly database.</b><br/>
	 * Set the fileMode to create. <br/><br/>
	 * 
	 * <b>Error #3114: An invalid open mode was specified.</b><br/>
	 * Set a different fileMode. The database may need to be copied out to the 
	 * application directory.<br/><br/>
	 * 
	 * <b>Record is not inserted and no error.</b><br/>
	 * You may be checking the incorrect database. Since the database is copied
	 * out of the application directory then you need to check the database 
	 * in the application storage directory not the application directory.<br/><br/>
	 * */
	public class InsertRecord extends ActionEffect {
		
		public static const SUCCESS:String = "success";
		public static const FAULT:String = "fault";
		
		/**
		 *  Constructor.
		 * */
		public function InsertRecord(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target) {
				target = new Object();
			}
			
			super(target);
			
			instanceClass = InsertRecordInstance;
			
		}
		
		
		/**
		 * The SQL Connection
		 * @see GetDatabase
		 * */
		[Bindable]
		public var connection:SQLConnection;
		
		/**
		 * Effect played if file open is successful.  
		 * */
		public var successEffect:IEffect;
		
		/**
		 * Effect played if file open is unsuccessful.  
		 * */
		public var faultEffect:IEffect;
		
		/**
		 * Name of table
		 * */
		public var tableName:String;
		
		/**
		 * Array of columns and values to insert into the new row
		 * */
		public var fields:Vector.<SQLColumnData>;
		
		/**
		 * ID of the last row inserted. 
		 * */
		[Bindable]
		public var lastInsertRowID:uint;
		
		/**
		 * Total changes. 
		 * */
		[Bindable]
		public var totalChanges:uint;
		
		/**
		 * Reference to the error that is generated when an SQL error occurs
		 * */
		public var sqlError:SQLError;
		
		/**
		 * Indicates if SQL errors should be shown in the console
		 * */
		public var traceErrorMessage:Boolean;
		
	}
}