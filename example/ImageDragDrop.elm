module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import DragDrop


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- Model


type alias Model =
    { images : List Image
    , dragDropState : DragDrop.State Image
    }


initialModel : Model
initialModel =
    { images = images
    , dragDropState = DragDrop.initialState
    }



-- UPDATE


type Msg
    = DragDrop Image Image
    | DragDropMsg (DragDrop.Msg Image)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DragDrop dragged hovered ->
            let
                swapped =
                    List.map (swapOrder dragged.order hovered.order) model.images
            in
                { model | images = swapped } ! []

        DragDropMsg childMsg ->
            let
                ( updated, maybeMsg ) =
                    DragDrop.update config childMsg model.dragDropState

                newModel =
                    { model | dragDropState = updated }
            in
                case maybeMsg of
                    Nothing ->
                        newModel ! []

                    Just updateMsg ->
                        update updateMsg newModel


swapOrder : Int -> Int -> Image -> Image
swapOrder draggedOrder hoveredOrder image =
    if image.order == draggedOrder then
        { image | order = hoveredOrder }
    else if image.order == hoveredOrder then
        { image | order = draggedOrder }
    else
        image



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ imageListView model ]


imageListView : Model -> Html Msg
imageListView model =
    let
        sorted =
            List.sortBy (\target -> target.order) model.images
    in
        div
            [ class "columns"
            , style
                [ ( "display", "flex" )
                , ( "flex-direction", "column" )
                ]
            ]
            [ div [ style [ ( "display", "flex" ) ] ]
                (List.map (imageView model) <| List.take 5 sorted)
            , div [ style [ ( "display", "flex" ) ] ]
                (List.map (imageView model) <| List.drop 5 sorted)
            ]


imageView : Model -> Image -> Html Msg
imageView { dragDropState } image =
    let
        base =
            [ ( "display", "flex" )
            , ( "flex-direction", "column" )
            , ( "padding", "5px" )
            , ( "border", "2px solid #FFF" )
            ]

        draggedStyle =
            [ ( "opacity", "0.4" ) ]

        hoveredStyle =
            [ ( "border", "2px dashed #000" ) ]

        dragDropStyle =
            case ( dragDropState.dragging, dragDropState.hovering ) of
                ( Just dragged, Just hovered ) ->
                    if image == dragged then
                        draggedStyle
                    else if image == hovered then
                        hoveredStyle
                    else
                        []

                ( Just dragged, Nothing ) ->
                    if image == dragged then
                        draggedStyle
                    else
                        []

                _ ->
                    []

        style_ =
            base ++ dragDropStyle
    in
        div [ style base ]
            [ Html.map DragDropMsg (DragDrop.view config style_ image)
            , div []
                [ text <| "id : " ++ image.id ]
            ]


config : DragDrop.Config Image Msg
config =
    DragDrop.Config
        { onDrop = DragDrop
        , htmlTag = "img"
        , attributes = attrHelper
        , children = childHelper
        }



-- attrHelper : Image -> List ( String, String )


attrHelper : Image -> List (Attribute msg)
attrHelper image =
    [ src image.src
    , width 150
    , height 150
    ]


childHelper : Image -> Html msg
childHelper image =
    text ""



-- IMAGE


type alias Image =
    { id : String
    , order : Int
    , src : String
    }


images : List Image
images =
    [ Image "0" 0 "/images/a.png"
    , Image "1" 1 "/images/b.png"
    , Image "2" 2 "/images/c.png"
    , Image "3" 3 "/images/d.png"
    , Image "4" 4 "/images/e.png"
    , Image "5" 5 "/images/f.png"
    , Image "6" 6 "/images/g.png"
    , Image "7" 7 "/images/h.png"
    , Image "8" 8 "/images/i.png"
    , Image "9" 9 "/images/j.png"
    ]
