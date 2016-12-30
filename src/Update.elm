module DragDrop.Update exposing (update)

import DragDrop.Model exposing (..)


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
