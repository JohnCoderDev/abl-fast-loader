block-level on error undo, throw.
using classes.FastLoader.* from propath.

class classes.FastLoader.FastLoaderTarget:
    define private property fastLoaderParent as FastLoader get. set.
    define private property tableTarget as character get. set.
    define private property updateOnly as logical initial false get. set.
    define private property createOnly as logical initial false get. set.
    define private property matchByLabel as logical initial false get. set.
    define private property currentTargetExtent as integer get. set.
    define private property currentTargetType as character get. set.
    
    define private temp-table tableKey
        field fieldName as character 
        index idxName as primary unique fieldName.
    
    define private temp-table bufferFields
        field fieldName as character
        field fieldLabel as character
        field columnLabel as character
        field fieldExtent as integer
        field origin as character
        field datatype as character
        index idxName as primary unique fieldName origin.
    
    define private temp-table fieldsToCopy
        field sourceFieldName as character
        field targetFieldName as character
        field targetType as character
        field minimalExtent as integer.
        
    constructor FastLoaderTarget(pParent as FastLoader, pTableTarget as character):
        assign 
            fastLoaderParent = pParent
            tableTarget = pTableTarget.
    end constructor.
    
    method public FastLoaderTarget addKeyField(pFieldName as character):
        if not can-find(
            first tableKey
            where tableKey.fieldName = pFieldName
        ) then do:
            create tableKey.
            assign tableKey.fieldName = pFieldName.
        end.
        return this-object.
    end method.
    
    method public FastLoaderTarget setUpdateOnly():
        assign
            createOnly = false
            updateOnly = true.
        return this-object.    
    end method.
    
    method public FastLoaderTarget setCreateOnly():
        assign
            createOnly = true
            updateOnly = false.
        return this-object.    
    end method.
    
    method public FastLoaderTarget setUpdateOrCreate():
        assign
            createOnly = false
            updateOnly = false.
        return this-object.    
    end method.
    
    method public FastLoaderTarget setMatchByLabel():
        assign matchByLabel = true.
        return this-object.
    end method.
    
    method public void loadToTargetTable(pSource as handle):
        define variable keyPhrase as character no-undo.
        define variable targetBuffer as handle no-undo.
        define variable sourceBuffer as handle no-undo.
        define variable querySource as handle no-undo.
        
        create buffer targetBuffer for table tableTarget.
        assign sourceBuffer = pSource:default-buffer-handle.
        
        create query querySource.
        querySource:set-buffers(sourceBuffer).
        querySource:query-prepare('for each ' + pSource:name).
        querySource:query-open.
        querySource:get-first.
        
        do while not querySource:query-off-end:            
            assign keyPhrase = getKeyPhrase(sourceBuffer).
            
            do transaction on error undo, next:
                targetBuffer:find-first(keyPhrase, exclusive-lock) no-error.
                if targetBuffer:available then do:
                    if updateOnly or not createOnly then do:
                        copyBuffer(sourceBuffer, targetBuffer).
                    end.
                end.
                else do:
                    if createOnly or not updateOnly then do:
                        targetBuffer:buffer-create.
                        copyBuffer(sourceBuffer, targetBuffer).
                    end.
                end.
            end.
            targetBuffer:buffer-release no-error.
            querySource:get-next.
        end.
        
        querySource:query-close.
        delete object querySource.
        delete object targetBuffer.
    end method.
    
    method private void copyBuffer(pSourceBuffer as handle, pTargetBuffer as handle):
        define variable sourceField as handle no-undo.
        define variable targetField as handle no-undo.
        define variable idx as integer no-undo.
         
        loadFields(pSourceBuffer, pTargetBuffer).
        
        for each fieldsToCopy:
            assign
                sourceField = pSourceBuffer:buffer-field(fieldsToCopy.sourceFieldName)
                targetField = pTargetBuffer:buffer-field(fieldsToCopy.targetFieldName).
            
            if sourceField:extent = 0 and targetField:extent = 0 then do:
                case fieldsToCopy.targetType:
                    when 'character' then targetField:buffer-value = string(sourceField:buffer-value).
                    when 'integer' then targetField:buffer-value = int(sourceField:buffer-value).
                    when 'int64' then targetField:buffer-value = int64(sourceField:buffer-value).
                    when 'decimal' then targetField:buffer-value = dec(sourceField:buffer-value).
                    when 'date' then targetField:buffer-value = date(sourceField:buffer-value).
                    when 'datetime' then targetField:buffer-value = datetime(sourceField:buffer-value).
                    when 'datetime-tz' then targetField:buffer-value = datetime-tz(sourceField:buffer-value).
                    when 'logical' then targetField:buffer-value = logical(sourceField:buffer-value).
                end case.
            end.
            else if targetField:extent = 0 then do:
                case fieldsToCopy.targetType:
                    when 'character' then targetField:buffer-value = string(sourceField:buffer-value(1)).
                    when 'integer' then targetField:buffer-value = int(sourceField:buffer-value(1)).
                    when 'int64' then targetField:buffer-value = int64(sourceField:buffer-value(1)).
                    when 'decimal' then targetField:buffer-value = dec(sourceField:buffer-value(1)).
                    when 'date' then targetField:buffer-value = date(sourceField:buffer-value(1)).
                    when 'datetime' then targetField:buffer-value = datetime(sourceField:buffer-value(1)).
                    when 'datetime-tz' then targetField:buffer-value = datetime-tz(sourceField:buffer-value(1)).
                    when 'logical' then targetField:buffer-value = logical(sourceField:buffer-value(1)).
                end case.
            end.
            else if sourceField:extent = 0 then do:
                case fieldsToCopy.targetType:
                    when 'character' then targetField:buffer-value(1) = string(sourceField:buffer-value).
                    when 'integer' then targetField:buffer-value(1) = int(sourceField:buffer-value).
                    when 'int64' then targetField:buffer-value(1) = int64(sourceField:buffer-value).
                    when 'decimal' then targetField:buffer-value(1) = dec(sourceField:buffer-value).
                    when 'date' then targetField:buffer-value(1) = date(sourceField:buffer-value).
                    when 'datetime' then targetField:buffer-value(1) = datetime(sourceField:buffer-value).
                    when 'datetime-tz' then targetField:buffer-value(1) = datetime-tz(sourceField:buffer-value).
                    when 'logical' then targetField:buffer-value(1) = logical(sourceField:buffer-value).
                end case.
            end.
            else do:
                do idx = 1 to fieldsToCopy.minimalExtent:
                    case fieldsToCopy.targetType:
                        when 'character' then targetField:buffer-value(idx) = string(sourceField:buffer-value(idx)).
                        when 'integer' then targetField:buffer-value(idx) = int(sourceField:buffer-value(idx)).
                        when 'int64' then targetField:buffer-value(idx) = int64(sourceField:buffer-value(idx)).
                        when 'decimal' then targetField:buffer-value(idx) = dec(sourceField:buffer-value(idx)).
                        when 'date' then targetField:buffer-value(idx) = date(sourceField:buffer-value(idx)).
                        when 'datetime' then targetField:buffer-value(idx) = datetime(sourceField:buffer-value(idx)).
                        when 'datetime-tz' then targetField:buffer-value(idx) = datetime-tz(sourceField:buffer-value(idx)).
                        when 'logical' then targetField:buffer-value(idx) = logical(sourceField:buffer-value(idx)).
                    end case.
                end.
            end.
        end.
    end method.
    
    method private void loadFields(pSourceBuffer as handle, pTargetBuffer as handle):
        empty temp-table bufferFields.
        empty temp-table fieldsToCopy.
        
        define variable bufferField as handle no-undo.
        define variable idx as integer no-undo.
        
        do idx = 1 to pSourceBuffer:num-fields:
            create bufferFields.
            assign
                bufferField = pSourceBuffer:buffer-field(idx)
                bufferFields.fieldName = bufferField:name
                bufferFields.fieldLabel = bufferField:label
                bufferFields.columnLabel = bufferField:column-label
                bufferFields.fieldExtent = bufferField:extent
                bufferFields.datatype = bufferField:data-type
                bufferFields.origin = 'source'.
        end.
        
        do idx = 1 to pTargetBuffer:num-fields:
            create bufferFields.
            assign
                bufferField = pTargetBuffer:buffer-field(idx)
                bufferFields.fieldName = bufferField:name
                bufferFields.fieldLabel = bufferField:label
                bufferFields.columnLabel = bufferField:column-label
                bufferFields.fieldExtent = bufferField:extent
                bufferFields.datatype = bufferField:data-type
                bufferFields.origin = 'target'.
        end.
        
        for each bufferFields no-lock where bufferFields.origin = 'source':
            if hasTargetField(bufferFields.fieldName) 
                or hasMatchLabel(bufferFields.fieldLabel)
                or hasMatchColumnLabel(bufferFields.columnLabel) then do:
                create fieldsToCopy.
                assign
                    fieldsToCopy.sourceFieldName = bufferFields.fieldName
                    fieldsToCopy.targetFieldName = getTargetFieldName(
                        bufferFields.fieldName, 
                        bufferFields.fieldLabel, 
                        bufferFields.columnLabel
                    )
                    fieldsToCopy.targetType = currentTargetType
                    fieldsToCopy.minimalExtent = minimum(bufferFields.fieldExtent, currentTargetExtent).
            end.
        end.
    end method.
    
    method private character getTargetFieldName(
        pSourceFieldName as character, 
        pFieldLabel as character, 
        pColumnLabel as character
    ):
        define variable targetFieldName as character no-undo.
        define variable targetBuffer as handle no-undo.
        create buffer targetBuffer for table temp-table bufferFields:handle.
        
        targetBuffer:find-first('where fieldName = ' + quoter(pSourceFieldName) + ' and origin = "target"') no-error.
        if not targetBuffer:available and matchByLabel then do:
            targetBuffer:find-first(
                'where (fieldLabel = ' + quoter(pFieldLabel) 
                + ' or columnLabel = ' + quoter(pColumnLabel)
                + ') and origin = "target"'
            ).    
        end.
        
        assign 
            targetFieldName = targetBuffer:buffer-field('fieldName'):buffer-value
            currentTargetExtent = targetBuffer:buffer-field('fieldExtent'):buffer-value
            currentTargetType = targetBuffer:buffer-field('datatype'):buffer-value.

        targetBuffer:buffer-release.
        delete object targetBuffer.
        return targetFieldName.
    end method.
    
    method private logical hasTargetField(pFieldName as character):
        return can-find(
            first bufferFields 
            where 
                bufferFields.fieldName = pFieldName
                and bufferFields.origin = 'target'
        ).
    end method.
    
    method private logical hasMatchLabel(pLabel as character):
        return can-find(
            first bufferFields
            where 
                bufferFields.fieldLabel = pLabel
                and bufferFields.origin = 'target'
        ) and matchByLabel.        
    end method.
    
    method private logical hasMatchColumnLabel(pLabel as character):
        return can-find(
            first bufferFields
            where 
                bufferFields.columnLabel = pLabel
                and bufferFields.origin = 'target'
        ) and matchByLabel.
    end method.
    
    method private character getKeyPhrase(pSourceBuffer as handle):
        define variable keyPhrase as character no-undo.
        define variable sourceValue as character no-undo.
        define variable bufferField as handle no-undo.
        
        if temp-table tableKey:has-records then do:
            assign keyPhrase = 'where '.
            
            for each tableKey:
                assign
                    bufferField = pSourcebuffer:buffer-field(tableKey.fieldName)
                    sourceValue = string(bufferField:buffer-value)
                    sourceValue = if bufferField:data-type = 'character' then quoter(sourceValue) else sourceValue
                    keyPhrase = keyPhrase + tableTarget + '.' + tableKey.fieldName + ' = ' + sourceValue +  ' AND '.
            end.
            
            assign keyPhrase = substring(keyPhrase, 1, length(keyPhrase) - 5).
        end.
        delete object bufferField no-error.
        return keyPhrase.
    end method.
    
    method public FastLoader finish():
        fastLoaderParent:setTarget(this-object).
        return fastLoaderParent.
    end method.
end class.
