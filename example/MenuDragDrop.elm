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
    { items : List ListItem
    , dragDropState : DragDrop.State ListItem
    }


initialModel : Model
initialModel =
    { items = items
    , dragDropState = DragDrop.initialState
    }



-- UPDATE


type Msg
    = DragDrop ListItem ListItem
    | DragDropMsg (DragDrop.Msg ListItem)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DragDrop dragged hovered ->
            let
                swapped =
                    List.map (swapOrder dragged.order hovered.order) model.items
            in
                { model | items = swapped } ! []

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


swapOrder : Int -> Int -> ListItem -> ListItem
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
            List.sortBy (\target -> target.order) model.items
    in
        div
            [ class "columns"
            , style
                [ ( "display", "flex" )
                , ( "flex-direction", "column" )
                , ( "width", "400px" )
                ]
            ]
            (List.map (imageView model) sorted)


imageView : Model -> ListItem -> Html Msg
imageView { dragDropState } item =
    let
        base =
            [ ( "display", "flex" )
            , ( "flex-direction", "column" )
            , ( "padding", "5px" )
            , ( "margin", "5px 0" )
            , ( "border", "2px solid green" )
            , ( "border-radius", "5px" )
            , ( "background", "#DDD" )
            , ( "cursor", "move" )
            ]

        draggedStyle =
            [ ( "opacity", "0.4" ) ]

        hoveredStyle =
            [ ( "border", "2px dashed #000" ) ]

        dragDropStyle =
            case ( dragDropState.dragging, dragDropState.hovering ) of
                ( Just dragged, Just hovered ) ->
                    if item == dragged then
                        draggedStyle
                    else if item == hovered then
                        hoveredStyle
                    else
                        []

                ( Just dragged, Nothing ) ->
                    if item == dragged then
                        draggedStyle
                    else
                        []

                _ ->
                    []

        style_ =
            base ++ dragDropStyle
    in
        Html.map DragDropMsg (DragDrop.view config style_ item)


config : DragDrop.Config ListItem Msg
config =
    DragDrop.Config
        { onDrop = DragDrop
        , htmlTag = "div"
        , attributes = attrHelper
        , children = childHelper
        }



-- attrHelper : Image -> List ( String, String )


attrHelper : ListItem -> List (Attribute msg)
attrHelper image =
    [ width 150
    , height 40
    ]


childHelper : ListItem -> Html msg
childHelper item =
    text (item.id ++ ": " ++ item.title)



-- IMAGE


type alias ListItem =
    { id : String
    , order : Int
    , title : String
    }


items : List ListItem
items =
    [ ListItem "0" 0 "Goto Tokyo"
    , ListItem "1" 1 "Goto Osaka"
    , ListItem "2" 2 "Goto Nagoya"
    , ListItem "3" 3 "Goto Fukuoka"
    , ListItem "4" 4 "Goto Hokkaido"
    , ListItem "5" 5 "Goto Kyoto"
    , ListItem "6" 6 "Goto Saitama"
    , ListItem "7" 7 "Goto Kaga"
    , ListItem "8" 8 "Goto Kagawa"
    , ListItem "9" 9 "Goto Hiroshima"
    ]
