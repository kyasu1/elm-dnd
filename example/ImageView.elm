module ImageView exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import DragDrop exposing (Msg(..), Model, onDrag, onDragStart, onDragEnter, onDragOver, onDrop)
import Model exposing (Image)


view : Model Image -> Html (Msg Image)
view model =
    div [ class "container" ]
        [ viewTargets model ]


viewTargets : Model Image -> Html (Msg Image)
viewTargets model =
    let
        sorted =
            List.sortBy (\target -> target.order) model.targets
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


viewTarget : Model Image -> Image -> Html (Msg Image)
viewTarget model target =
    let
        base =
            [ ( "display", "flex" )
            , ( "flex-direction", "column" )
            ]

        style_ =
            case model.dragging of
                Just dragged ->
                    if dragged == target then
                        [ ( "opacity", "0.4" ) ]
                    else
                        []

                Nothing ->
                    []

        class_ =
            case model.hovering of
                Just hovered ->
                    if hovered == target then
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
                , onDragStart (DragStart target)
                , onDrop (Drop target)
                , onDragOver (DragOver target)
                , onDragEnter (DragEnter target)
                , style style_
                , src target.src
                , width 100
                , height 100
                ]
                []
            , div []
                [ text target.id ]
            ]
