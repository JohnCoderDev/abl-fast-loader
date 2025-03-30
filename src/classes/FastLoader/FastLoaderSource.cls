block-level on error undo, throw.
using classes.FastLoader.Interfaces.* from propath.

class classes.FastLoader.FastLoaderSource:
    define private static temp-table flSource
        field sourceName as character
        field className as character
        index idxName as primary unique sourceName.
    
    
    constructor static FastLoaderSource():
        registerSourceType('JsonObject', 'classes.FastLoader.Sources.FLSJsonObject').
        registerSourceType('JsonArray', 'classes.FastLoader.Sources.FLSJsonArray').
        registerSourceType('Excel', 'classes.FastLoader.Sources.FLSExcel').
    end constructor.
    
    method public static handle loadToTempTable(
        pSource as Progress.Lang.Object,
        pSourceName as character
    ):
        define variable tempTableResult as handle no-undo.
        define variable sourceLoader as ASourceLoader no-undo.
    
        assign 
            sourceLoader = getSourceLoader(pSourceName)
            tempTableResult = sourceLoader:loadToTempTable(pSource).
        
        delete object sourceLoader.
        return tempTableResult.
    end method.
    
    method public static handle loadToTempTable(
        pSource as handle,
        pSourceName as character
    ):
        define variable tempTableResult as handle no-undo.
        define variable sourceLoader as ASourceLoader no-undo.
    
        assign 
            sourceLoader = getSourceLoader(pSourceName)
            tempTableResult = sourceLoader:loadToTempTable(pSource).
        
        delete object sourceLoader.
        return tempTableResult.
    end method.
    
    method public static handle loadToTempTable(
        pSource as character,
        pSourceName as character
    ):
        define variable tempTableResult as handle no-undo.
        define variable sourceLoader as ASourceLoader no-undo.
    
        assign 
            sourceLoader = getSourceLoader(pSourceName)
            tempTableResult = sourceLoader:loadToTempTable(pSource).
        
        delete object sourceLoader.
        return tempTableResult.
    end method.
    
    method public static ASourceLoader getSourceLoader(pName as character):
        find first flSource no-lock
            where flSource.sourceName = pName
            no-error.
        
        if not available flSource then do:
            return error new classes.FastLoader.Errors.FastLoaderSourceNotFound(pName).
        end.
        
        return cast(Progress.Lang.Class:getClass(flSource.className):new(), ASourceLoader).
    end method.
    
    method public static void showSourcesTypes():
        for each flSource no-lock:
            display flSource with scrollable.
        end.    
    end method.
    
    method public static void removeSourceType(pName as character):
        find first flSource
            where flSource.sourceName = pName
            no-error.
        
        if available flSource then do:
            delete flSource.
        end.    
    end method.
    
    method public static void registerSourceType(pName as character, pClassName as character):
        find first flSource
            where flSource.sourceName = pName
            no-error.
        
        if not available flSource then do:
            create flSource.
        end.
        
        assign
            flSource.sourceName = pName
            flSource.className = pClassName.    
    end method.
end class.
