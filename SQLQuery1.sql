CREATE PROCEDURE update_status
    @newStatus              varchar(20)
AS
BEGIN
    DECLARE @currentId int;
    DECLARE late_cursor CURSOR
        FOR SELECT id from deliverableInstance where deliveryDate < GETDATE() AND status <> @newStatus;
    OPEN late_cursor  
    FETCH NEXT FROM late_cursor INTO @currentId
    WHILE @@FETCH_STATUS = 0
        BEGIN
            UPDATE deliverableInstance SET [status] = @newStatus where id = @currentId;
            INSERT INTO scheduledProcedureLog (tableName, columnName, rowId, newValue, createdAt)
            VALUES('deliverableInstance', 'status', @currentId, @newStatus, GETDATE());
            FETCH NEXT FROM late_cursor INTO @currentId
        END
        CLOSE late_cursor
        DEALLOCATE late_cursor
END
GO

EXEC update_status
