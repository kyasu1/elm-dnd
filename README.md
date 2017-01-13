# Elm Drag and Drop Library
This library helps easily create a list of dom elements which can be sortable by drag and drop. The API design follows *reusable views* described in [evancz/elm-sortable-table]: https://github.com/evancz/elm-sortable-table.

## How to use
Prepare a model which will be the content of the draggable target. Since this library does not care about what are contained, you can provide a model with any fields you want but including a field to compare the ordering. Also you need to supply two functions for the update function, the one is for setting the order, the other one is for getting the order from the Model. Finally you supply a View for your purpose.

## Example
<img width="808" alt="2016-12-31 0 19 08" src="https://cloud.githubusercontent.com/assets/890106/21567833/be6d2f28-cef2-11e6-82bf-471ba5af68a7.png">

### Config
Create the `Config` for your `view` and `update` function.
```
import DragDrop

type Msg = DragDrop Image Image | ...

config : DragDrop.Config Image Msg
config =
  DragDrop.config
    { onDrop = DragDrop
    , htmlTag = "img"
    , attributes = (\image -> [("src", image.src)])
    }
```
You provide the following infomation in you configuration:

  - `onDrop` &mdash; send a Msg with your data of dragged and dropped when drop event fired.
  - `htmlTag` &mdash; name of html tag to be rendered, which will be draggable.
  - `attributes` &mdash; list of extra attributes for the draggable element.

### Model
The model holds list of your data and `State` of DragDrop library.
```
type alias Model =
    { images : List Image
    , dragDropState : DragDrop.State Image
    }
```
Your data is stored seprately from the library, you can provide any shape of your need.
```
type alias Image =
     { id : String
     , order : Int
     , src : String
     }
```
### Update
```
type Msg
    = DragDrop Image Image
    | DragDropMsg (DragDrop.Msg Image)
```    
  - `DragDrop` &mdash; called when drop event is fired, in the update you need to swap dragged and dropped elements in you model.
  - `DragDropMsg` &mdash; map child message from parent to child.

### View
```
imageView : Model -> Image -> Html Msg
imageView { dragDropState } target =
    let
        base =
            [ ( "display", "flex" )
            , ( "flex-direction", "column" )
            , ( "padding", "5px" )
            , ( "border", "2px solid #FFF" )
            ]

        dragDropStyle =
            case ( dragDropState.dragging, dragDropState.hovering ) of
                ( Just dragged, Just hovered ) ->
                    if target == dragged then
                        [ ( "opacity", "0.4" ) ]
                    else if target == hovered then
                        [ ( "border", "2px dashed #000" ) ]
                    else
                        []

                _ ->
                    []

        style_ =
            base ++ dragDropStyle
    in
        div [ style base ]
            [ Html.map DragDropMsg (DragDrop.view config style_ target)
            , div []
                [ text <| "id : " ++ target.id ]
            ]
```
