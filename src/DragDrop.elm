module DragDrop
    exposing
        ( view
        , State
        , initialState
        , Config(Config)
        , Msg
        , update
        )

{-|
This library helps you create sortable elements by drag and drop.
Written by following *reusable views* API design described in
[evancz/elm-sortable-table]: https://github.com/evancz/elm-sortable-table

# View

@docs view

# Configuration

@docs Config

# State

@docs State, initialState

# Update

@docs Msg, update
-}

import Html exposing (Html, Attribute)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode


{-|
Msg to hold the dragging state
-}
type Msg a
    = DragStart a
    | DragEnter a
    | DragLeave a
    | Drop a
    | DragEnd a
    | DragOver a



-- STATE


{-| Tracks dragging and hovering dom element.
-}
type alias State a =
    { dragging : Maybe a
    , hovering : Maybe a
    }


{-| Create a dragging state, no dom elmeent is selected at the beginning.
-}
initialState : State a
initialState =
    State Nothing Nothing



-- CONFIG


{-| **Note:** The `Config` should *never* be held in your model.
It should only appear in `view` and `update` code.
-}
type Config a msg
    = Config
        { onDrop : a -> a -> msg
        , htmlTag : String
        , attributes : a -> List (Attribute (Msg a))
        , children : a -> Html (Msg a)
        }


{-| Create the `Config` for your `view` and `update` function.

    import DragDrop

    type Msg = DragDrop Image Image | ...

    config : DragDrop.Config Image Msg
    config =
      DragDrop.config
        { onDrop = DragDrop
        , htmlTag = "img"
        , attributes = (\image -> [("src", image.src)])
        , children = (\image -> div [] [text image.id])
        }

You provide the following infomation in you configuration:

  - `onDrop` &mdash; call back Msg that is called when drop event fired.
  - `htmlTag` &mdash; name of html tag to be draggable
  - `attributes` &mdash; list of extra attributes for the draggable element.
  - `children` &mdash; child nodes to be rendered in the draggable element.
-}
config :
    { onDrop : a -> a -> msg
    , htmlTag : String
    , attributes : a -> List (Attribute (Msg a))
    , children : a -> Html (Msg a)
    }
    -> Config a msg
config { onDrop, htmlTag, attributes, children } =
    Config
        { onDrop = onDrop
        , htmlTag = htmlTag
        , attributes = attributes
        , children = children
        }


{-|
   Update
-}
update : Config a msg -> Msg a -> State a -> ( State a, Maybe msg )
update (Config { onDrop }) msg model =
    case msg of
        DragStart dragged ->
            ( { model | dragging = Just dragged }, Nothing )

        DragEnter hovered ->
            ( { model | hovering = Just hovered }, Nothing )

        DragLeave _ ->
            ( { model | hovering = Nothing }, Nothing )

        DragOver _ ->
            ( model, Nothing )

        Drop dropped ->
            let
                updated =
                    { model | dragging = Nothing, hovering = Nothing }
            in
                case model.dragging of
                    Just dragged ->
                        ( updated, Just <| onDrop dragged dropped )

                    _ ->
                        ( updated, Nothing )

        DragEnd _ ->
            ( { model | dragging = Nothing, hovering = Nothing }, Nothing )



-- VIEW


{-| Accepts extra list of css styles to dynamicaly change the style and the model.
TODO: Probably should also accepts extra class for dynamic change.
-}
view : Config a msg -> List ( String, String ) -> a -> Html (Msg a)
view (Config { attributes, htmlTag, children }) style_ data =
    Html.node htmlTag
        (List.append
            [ draggable "true"
            , onDragStart (DragStart data)
              -- a hack to support Firefox
              --
            , attribute "ondragstart" "event.dataTransfer.setData(\"text/plain\", \"dummy\")"
            , onDrop (Drop data)
              -- , onDragOver (DragOver data)
              -- a hack for preventing dragover events overwhelm update msg
              -- https://medium.com/elm-shorts/html5-drag-and-drop-in-elm-88d149d3558f#.ak3n9ymcc
            , attribute "ondragover" "return false"
            , onDragEnter (DragEnter data)
            , onDragLeave (DragLeave data)
            , onDragEnd (DragEnd data)
            , style style_
            ]
            (attributes data)
        )
        [ children data ]



{-
   EVENT HANDLERS

   Copied from the next URL
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


{-| Hndles dragleave dom event
-}
onDragLeave : msg -> Attribute msg
onDragLeave msg =
    onDragHelper "dragleave" msg


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
