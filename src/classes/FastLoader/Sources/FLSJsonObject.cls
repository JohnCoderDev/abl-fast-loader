block-level on error undo, throw.
using Progress.Json.ObjectModel.* from propath.
using classes.FastLoader.Shared.* from propath.

class classes.FastLoader.Sources.FLSJsonObject inherits classes.FastLoader.Interfaces.ASourceLoader:
    define private property json as JsonObject get. set.
    
    constructor FLSJsonObject():
        super().
    end constructor.
    
    method public override void loadHeaders(input-output pSource as Progress.Lang.Object):
        define variable idx as integer no-undo.
        define variable fieldType as integer no-undo.
        define variable primitiveName as character no-undo.
        define variable fieldName as character no-undo.
        define variable jsonKeys as character extent no-undo.
        
        assign 
            json = cast(pSource, JsonObject)
            jsonKeys = json:getNames().
            
        do idx = 1 to extent(jsonKeys):
            assign 
                fieldName = jsonKeys[idx]
                fieldType = json:getType(fieldName)
                primitiveName = JsonPrimitive:getPrimitive(json, fieldName).
            
            if primitiveName <> 'JsonArray' and primitiveName <> 'JsonObject' then do:
                addHeader(fieldName, primitiveName).
            end.    
        end.
    end method.
    
    method public override void loadData(input-output pSource as Progress.Lang.Object):
        define variable defaultBuffer as handle no-undo.
        define variable bufferField as handle no-undo.
        define variable fieldNames as character extent no-undo.
        define variable fieldName as character no-undo.
        define variable callerMethod as Progress.Reflect.Method no-undo.
        define variable jsonParameter as Progress.Lang.ParameterList no-undo.
        define variable idx as integer no-undo.
        
        assign 
            defaultBuffer = resultTempTable:default-buffer-handle
            fieldNames = getFieldNames().
            
        defaultBuffer:buffer-create.
        
        do idx = 1 to fieldCounter:
            assign
                fieldName = fieldNames[idx]
                jsonParameter = JsonMethodParameter:getParameter(fieldName)
                callerMethod = JsonMethod:getMethod(json, fieldName)
                bufferField = defaultBuffer:buffer-field(fieldName)
                bufferField:buffer-value = callerMethod:invoke(json, jsonParameter).
        end.
    end method.
end class.
