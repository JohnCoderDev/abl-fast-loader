# ABL FastLoader

Simpler way to import data to your tables with less code.

## QuickStart

```progress
using classes.FastLoader.* from propath.

// get some json array ...


// imports the json array to the table
new FastLoader()
    :setSource(jsonArray, 'JsonArray')
    :initTarget('some-table')
        :addKeyField('key-field-1')
    :finish()
    :loadToTable().

```
