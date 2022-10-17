CREATE PROCEDURE update_deliverable_status
    @rowId                  int,
    @newStatus              varchar(20)
AS
BEGIN
    DECLARE @lastRow        int;
    DECLARE @currentRow     int

    SELECT @lastRow = max(id) from deliverableInstance;
    SELECT @currentRow = id from deliverableInstance where id = @rowId AND deliveryDate < GETDATE();
    
	IF @currentRow > 0
        BEGIN
            UPDATE deliverableInstance SET [status] = @newStatus where id = @currentRow;
            INSERT INTO scheduledProcedureLog (tableName, columnName, rowId, newValue)
            VALUES('deliverableInstance', 'status', @currentRow, @newStatus);
        END;
    
	IF @rowId <= @lastRow
        BEGIN
            SET @rowId = @rowId + 1;
            exec update_deliverable_status @rowId = @rowId, @newStatus = @newStatus
        END;
END;

exec update_deliverable_status @rowId = 1, @newStatus = 'ATRASADO';