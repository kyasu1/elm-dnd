module DragDrop.Events exposing (..)

import Html exposing (Attribute)
import Html.Events exposing (..)
import Json.Decode as Decode


{-
   https://github.com/wintvelt/elm-html5-drag-drop/blob/master/src/DragEvents.elm
-}


onDrag : msg -> Attribute msg
onDrag msg =
    onDragHelper "drag" msg


onDragEnter : msg -> Attribute msg
onDragEnter msg =
    onDragHelper "dragenter" msg


onDragOver : msg -> Attribute msg
onDragOver msg =
    onPreventHelper "dragover" msg


onDragStart : msg -> Attribute msg
onDragStart msg =
    onDragHelper "dragstart" msg


onDrop : msg -> Attribute msg
onDrop msg =
    onPreventHelper "drop" msg


onDragHelper : String -> msg -> Attribute msg
onDragHelper nativeEvent msg =
    onWithOptions nativeEvent
        { preventDefault = False
        , stopPropagation = False
        }
        (Decode.succeed msg)


onPreventHelper : String -> msg -> Attribute msg
onPreventHelper nativeEvent msg =
    onWithOptions nativeEvent
        { preventDefault = True
        , stopPropagation = False
        }
        (Decode.succeed msg)
