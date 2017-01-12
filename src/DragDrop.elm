module DragDrop
    exposing
        ( Msg(..)
        , Model
        , Config
        , initialModel
        , update
        , onDrag
        , onDragStart
        , onDragEnter
        , onDragOver
        , onDrop
        , onDragEnd
        )

{-|
Allow ordering multiple items by draggin and drop.
@docs Msg,  Model, Config, initialModel, update
@docs onDrag, onDragStart, onDragEnter, onDragOver, onDrop, onDragEnd
-}

import Html exposing (Attribute)
import Html.Events exposing (..)
import Json.Decode as Decode


{-|
Msg to hold the dragging state
-}
type Msg a
    = DragStart a
    | DragEnter a
    | Drop a
    | DragEnd a
    | DragOver a
    | AddTarget a
    | UpdateTargets (List a)
    | UpdateTarget a


{-|

-}
type alias Model a =
    { dragging : Maybe a
    , hovering : Maybe a
    , targets : List a
    }


{-|
-}
type alias Config comparable a =
    { setOrder : comparable -> a -> a
    , getOrder : a -> comparable
    }


{-|
-}
initialModel : List a -> Model a
initialModel targets =
    Model Nothing Nothing targets


{-|
   Update
   @doc getOrder (Maybe a -> comparable)
   @doc setOrder (comparable -> comparable -> a -> a)
-}
update : Config comparable a -> Msg a -> Model a -> ( Model a, Cmd (Msg a) )
update config msg model =
    case msg of
        DragStart a ->
            { model | dragging = Just a } ! []

        DragEnter a ->
            { model | hovering = Just a } ! []

        DragOver a ->
            model ! []

        Drop dropped ->
            case model.dragging of
                Just dragged ->
                    { model | targets = List.map (swapOrder config dragged dropped) model.targets } ! []

                _ ->
                    model ! []

        DragEnd a ->
            { model | dragging = Nothing, hovering = Nothing } ! []

        UpdateTargets targets ->
            { model | targets = targets } ! []

        UpdateTarget selected ->
            { model | targets = List.map (updateTarget config selected) model.targets } ! []

        AddTarget target ->
            let
                newTargets =
                    List.append model.targets (target :: [])
            in
                { model | targets = newTargets } ! []


swapOrder : Config comparable a -> a -> a -> a -> a
swapOrder config dragged dropped target =
    let
        droppedOrder =
            config.getOrder dropped

        draggedOrder =
            config.getOrder dragged

        targetOrder =
            config.getOrder target
    in
        if targetOrder == droppedOrder then
            config.setOrder draggedOrder target
        else if targetOrder == draggedOrder then
            config.setOrder droppedOrder target
        else
            target


updateTarget : Config comparable a -> a -> a -> a
updateTarget config selected target =
    let
        selectedOrder =
            config.getOrder selected

        targetOrder =
            config.getOrder target
    in
        if selectedOrder == targetOrder then
            selected
        else
            target



{-
   https://github.com/wintvelt/elm-html5-drag-drop/blob/master/src/DragEvents.elm
-}


{-|
Handles drag dom event
-}
onDrag : msg -> Attribute msg
onDrag msg =
    onDragHelper "drag" msg


{-|
Handles onenter dom event
-}
onDragEnter : msg -> Attribute msg
onDragEnter msg =
    onDragHelper "dragenter" msg


{-|
Handles dragover dom event
-}
onDragOver : msg -> Attribute msg
onDragOver msg =
    onPreventHelper "dragover" msg


{-|
Handles dragstart dom event
-}
onDragStart : msg -> Attribute msg
onDragStart msg =
    onDragHelper "dragstart" msg


{-|
Handles drop dom event
-}
onDrop : msg -> Attribute msg
onDrop msg =
    onPreventHelper "drop" msg


{-|
Handles dragEnd dom event
-}
onDragEnd : msg -> Attribute msg
onDragEnd msg =
    onDragHelper "dragend" msg


{-|
Helper function for just firing msg
-}
onDragHelper : String -> msg -> Attribute msg
onDragHelper nativeEvent msg =
    onWithOptions nativeEvent
        { preventDefault = False
        , stopPropagation = False
        }
        (Decode.succeed msg)


{-|
Helper function when need to preventDefault
-}
onPreventHelper : String -> msg -> Attribute msg
onPreventHelper nativeEvent msg =
    onWithOptions nativeEvent
        { preventDefault = True
        , stopPropagation = False
        }
        (Decode.succeed msg)
