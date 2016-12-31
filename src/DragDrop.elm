module DragDrop
    exposing
        ( Msg(..)
        , DragState(..)
        , Model
        , Target
        , initialModel
        , update
        , onDrag
        , onDragStart
        , onDragEnter
        , onDragOver
        , onDrop
        )

{-|
Allow ordering multiple items by draggin and drop.
@docs Msg, DragState, Model, Target, initialModel, update
@docs onDrag, onDragStart, onDragEnter, onDragOver, onDrop
-}

import Html exposing (Attribute)
import Html.Events exposing (..)
import Json.Decode as Decode


{-|
Msg to hold the dragging state
-}
type Msg data
    = DragStart String
    | DragEnter String
    | Drop String
    | DragOver String
    | AddTarget (Target data)


type DragState
    = Normal
    | Dragging String


{-|

-}
type alias Model data =
    { state : DragState
    , hovering : Maybe String
    , targets : List (Target data)
    }


{-|
-}
type alias Target data =
    { id : String
    , data : data
    }


{-|
-}
initialModel : List (Target a) -> Model a
initialModel targets =
    Model Normal Nothing targets


{-|
   Update
   @doc getOrder (Maybe a -> comparable)
   @doc setOrder (comparable -> comparable -> a -> a)
-}
update : (Maybe a -> comparable) -> (comparable -> comparable -> a -> a) -> Msg a -> Model a -> ( Model a, Cmd (Msg a) )
update getOrder setOrder msg model =
    ( updateModel getOrder setOrder msg model, updateCmd msg model )


swapOrder : (comparable -> comparable -> a -> a) -> comparable -> comparable -> Target a -> Target a
swapOrder setOrder left right target =
    { target | data = setOrder left right target.data }


findOrder : (Maybe a -> comparable) -> String -> List (Target a) -> comparable
findOrder getOrder id targets =
    List.filter (\target -> target.id == id) targets
        |> List.head
        |> Maybe.map .data
        |> getOrder


updateModel : (Maybe a -> comparable) -> (comparable -> comparable -> a -> a) -> Msg a -> Model a -> Model a
updateModel getOrder setOrder msg model =
    case msg of
        DragStart id ->
            { model | state = Dragging id }

        DragEnter id ->
            { model | hovering = Just id }

        DragOver id ->
            model

        Drop droppedId ->
            case model.state of
                Dragging id ->
                    let
                        l =
                            findOrder getOrder id model.targets

                        r =
                            findOrder getOrder droppedId model.targets
                    in
                        { model
                            | state = Normal
                            , hovering = Nothing
                            , targets = List.map (swapOrder setOrder l r) model.targets
                        }

                _ ->
                    model

        AddTarget target ->
            let
                newTargets =
                    List.append model.targets (target :: [])
            in
                { model | targets = newTargets }


updateCmd : Msg a -> Model a -> Cmd (Msg a)
updateCmd msg model =
    case msg of
        _ ->
            Cmd.none



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
