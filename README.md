# Elm Drag and Drop Library
The purpose of this library is providing a functionality that allow us to reorder multiple block components by dragging and dropping.

(img)

## How to use
Prepare a model which will be the content of the draggable items. Since this library does not care about what are contained, you can provide a model with any fields you want. Also you need to supply two functions to the update function, the one is for setting the order, the other one is for getting the order from the Model. Finally you supply a View for your purpose.

## Example
In my usage,
### Model
At mentioned in the above, the model can include any fields but you need to supply a comparable field for the ordering. For example, in the next model, we defined the `order : Int` but any comparable data type can be used.

''type alias Image =
''     { id : String
''     , order : Int
''     , src : String
''     }

### Update
The next function is used when reordering items in the library model. The first and second arguments are indexes of the items to be exchanged. The third and  the return value is the model.
''setOrder : comparable -> comparable -> a -> a

Also we need a function to extract the comparable value from the Model.
''getOrder : Maybe a -> comparable

### View
Under construction…
