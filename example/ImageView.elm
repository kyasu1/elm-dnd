module ImageView exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import DragDrop exposing (Msg(..), Model, DragState(..), Target, onDrag, onDragStart, onDragEnter, onDragOver, onDrop)
import Model exposing (Image)


view : Model Image -> Html (Msg Image)
view model =
    div [ class "container" ]
        [ viewTargets model ]


viewTargets : Model Image -> Html (Msg Image)
viewTargets model =
    let
        sorted =
            List.sortBy (\target -> target.data.order) model.targets
    in
        div
            [ class "columns"
            , style
                [ ( "display", "flex" )
                , ( "flex-direction", "column" )
                ]
            ]
            [ div [ style [ ( "display", "flex" ) ] ]
                (List.map (viewTarget model) <| List.take 5 sorted)
            , div [ style [ ( "display", "flex" ) ] ]
                (List.map (viewTarget model) <| List.drop 5 sorted)
            ]


viewTarget : Model Image -> Target Image -> Html (Msg Image)
viewTarget model target =
    let
        base =
            [ ( "display", "flex" )
            , ( "flex-direction", "column" )
            ]

        style_ =
            case model.state of
                Dragging id ->
                    if id == target.id then
                        [ ( "opacity", "0.4" ) ]
                    else
                        []

                Normal ->
                    []

        class_ =
            case model.hovering of
                Just id ->
                    if id == target.id then
                        "column over"
                    else
                        "column"

                Nothing ->
                    "column"
    in
        div [ style base ]
            [ img
                [ class class_
                , draggable "true"
                , id target.id
                , onDragStart (DragStart target.id)
                , onDrop (Drop target.id)
                , onDragOver (DragOver target.id)
                , onDragEnter (DragEnter target.id)
                , style style_
                , src target.data.src
                , width 100
                , height 100
                ]
                []
            , div []
                [ text target.id ]
            ]
