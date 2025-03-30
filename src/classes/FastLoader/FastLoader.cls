block-level on error undo, throw.
using classes.FastLoader.* from propath.

class classes.FastLoader.FastLoader:
    define private property sourceTable as handle get. set.
    define private property targetTable as FastLoaderTarget get. set.
    
    method public FastLoader setSource(pSource as Progress.Lang.Object, pSourceType as character):
        assign sourceTable = FastLoaderSource:loadToTempTable(pSource, pSourceType).
        return this-object.
    end method.
    
    method public FastLoader setSource(pSource as character, pSourceType as character):
        assign sourceTable = FastLoaderSource:loadToTempTable(pSource, pSourceType).
        return this-object.
    end method.
    
    method public FastLoader setSource(pSource as handle, pSourceType as character):
        assign sourceTable = FastLoaderSource:loadToTempTable(pSource, pSourceType).
        return this-object.
    end method.
    
    method public FastLoaderTarget initTarget(pTableTarget as character):
        return new FastLoaderTarget(this-object, pTableTarget).
    end method.
    
    method public FastLoader setTarget(pTarget as FastLoaderTarget):
        assign targetTable = pTarget.
        return this-object.
    end method.
    
    method public handle getSourceTable():
        return sourceTable.
    end method.
    
    method public void loadToTable():
        if not valid-handle(sourceTable) then do:
            return error new classes.FastLoader.Errors.FastLoaderSourceNotAvailable().
        end.
        if targetTable = ? then do:
            return error new classes.FastLoader.Errors.FastLoaderTargetNotAvailable().
        end.
        
        targetTable:loadToTargetTable(sourceTable).
    end method.
end class.
