block-level on error undo, throw.
using Progress.Json.ObjectModel.* from propath.
using classes.FastLoader.Shared.* from propath.

class classes.FastLoader.Sources.FLSJsonArray inherits classes.FastLoader.Interfaces.ASourceLoader:
    define private property json as JsonArray get. set.
    
    constructor FLSJsonArray():
        super().
    end constructor.
    
    method public override void loadHeaders(input-output pSource as Progress.Lang.Object):        
        define variable idx as integer no-undo.
        define variable fieldName as character no-undo.
        define variable fieldType as integer no-undo.
        define variable primitiveName as character no-undo.
        define variable firstJson as JsonObject no-undo.
        define variable jsonKeys as character extent no-undo.
        
        assign json = cast(pSource, JsonArray).
        
        if json:length = 0 then do:
            return.
        end.
        
        assign 
            firstJson = json:getJsonObject(1)
            jsonKeys = firstJson:getNames().
        
        do idx = 1 to extent(jsonKeys):
            assign
                fieldName = jsonKeys[idx]
                fieldType = firstJson:getType(fieldName)
                primitiveName = JsonPrimitive:getPrimitive(firstJson, fieldName).
            
            if primitiveName <> 'JsonArray' and primitiveName <> 'JsonObject' then do:
                addHeader(fieldName, primitiveName).
            end.    
        end.
    end method.
    
    method public override void loadData(input-output pSource as Progress.Lang.Object):
        define variable defaultBuffer as handle no-undo.
        define variable bufferField as handle no-undo.
        define variable currentJson as JsonObject no-undo.
        define variable idx as integer no-undo.
        define variable idy as integer no-undo.
        define variable fieldNames as character extent no-undo.
        define variable fieldName as character no-undo.
        define variable jsonParameter as Progress.Lang.ParameterList no-undo.
        define variable callerMethod as Progress.Reflect.Method no-undo.
        
        assign 
            defaultBuffer = resultTempTable:default-buffer-handle
            fieldNames = getFieldNames().
        
        do idx = 1 to json:length:
            defaultBuffer:buffer-create.
            assign currentJson = json:getJsonObject(idx).
            
            do idy = 1 to fieldCounter:
                assign
                    fieldName = fieldNames[idy]
                    jsonParameter = JsonMethodParameter:getParameter(fieldName)
                    callerMethod = JsonMethod:getMethod(currentJson, fieldName)
                    bufferField = defaultBuffer:buffer-field(fieldName)
                    bufferField:buffer-value = callerMethod:invoke(currentJson, jsonParameter).
            end.
        end.
    end method.
end class.
