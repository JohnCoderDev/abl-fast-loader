block-level on error undo, throw.
using Progress.Json.ObjectModel.* from propath.

class classes.FastLoader.Shared.JsonPrimitive:
    method public static character getPrimitive(pJson as JsonObject, pFieldName as character):
        define variable fieldType as integer no-undo.
        define variable primitiveType as character no-undo.
        assign 
            fieldType = pJson:getType(pFieldName)
            primitiveType = getCorrespondentPrimitive(fieldType).
        
        if primitiveType = 'character' then do:
            return correctCharType(pJson:getCharacter(pFieldName)).
        end.
        
        return primitiveType.
    end method.
    
    method public static character getPrimitive(pJson as JsonArray, pPosition as integer):
        define variable positionType as integer no-undo.
        define variable primitiveType as character no-undo.
        
        assign
            positionType = pJson:getType(pPosition)
            primitiveType = getCorrespondentPrimitive(positionType).
        
        if primitiveType = 'character' then do:
            return correctCharType(pJson:getCharacter(pPosition)).
        end.
        
        return primitiveType.
    end method.
    
    method private static character getCorrespondentPrimitive(pJsonType as integer):
        case pJsonType:
            when JsonDataType:String then do:
                return 'character'.
            end.
            when JsonDataType:Number then do:
                return 'decimal'.
            end.
            when JsonDataType:Boolean then do:
                return 'logical'.
            end.
            when JsonDataType:Array then do:
                return 'JsonArray'.
            end.
            when JsonDataType:Object then do:
                return 'JsonObject'.
            end.    
        end case.
    end method.
    
    method private static character correctCharType(pFieldValue as character):
        if pFieldValue matches '....-..-..T..:..:..*' then do:
            return 'datetime'.
        end.
        else if pFieldValue matches '....-..-..' then do:
            return 'date'.
        end.
        
        return 'character'.
    end method.
end class.
