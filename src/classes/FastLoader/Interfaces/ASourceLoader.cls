block-level on error undo, throw.
using classes.FastLoader.Interfaces.ASourceLoader from propath.

class classes.FastLoader.Interfaces.ASourceLoader abstract:
    define public property resultTempTable as handle get. private set.
    define public property fieldCounter as integer initial 0 get. private set.
    
    constructor ASourceLoader():
        addCharReplacement(' ', '-').
        addCharReplacement('.', '-').
        addCharReplacement('*', '').
        addCharReplacement('/', '').
        addCharReplacement('\', '').
        addCharReplacement(':', '').
        addCharReplacement(',', '-').
        addCharReplacement('(', '').
        addCharReplacement(')', '').
        addCharReplacement('[', '').
        addCharReplacement(']', '').
        addCharReplacement('~{', '').
        addCharReplacement('~}', '').
        addCharReplacement('~~', '').
        addCharReplacement('<', '').
        addCharReplacement('>', '').
        addCharReplacement('|', '').
        addCharReplacement('+', '').
        addCharReplacement('ª', '').
        addCharReplacement('º', '').
        addCharReplacement('=', '').
        addCharReplacement('%', '').
        addCharReplacement('$', '').
        addCharReplacement('#', '').
        addCharReplacement('@', '').
        addCharReplacement('!', '').
        addCharReplacement('~'', '').
        addCharReplacement('"', '').
        addCharReplacement('&', '').
        addCharReplacement('?', '').
        addCharReplacement('á', 'a').
        addCharReplacement('à', 'a').
        addCharReplacement('ã', 'a').
        addCharReplacement('â', 'a').
        addCharReplacement('ä', 'a').
        addCharReplacement('ó', 'o').
        addCharReplacement('ò', 'o').
        addCharReplacement('õ', 'o').
        addCharReplacement('ö', 'o').
        addCharReplacement('ô', 'o').
        addCharReplacement('é', 'e').
        addCharReplacement('è', 'e').
        addCharReplacement('ë', 'e').
        addCharReplacement('ê', 'e').
        addCharReplacement('í', 'i').
        addCharReplacement('ì', 'i').
        addCharReplacement('î', 'i').
        addCharReplacement('ï', 'i').
        addCharReplacement('ú', 'u').
        addCharReplacement('ù', 'u').
        addCharReplacement('û', 'u').
        addCharReplacement('ü', 'u').
        addCharReplacement('ç', 'c').
    end constructor.
    
    define private temp-table charReplacement
        field charSource as character
        field charTarget as character
        index idxSource as primary unique charSource.
    
    define private temp-table tableDefinition
        field fieldName as character
        field dataType as character
        field fieldLabel as character
        field columnLabel as character
        index idxName as primary unique fieldName.
        
    
    method public void loadHeaders(input-output pSource as Progress.Lang.Object):
        return error new classes.FastLoader.Errors.FastLoaderMethodNotImplemented(this-object, 'object', 'loadHeaders').
    end method.
    
    method public void loadData(input-output pSource as Progress.Lang.Object):
        return error new classes.FastLoader.Errors.FastLoaderMethodNotImplemented(this-object, 'object', 'loadData').
    end method.
    
    method public void loadHeaders(input-output pSource as character):
        return error new classes.FastLoader.Errors.FastLoaderMethodNotImplemented(this-object, 'character', 'loadHeaders').
    end method.
    
    method public void loadData(input-output pSource as character):
        return error new classes.FastLoader.Errors.FastLoaderMethodNotImplemented(this-object, 'character', 'loadData').
    end method.
    
    method public void loadHeaders(input-output pSource as handle):
        return error new classes.FastLoader.Errors.FastLoaderMethodNotImplemented(this-object, 'handle', 'loadHeaders').
    end method.
    
    method public void loadData(input-output pSource as handle):
        return error new classes.FastLoader.Errors.FastLoaderMethodNotImplemented(this-object, 'handle', 'loadData').
    end method.
    
    method public handle loadToTempTable(pSource as Progress.Lang.Object):
        create temp-table resultTempTable.
        loadHeaders(pSource).
        prepareTempTable().
        loadData(pSource).
        return resultTempTable.
    end method.
    
    method public handle loadToTempTable(pSource as handle):
        create temp-table resultTempTable.
        loadHeaders(pSource).
        prepareTempTable().
        loadData(pSource).
        return resultTempTable.
    end method.
    
    method public handle loadToTempTable(pSource as character):
        create temp-table resultTempTable.
        loadHeaders(pSource).
        prepareTempTable().
        loadData(pSource).
        return resultTempTable.
    end method.
    
    method public ASourceLoader addHeader(
        pFieldName as character,
        pDataType as character
    ):
        return addHeader(pFieldName, pDataType, pFieldName).
    end method.
    
    method public ASourceLoader addHeader(
        pFieldName as character,
        pDataType as character,
        pLabel as character
    ):
        return addHeader(pFieldName, pDataType, pLabel, pLabel).
    end method.
    
    method public ASourceLoader addHeader(
        pFieldName as character,
        pDataType as character,
        pLabel as character,
        pColumnLabel as character
    ):
        create tableDefinition.
        assign
            fieldCounter = fieldCounter + 1
            tableDefinition.fieldName = normalizeFieldName(pFieldName)
            tableDefinition.dataType = pDataType
            tableDefinition.fieldLabel = pLabel
            tableDefinition.columnLabel = pColumnLabel.
        return this-object.
    end method.
    
    method public ASourceLoader addCharReplacement(pSource as character, pTarget as character):
        find first charReplacement
            where
                charReplacement.charSource = pSource
                and charReplacement.charTarget = pTarget
            no-error.
            
        if not available charReplacement then do:
            create charReplacement.
        end.
        
        assign 
            charReplacement.charSource = pSource
            charReplacement.charTarget = pTarget.
            
        return this-object.
    end method.
    
    method public character getFieldDataType(pFieldName as character):
        assign pFieldName = normalizeFieldName(pFieldName).
        
        find first tableDefinition no-lock
            where tableDefinition.fieldName = pFieldName
            no-error.
        
        if not available tableDefinition then do:
            return error new classes.FastLoader.Errors.FastLoaderFieldNotFound(pFieldName).
        end.
        
        return tableDefinition.dataType.
    end method.
    
    method public character extent getFieldNames():
        define variable idx as integer no-undo.
        define variable fieldNames as character extent no-undo.
        
        assign extent(fieldNames) = fieldCounter.
        
        for each tableDefinition no-lock:
            assign 
                fieldNames[idx] = tableDefinition.fieldName
                idx = idx + 1.
        end.
        
        return fieldNames.
    end method.
    
    method private void prepareTempTable():
        for each tableDefinition no-lock:
            resultTempTable:add-new-field(
                tableDefinition.fieldName,
                tableDefinition.dataType,
                ?,
                ?,
                ?,
                tableDefinition.fieldLabel,
                tableDefinition.columnLabel
            ).    
        end.
        resultTempTable:temp-table-prepare('fl-tt-result').
    end method.
    
    method private character normalizeFieldName(pName as character):
        for each charReplacement no-lock:
            assign 
                pName = replace(pName, charReplacement.charSource, charReplacement.charTarget).
        end.
        return lower(pName).
    end method.
end class.
